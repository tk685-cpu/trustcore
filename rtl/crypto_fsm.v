// =============================================================================
// crypto_fsm.v
// Crypto Core Router
//
// Sits between spi_top and the two crypto cores (ascon128, sha256).
// Instantiates both. When spi_buffer_ctrl pulses data_ready this module routes
// the inputs to the selected core, waits for done, then hands the packed
// result back to spi_buffer_ctrl.
//
// RESULT PACKING (result_in is 256 bits = 32 bytes, MSB first)
//   SHA-256 : digest[255:0]                       result_len = 32
//   Ascon   : {ciphertext[255:128], tag[127:0]}   result_len = 32
//             -> first 16 bytes = ciphertext (zero-padded above DATA_LEN)
//             -> last  16 bytes = 128-bit authentication tag
//
//   Ascon plaintext is therefore limited to 16 bytes. spi_buffer_ctrl enforces
//   that before a request reaches here; the check below is defence in depth.
//   Associated data is not exposed over the SPI protocol (ad_len tied to 0).
//
// DATA ALIGNMENT
//   `plaintext` arrives LEFT-aligned from spi_buffer_ctrl (first message byte
//   in plaintext[255:248]) which is what both cores require. No shifting is
//   done here.
//
// FSM: S_IDLE -> S_START -> S_WAIT -> S_RESULT -> S_IDLE
//
// FIXES IN THIS REVISION
//   1. sel_ascon was assigned straight from cmd_ascon, so a request with
//      neither command bit set silently ran SHA-256. Both bits are now
//      validated and an invalid combination returns a zeroed result with
//      `err` raised rather than a plausible-looking wrong answer.
//   2. If a core never asserted done the FSM waited forever and the whole
//      chip locked up until reset. A watchdog now bounds the wait.
// =============================================================================

module crypto_fsm #(
    // Watchdog limit in system clocks. The slowest real operation is SHA-256
    // at 83 clocks, so this is roughly a 50x margin.
    parameter TIMEOUT = 4096
) (
    input  wire         clk,
    input  wire         rst_n,

    // From spi_buffer_ctrl (via spi_top)
    input  wire [127:0] key,          // 128-bit key   (Ascon only)
    input  wire [127:0] nonce,        // 128-bit nonce (Ascon only)
    input  wire [255:0] plaintext,    // message / plaintext, LEFT-aligned
    input  wire [7:0]   data_len,     // length in bytes
    input  wire         cmd_sha256,   // high = SHA-256 requested
    input  wire         cmd_ascon,    // high = Ascon requested
    input  wire         data_ready,   // 1-cycle pulse: inputs valid, start

    // To spi_buffer_ctrl (via spi_top)
    output reg  [255:0] result_in,    // result packed MSB-first
    output reg  [7:0]   result_len,   // bytes to send back (always 32)
    output reg          result_valid, // 1-cycle pulse: result_in is valid
    output reg          err           // sticky: invalid request or timeout
);

    // =========================================================================
    // FSM State Encoding
    // =========================================================================
    localparam S_IDLE   = 2'd0;  // wait for data_ready
    localparam S_START  = 2'd1;  // pulse start to the selected core
    localparam S_WAIT   = 2'd2;  // wait for done from the selected core
    localparam S_RESULT = 2'd3;  // assert result_valid for one cycle

    // Width of the watchdog counter
    localparam TW = $clog2(TIMEOUT + 1);

    reg [1:0]    state;
    reg          sel_ascon;    // latched at data_ready: 1 = Ascon, 0 = SHA-256
    reg [TW-1:0] wdog;

    // A request is only valid if exactly one core was selected, and if an
    // Ascon request fits in the 16 ciphertext bytes the result bus provides.
    wire req_valid = (cmd_sha256 ^ cmd_ascon) &&
                     (cmd_ascon ? (data_len <= 8'd16) : (data_len <= 8'd32));

    // =========================================================================
    // Ascon-128 core
    // =========================================================================
    reg          ascon_start;
    wire         ascon_done;
    // Only ascon_ct[255:128] is returned; the low half is intentionally
    // unused because the 256-bit result bus carries 16 ciphertext bytes
    // plus the 16-byte tag. spi_buffer_ctrl rejects longer requests.
    /* verilator lint_off UNUSEDSIGNAL */
    wire [255:0] ascon_ct;
    /* verilator lint_on UNUSEDSIGNAL */
    wire [127:0] ascon_tag;

    ascon128 u_ascon (
        .clk        (clk),
        .rst_n      (rst_n),
        .start      (ascon_start),
        /* verilator lint_off PINCONNECTEMPTY */
        .busy       (  ),            // core busy unused; done is the handshake
        /* verilator lint_on PINCONNECTEMPTY */
        .done       (ascon_done),
        .key        (key),
        .nonce      (nonce),
        .ad         (256'd0),     // associated data not exposed on this chip
        .ad_len     (8'd0),
        .plaintext  (plaintext),
        .pt_len     (data_len),
        .ciphertext (ascon_ct),
        .tag        (ascon_tag)
    );

    // =========================================================================
    // SHA-256 core
    // =========================================================================
    reg          sha_start;
    wire         sha_done;
    wire [255:0] sha_digest;

    sha256 u_sha256 (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (sha_start),
        /* verilator lint_off PINCONNECTEMPTY */
        .busy    (  ),               // core busy unused; done is the handshake
        /* verilator lint_on PINCONNECTEMPTY */
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
            err          <= 1'b0;
            wdog         <= {TW{1'b0}};
        end else begin
            // Defaults: these are one-cycle pulses
            ascon_start  <= 1'b0;
            sha_start    <= 1'b0;
            result_valid <= 1'b0;

            case (state)

                // -- Wait for spi_buffer_ctrl to signal data is ready --
                S_IDLE: begin
                    if (data_ready) begin
                        err  <= 1'b0;        // a new request clears the flag
                        wdog <= {TW{1'b0}};

                        if (req_valid) begin
                            sel_ascon <= cmd_ascon;   // FIX 1: validated select
                            state     <= S_START;
                        end else begin
                            // Malformed request: return a defined zero result
                            // immediately rather than running a core we were
                            // not actually asked for.
                            err        <= 1'b1;
                            result_in  <= 256'd0;
                            result_len <= 8'd32;
                            state      <= S_RESULT;
                        end
                    end
                end

                // -- Pulse start to the selected core for one cycle --
                S_START: begin
                    if (sel_ascon)
                        ascon_start <= 1'b1;
                    else
                        sha_start   <= 1'b1;
                    wdog  <= {TW{1'b0}};
                    state <= S_WAIT;
                end

                // -- Wait for the selected core to finish --
                S_WAIT: begin
                    wdog <= wdog + 1'b1;

                    if (sel_ascon && ascon_done) begin
                        // [255:128] = ciphertext, [127:0] = authentication tag
                        result_in  <= {ascon_ct[255:128], ascon_tag};
                        result_len <= 8'd32;
                        state      <= S_RESULT;
                    end
                    else if (!sel_ascon && sha_done) begin
                        result_in  <= sha_digest;
                        result_len <= 8'd32;
                        state      <= S_RESULT;
                    end
                    // FIX 2: watchdog, so a stuck core cannot hang the chip
                    else if (wdog >= TIMEOUT[TW-1:0]) begin
                        err        <= 1'b1;
                        result_in  <= 256'd0;
                        result_len <= 8'd32;
                        state      <= S_RESULT;
                    end
                end

                // -- Assert result_valid for one cycle, then return to idle --
                S_RESULT: begin
                    result_valid <= 1'b1;
                    state        <= S_IDLE;
                end

                default: state <= S_IDLE;

            endcase
        end
    end

endmodule
