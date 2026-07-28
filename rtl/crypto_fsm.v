// =============================================================================
// crypto_fsm.v
// Crypto Core Router
//
// Sits between spi_top and the two crypto cores (ascon128, sha256).
// Instantiates both cores. When spi_buffer_ctrl signals data_ready,
// this module routes inputs to the correct core, waits for done,
// then sends the result back to spi_buffer_ctrl.
//
// Result packing (result_in is 256 bits = 32 bytes):
//   SHA-256 : result_in = digest[255:0]               result_len = 32
//   Ascon   : result_in = {ciphertext[255:128], tag}   result_len = 32
//             → first 16 bytes = ciphertext (supports up to 16-byte plaintext)
//             → last  16 bytes = 128-bit auth tag
//
// Note: Ascon plaintext is limited to 16 bytes on this chip because
//       the result bus is 256 bits. Ciphertext[127:0] is discarded
//       if plaintext exceeds 16 bytes. AD is not used (ad_len = 0).
//
// FSM: S_IDLE → S_START → S_WAIT → S_RESULT → S_IDLE
// =============================================================================

module crypto_fsm (
    input  wire        clk,
    input  wire        rst_n,

    // From spi_buffer_ctrl (via spi_top)
    input  wire [127:0] key,          // 128-bit key  (Ascon only)
    input  wire [127:0] nonce,        // 128-bit nonce (Ascon only)
    input  wire [255:0] plaintext,    // plaintext or message (both cores)
    input  wire [7:0]   data_len,     // length in bytes
    input  wire         cmd_sha256,   // high = SHA-256 requested
    input  wire         cmd_ascon,    // high = Ascon requested
    input  wire         data_ready,   // 1-cycle pulse: inputs are valid, start

    // To spi_buffer_ctrl (via spi_top)
    output reg  [255:0] result_in,    // result packed MSB-first
    output reg  [7:0]   result_len,   // bytes to send back (always 32)
    output reg          result_valid  // 1-cycle pulse: result_in is valid
);

    // =========================================================================
    // FSM State Encoding
    // =========================================================================
    localparam S_IDLE   = 2'd0;  // wait for data_ready
    localparam S_START  = 2'd1;  // pulse start to selected core
    localparam S_WAIT   = 2'd2;  // wait for done from selected core
    localparam S_RESULT = 2'd3;  // assert result_valid for 1 cycle

    reg [1:0] state;
    reg       sel_ascon;   // latched at data_ready: 1=Ascon, 0=SHA-256

    // =========================================================================
    // Ascon-128 core signals
    // =========================================================================
    reg          ascon_start;
    wire         ascon_busy;
    wire         ascon_done;
    wire [255:0] ascon_ct;
    wire [127:0] ascon_tag;

    ascon128 u_ascon (
        .clk        (clk),
        .rst_n      (rst_n),
        .start      (ascon_start),
        .busy       (ascon_busy),
        .done       (ascon_done),
        .key        (key),
        .nonce      (nonce),
        .ad         (256'd0),     // no AD on this chip
        .ad_len     (8'd0),
        .plaintext  (plaintext),
        .pt_len     (data_len),
        .ciphertext (ascon_ct),
        .tag        (ascon_tag)
    );

    // =========================================================================
    // SHA-256 core signals
    // =========================================================================
    reg          sha_start;
    wire         sha_busy;
    wire         sha_done;
    wire [255:0] sha_digest;

    sha256 u_sha256 (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (sha_start),
        .busy    (sha_busy),
        .done    (sha_done),
        .message (plaintext),
        .msg_len (data_len),
        .digest  (sha_digest)
    );

    // =========================================================================
    // Main FSM
    // =========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= S_IDLE;
            sel_ascon    <= 1'b0;
            ascon_start  <= 1'b0;
            sha_start    <= 1'b0;
            result_in    <= 256'd0;
            result_len   <= 8'd0;
            result_valid <= 1'b0;
        end else begin
            // Default: pulses are 1 cycle only
            ascon_start  <= 1'b0;
            sha_start    <= 1'b0;
            result_valid <= 1'b0;

            case (state)

                // ── Wait for spi_buffer_ctrl to signal data is ready ──
                S_IDLE: begin
                    if (data_ready) begin
                        sel_ascon <= cmd_ascon;  // latch which core to use
                        state     <= S_START;
                    end
                end

                // ── Pulse start to the correct core for 1 cycle ──
                S_START: begin
                    if (sel_ascon)
                        ascon_start <= 1'b1;
                    else
                        sha_start   <= 1'b1;
                    state <= S_WAIT;
                end

                // ── Wait for the selected core to finish ──
                S_WAIT: begin
                    if (sel_ascon && ascon_done) begin
                        // Pack Ascon result:
                        //   [255:128] = first 16 bytes of ciphertext
                        //   [127:  0] = 128-bit authentication tag
                        result_in  <= {ascon_ct[255:128], ascon_tag};
                        result_len <= 8'd32;
                        state      <= S_RESULT;
                    end
                    else if (!sel_ascon && sha_done) begin
                        // SHA-256 result: full 256-bit digest
                        result_in  <= sha_digest;
                        result_len <= 8'd32;
                        state      <= S_RESULT;
                    end
                end

                // ── Assert result_valid for 1 cycle, then return to idle ──
                S_RESULT: begin
                    result_valid <= 1'b1;
                    state        <= S_IDLE;
                end

                default: state <= S_IDLE;

            endcase
        end
    end

endmodule
