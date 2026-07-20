// =============================================================================
// spi_buffer_ctrl.v
// SPI Buffer Controller
//
// Sits between the SPI slave byte interface and the crypto FSM.
// Parses incoming packet, fills key/nonce/plaintext buffers,
// signals the FSM, then streams the result back over SPI.
//
// Packet format (bytes received over MOSI):
//   Byte 0      : CMD  (0x01 = SHA-256 | 0x02 = Ascon)
//   Byte 1      : DATA_LEN (plaintext/message length in bytes, max 32)
//   Bytes 2-17  : KEY   (16 bytes, Ascon only -- skipped for SHA-256)
//   Bytes 18-33 : NONCE (16 bytes, Ascon only -- skipped for SHA-256)
//   Bytes N+    : DATA  (plaintext or message, DATA_LEN bytes)
//
// After crypto finishes the result is streamed back over MISO:
//   Ascon  : ciphertext (DATA_LEN bytes) + tag (16 bytes)
//   SHA-256: digest (32 bytes)
// =============================================================================

module spi_buffer_ctrl (
    input  wire        clk,
    input  wire        rst_n,

    // From SPI slave
    input  wire [7:0]  rx_byte,
    input  wire        rx_valid,   // 1-cycle pulse per received byte
    input  wire        byte_done,  // 1-cycle pulse per 8-bit transfer (for TX timing)

    // To SPI slave TX
    output reg  [7:0]  tx_byte,
    output reg         tx_load,    // pulse to load tx_byte into SPI TX shift reg

    // To Crypto FSM
    output reg  [127:0] key_out,         // 128-bit key  (Ascon)
    output reg  [127:0] nonce_out,       // 128-bit nonce (Ascon)
    output reg  [255:0] plaintext_out,   // up to 32 bytes
    output reg  [7:0]   data_len_out,    // actual data length
    output reg          cmd_sha256,      // high = SHA-256
    output reg          cmd_ascon,       // high = Ascon
    output reg          data_ready,      // pulse: all inputs received, start crypto

    // From Crypto FSM
    input  wire [255:0] result_in,       // ciphertext+tag or digest (packed, MSB first)
    input  wire [7:0]   result_len,      // number of bytes to send back
    input  wire         result_valid,    // pulse: crypto done, result_in is valid

    // Status
    output reg          busy
);

    // -------------------------------------------------------------------------
    // State encoding
    // -------------------------------------------------------------------------
    localparam S_IDLE        = 4'd0;
    localparam S_RX_LEN      = 4'd1;
    localparam S_RX_KEY      = 4'd2;
    localparam S_RX_NONCE    = 4'd3;
    localparam S_RX_DATA     = 4'd4;
    localparam S_WAIT_CRYPTO = 4'd5;
    localparam S_TX_LOAD     = 4'd6;
    localparam S_TX_RESULT   = 4'd7;

    localparam CMD_SHA256 = 8'h01;
    localparam CMD_ASCON  = 8'h02;

    reg [3:0]  state;
    reg [4:0]  byte_idx;      // counts bytes received/sent (max 32)

    // Latch result so it doesn't change under us during TX
    reg [255:0] result_latch;
    reg [7:0]   result_len_latch;

    // -------------------------------------------------------------------------
    // Main FSM
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state            <= S_IDLE;
            byte_idx         <= 5'd0;
            cmd_sha256       <= 1'b0;
            cmd_ascon        <= 1'b0;
            data_ready       <= 1'b0;
            tx_load          <= 1'b0;
            tx_byte          <= 8'hFF;
            busy             <= 1'b0;
            key_out          <= 128'd0;
            nonce_out        <= 128'd0;
            plaintext_out    <= 256'd0;
            data_len_out     <= 8'd0;
            result_latch     <= 256'd0;
            result_len_latch <= 8'd0;
        end else begin
            // Default pulse signals
            data_ready <= 1'b0;
            tx_load    <= 1'b0;

            case (state)

                // ---------------------------------------------------------
                // Wait for first byte = CMD
                // ---------------------------------------------------------
                S_IDLE: begin
                    busy      <= 1'b0;
                    byte_idx  <= 5'd0;
                    cmd_sha256<= 1'b0;
                    cmd_ascon <= 1'b0;

                    if (rx_valid) begin
                        busy <= 1'b1;
                        case (rx_byte)
                            CMD_SHA256: cmd_sha256 <= 1'b1;
                            CMD_ASCON : cmd_ascon  <= 1'b1;
                            default   : ; // unknown cmd, stay busy, wait for next byte
                        endcase
                        state <= S_RX_LEN;
                    end
                end

                // ---------------------------------------------------------
                // Second byte = data length
                // ---------------------------------------------------------
                S_RX_LEN: begin
                    if (rx_valid) begin
                        data_len_out <= rx_byte;
                        byte_idx     <= 5'd0;
                        // Ascon needs key + nonce first; SHA-256 goes straight to data
                        if (cmd_ascon)
                            state <= S_RX_KEY;
                        else
                            state <= S_RX_DATA;
                    end
                end

                // ---------------------------------------------------------
                // Receive 16-byte key (Ascon only)
                // ---------------------------------------------------------
                S_RX_KEY: begin
                    if (rx_valid) begin
                        // Shift in MSB first
                        key_out  <= {key_out[119:0], rx_byte};
                        byte_idx <= byte_idx + 1'b1;
                        if (byte_idx == 5'd15) begin
                            byte_idx <= 5'd0;
                            state    <= S_RX_NONCE;
                        end
                    end
                end

                // ---------------------------------------------------------
                // Receive 16-byte nonce (Ascon only)
                // ---------------------------------------------------------
                S_RX_NONCE: begin
                    if (rx_valid) begin
                        nonce_out <= {nonce_out[119:0], rx_byte};
                        byte_idx  <= byte_idx + 1'b1;
                        if (byte_idx == 5'd15) begin
                            byte_idx <= 5'd0;
                            state    <= S_RX_DATA;
                        end
                    end
                end

                // ---------------------------------------------------------
                // Receive plaintext / message
                // ---------------------------------------------------------
                S_RX_DATA: begin
                    if (rx_valid) begin
                        plaintext_out <= {plaintext_out[247:0], rx_byte};
                        byte_idx      <= byte_idx + 1'b1;
                        // Done when we have received data_len_out bytes
                        if (byte_idx == data_len_out - 1) begin
                            byte_idx   <= 5'd0;
                            data_ready <= 1'b1;  // signal FSM to start
                            state      <= S_WAIT_CRYPTO;
                        end
                    end
                end

                // ---------------------------------------------------------
                // Wait for crypto core to finish
                // ---------------------------------------------------------
                S_WAIT_CRYPTO: begin
                    if (result_valid) begin
                        result_latch     <= result_in;
                        result_len_latch <= result_len;
                        byte_idx         <= 5'd0;
                        state            <= S_TX_LOAD;
                    end
                end

                // ---------------------------------------------------------
                // Load first TX byte before first SCLK falling edge
                // ---------------------------------------------------------
                S_TX_LOAD: begin
                    // MSB of result is in bits [255:248]
                    tx_byte  <= result_latch[255:248];
                    tx_load  <= 1'b1;
                    byte_idx <= 5'd1;
                    state    <= S_TX_RESULT;
                end

                // ---------------------------------------------------------
                // Stream result bytes back over MISO
                // Load next byte after each byte_done pulse
                // ---------------------------------------------------------
                S_TX_RESULT: begin
                    if (byte_done) begin
                        if (byte_idx >= result_len_latch) begin
                            // All bytes sent
                            state    <= S_IDLE;
                            byte_idx <= 5'd0;
                        end else begin
                            // Shift result left by 8 to get next byte into [255:248]
                            result_latch <= result_latch << 8;
                            tx_byte      <= result_latch[247:240]; // next byte
                            tx_load      <= 1'b1;
                            byte_idx     <= byte_idx + 1'b1;
                        end
                    end
                end

                default: state <= S_IDLE;

            endcase
        end
    end

endmodule
