// =============================================================================
// spi_buffer_ctrl.v
// SPI Buffer Controller
//
// Sits between the SPI slave byte interface and the crypto FSM. Parses the
// incoming packet, fills the key/nonce/data buffers, signals the FSM, then
// streams the result back over MISO.
//
// -----------------------------------------------------------------------------
// PACKET FORMAT (bytes received over MOSI, one SPI frame)
//   Byte 0      : CMD       0x01 = SHA-256, 0x02 = Ascon-128
//   Byte 1      : DATA_LEN  message / plaintext length in bytes
//   Bytes 2-17  : KEY       16 bytes, Ascon only (absent for SHA-256)
//   Bytes 18-33 : NONCE     16 bytes, Ascon only (absent for SHA-256)
//   Bytes N+    : DATA      DATA_LEN bytes
//
// LENGTH LIMITS
//   SHA-256 : 0..32 bytes  (single 512-bit block, capped by the 256-bit port)
//   Ascon   : 0..16 bytes  (the 256-bit result carries 16 ciphertext bytes
//                           plus the 16-byte tag, so longer plaintext could
//                           not be returned intact)
//   A length outside these bounds, or an unrecognised CMD, raises `err` and
//   the frame is discarded rather than silently producing a wrong answer.
//
// RESULT READBACK (a SECOND SPI frame, after result_ready goes high)
//   Always 32 bytes, MSB first:
//     SHA-256 : digest[255:0]
//     Ascon   : ciphertext (16 bytes, zero-padded above DATA_LEN) || tag (16)
// -----------------------------------------------------------------------------
//
// FIXES IN THIS REVISION
//   1. byte_idx was 5 bits wide and the transmit loop exited on
//      `byte_idx >= result_len_latch` with result_len_latch = 32. A 5-bit
//      counter tops out at 31, so the comparison was never true: the FSM
//      streamed 32 correct bytes and then looped forever emitting zeros,
//      never returning to idle. Every command after the first was ignored.
//      byte_idx is now 6 bits.
//
//   2. Data bytes were accumulated by shifting into the LSB end, leaving the
//      message RIGHT-aligned. Both crypto cores expect it LEFT-aligned. The
//      two only agree when DATA_LEN is exactly 32, so short messages hashed
//      the wrong block. Bytes are now written to fixed left-aligned slots.
//
//   3. DATA_LEN = 0 hung the receive loop, because the terminating compare
//      was against DATA_LEN-1 = 0xFF. Zero-length input is now a valid
//      request that launches the core directly.
//
//   4. An unrecognised CMD left both command bits low and crypto_fsm ran
//      SHA-256 anyway. It is now rejected.
//
//   5. A frame that ends early (CS_N deasserted mid-packet) left the FSM
//      stuck in a receive state until the next reset. Receive states now
//      abort back to idle when the frame closes.
// =============================================================================

module spi_buffer_ctrl (
    input  wire         clk,
    input  wire         rst_n,

    // From the SPI slave
    input  wire [7:0]   rx_byte,
    input  wire         rx_valid,      // 1-cycle pulse per received byte
    input  wire         byte_done,     // 1-cycle pulse per 8-bit transfer
    input  wire         cs_active,     // high while the frame is open

    // To the SPI slave TX path
    output reg  [7:0]   tx_byte,
    output reg          tx_load,       // pulse: stage tx_byte for transmission

    // To the crypto FSM
    output reg  [127:0] key_out,       // 128-bit key   (Ascon)
    output reg  [127:0] nonce_out,     // 128-bit nonce (Ascon)
    output reg  [255:0] plaintext_out, // message / plaintext, LEFT-aligned
    output reg  [7:0]   data_len_out,  // actual data length in bytes
    output reg          cmd_sha256,    // high = SHA-256 selected
    output reg          cmd_ascon,     // high = Ascon selected
    output reg          data_ready,    // pulse: inputs valid, start the core

    // From the crypto FSM
    input  wire [255:0] result_in,     // digest, or ciphertext||tag
    input  wire [7:0]   result_len,    // number of bytes to send back
    input  wire         result_valid,  // pulse: result_in is valid

    // Status (for debug pads / FPGA observation)
    output reg          busy,          // high from CMD until the result is sent
    output reg          result_ready,  // high while a result is staged for readback
    output reg          err            // sticky: bad CMD or bad length
);

    // -------------------------------------------------------------------------
    // State encoding
    // -------------------------------------------------------------------------
    localparam S_IDLE        = 4'd0;
    localparam S_RX_LEN      = 4'd1;
    localparam S_RX_KEY      = 4'd2;
    localparam S_RX_NONCE    = 4'd3;
    localparam S_RX_DATA     = 4'd4;
    localparam S_LAUNCH      = 4'd5;   // one clean cycle to pulse data_ready
    localparam S_WAIT_CRYPTO = 4'd6;
    localparam S_TX_LOAD     = 4'd7;
    localparam S_TX_RESULT   = 4'd8;
    localparam S_ERROR       = 4'd9;   // drain the frame, then recover

    localparam CMD_SHA256 = 8'h01;
    localparam CMD_ASCON  = 8'h02;

    localparam MAX_LEN_SHA   = 8'd32;
    localparam MAX_LEN_ASCON = 8'd16;

    reg [3:0] state;
    reg [5:0] byte_idx;       // FIX 1: 6 bits, must be able to reach 32

    // Latch the result so it cannot change underneath us during transmission
    reg [255:0] result_latch;
    reg [7:0]   result_len_latch;

    // True while we are mid-packet and an early CS_N release should abort
    wire in_rx_phase = (state == S_RX_LEN)   || (state == S_RX_KEY) ||
                       (state == S_RX_NONCE) || (state == S_RX_DATA);

    // -------------------------------------------------------------------------
    // Main FSM
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state            <= S_IDLE;
            byte_idx         <= 6'd0;
            cmd_sha256       <= 1'b0;
            cmd_ascon        <= 1'b0;
            data_ready       <= 1'b0;
            tx_load          <= 1'b0;
            tx_byte          <= 8'hFF;
            busy             <= 1'b0;
            result_ready     <= 1'b0;
            err              <= 1'b0;
            key_out          <= 128'd0;
            nonce_out        <= 128'd0;
            plaintext_out    <= 256'd0;
            data_len_out     <= 8'd0;
            result_latch     <= 256'd0;
            result_len_latch <= 8'd0;
        end else begin
            // Default values for the single-cycle pulses
            data_ready <= 1'b0;
            tx_load    <= 1'b0;

            // FIX 5: a frame that closes mid-packet aborts cleanly
            if (in_rx_phase && !cs_active) begin
                state      <= S_IDLE;
                busy       <= 1'b0;
                byte_idx   <= 6'd0;
                cmd_sha256 <= 1'b0;
                cmd_ascon  <= 1'b0;
            end else begin

                case (state)

                    // -----------------------------------------------------
                    // Wait for the first byte of a frame: CMD
                    // -----------------------------------------------------
                    S_IDLE: begin
                        busy         <= 1'b0;
                        result_ready <= 1'b0;
                        byte_idx     <= 6'd0;
                        cmd_sha256   <= 1'b0;
                        cmd_ascon    <= 1'b0;

                        if (rx_valid) begin
                            busy <= 1'b1;
                            err  <= 1'b0;      // new command clears the flag

                            // Clear the data buffer so a shorter message can
                            // never inherit bytes from the previous one
                            plaintext_out <= 256'd0;
                            key_out       <= 128'd0;
                            nonce_out     <= 128'd0;

                            case (rx_byte)
                                CMD_SHA256: begin
                                    cmd_sha256 <= 1'b1;
                                    state      <= S_RX_LEN;
                                end
                                CMD_ASCON: begin
                                    cmd_ascon <= 1'b1;
                                    state     <= S_RX_LEN;
                                end
                                // FIX 4: unknown command is rejected outright
                                default: begin
                                    err   <= 1'b1;
                                    state <= S_ERROR;
                                end
                            endcase
                        end
                    end

                    // -----------------------------------------------------
                    // Second byte: data length, validated against the core
                    // -----------------------------------------------------
                    S_RX_LEN: begin
                        if (rx_valid) begin
                            byte_idx <= 6'd0;

                            if (rx_byte > (cmd_ascon ? MAX_LEN_ASCON
                                                     : MAX_LEN_SHA)) begin
                                err   <= 1'b1;
                                state <= S_ERROR;
                            end else begin
                                data_len_out <= rx_byte;

                                if (cmd_ascon)
                                    state <= S_RX_KEY;     // key and nonce first
                                else if (rx_byte == 8'd0)
                                    state <= S_LAUNCH;     // FIX 3: empty message
                                else
                                    state <= S_RX_DATA;
                            end
                        end
                    end

                    // -----------------------------------------------------
                    // 16-byte key (Ascon only), written MSB first
                    // -----------------------------------------------------
                    S_RX_KEY: begin
                        if (rx_valid) begin
                            key_out[{(4'd15 - byte_idx[3:0]), 3'b000} +: 8]
                                <= rx_byte;
                            if (byte_idx == 6'd15) begin
                                byte_idx <= 6'd0;
                                state    <= S_RX_NONCE;
                            end else begin
                                byte_idx <= byte_idx + 1'b1;
                            end
                        end
                    end

                    // -----------------------------------------------------
                    // 16-byte nonce (Ascon only), written MSB first
                    // -----------------------------------------------------
                    S_RX_NONCE: begin
                        if (rx_valid) begin
                            nonce_out[{(4'd15 - byte_idx[3:0]), 3'b000} +: 8]
                                <= rx_byte;
                            if (byte_idx == 6'd15) begin
                                byte_idx <= 6'd0;
                                state    <= (data_len_out == 8'd0) ? S_LAUNCH
                                                                   : S_RX_DATA;
                            end else begin
                                byte_idx <= byte_idx + 1'b1;
                            end
                        end
                    end

                    // -----------------------------------------------------
                    // Message / plaintext bytes
                    // FIX 2: written to fixed LEFT-aligned slots, so byte 0
                    // lands in plaintext_out[255:248] exactly as both cores
                    // expect, for every length rather than only for 32.
                    // -----------------------------------------------------
                    S_RX_DATA: begin
                        if (rx_valid) begin
                            if (byte_idx < 6'd32)
                                plaintext_out[{(5'd31 - byte_idx[4:0]), 3'b000} +: 8]
                                    <= rx_byte;

                            if (byte_idx == data_len_out[5:0] - 6'd1) begin
                                byte_idx <= 6'd0;
                                state    <= S_LAUNCH;
                            end else begin
                                byte_idx <= byte_idx + 1'b1;
                            end
                        end
                    end

                    // -----------------------------------------------------
                    // One settled cycle, then kick the crypto FSM
                    // -----------------------------------------------------
                    S_LAUNCH: begin
                        data_ready <= 1'b1;
                        state      <= S_WAIT_CRYPTO;
                    end

                    // -----------------------------------------------------
                    // Wait for the crypto core to finish
                    // -----------------------------------------------------
                    S_WAIT_CRYPTO: begin
                        if (result_valid) begin
                            result_latch     <= result_in;
                            result_len_latch <= result_len;
                            byte_idx         <= 6'd0;
                            state            <= S_TX_LOAD;
                        end
                    end

                    // -----------------------------------------------------
                    // Stage the first result byte before the master starts
                    // clocking the readback frame
                    // -----------------------------------------------------
                    S_TX_LOAD: begin
                        tx_byte      <= result_latch[255:248];
                        tx_load      <= 1'b1;
                        byte_idx     <= 6'd1;
                        result_ready <= 1'b1;
                        state        <= S_TX_RESULT;
                    end

                    // -----------------------------------------------------
                    // Stream the remaining result bytes back over MISO.
                    // One byte is staged per completed 8-bit transfer.
                    // -----------------------------------------------------
                    S_TX_RESULT: begin
                        if (byte_done) begin
                            if (byte_idx >= result_len_latch[5:0] ||
                                result_len_latch > 8'd32) begin
                                // Whole result sent, return to idle
                                state        <= S_IDLE;
                                byte_idx     <= 6'd0;
                                busy         <= 1'b0;
                                result_ready <= 1'b0;
                            end else begin
                                result_latch <= result_latch << 8;
                                tx_byte      <= result_latch[247:240];
                                tx_load      <= 1'b1;
                                byte_idx     <= byte_idx + 1'b1;
                            end
                        end
                    end

                    // -----------------------------------------------------
                    // Protocol error: let the master finish the frame, then
                    // recover. `err` stays set until the next valid command
                    // so it can be observed on a status pin or GPIO.
                    // -----------------------------------------------------
                    S_ERROR: begin
                        busy         <= 1'b0;
                        result_ready <= 1'b0;
                        if (!cs_active)
                            state <= S_IDLE;
                    end

                    default: state <= S_IDLE;

                endcase
            end
        end
    end

endmodule
