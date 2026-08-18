// =============================================================================
// chip_top.v
// Full Chip Top Level
//
// Connects spi_top (SPI interface + buffer controller) and crypto_fsm (core
// router containing ascon128 + sha256). This is the module that is synthesized
// as the complete chip, and the module the FPGA wrapper instantiates unchanged.
//
// Block diagram:
//
//   SPI pins --> spi_top --> crypto_fsm --> ascon128
//                   |             |
//                   |             +-------> sha256
//                   <-------------+
//
// Target : 0.5um CMOS ASIC, 1mm2 die, 25 MHz system clock
//          Also validated on a Zynq UltraScale+ FPGA (ZCU106).
//
// SCLK limit: f_SCLK <= f_clk / 8, i.e. 3.125 MHz at a 25 MHz system clock.
//
// STATUS PINS
//   The status outputs are what the host polls between the command frame and
//   the result frame. On the ASIC they go to debug pads; on the FPGA they are
//   read back through AXI GPIO.
//
//     busy         high from the CMD byte until the result has been sent
//     result_ready high once a result is staged and the readback frame may start
//     err          sticky: bad command, bad length, or a core timeout
// =============================================================================

module chip_top (
    input  wire clk,           // system clock
    input  wire rst_n,         // active-low async reset

    // SPI pins (connect to chip IO pads)
    input  wire sclk,          // SPI clock from master
    input  wire mosi,          // master out slave in
    output wire miso,          // master in slave out
    input  wire cs_n,          // chip select, active low

    // Status / debug pins
    output wire busy,          // transaction in progress
    output wire result_ready,  // result staged, safe to clock it out
    output wire err            // sticky error flag
);

    // =========================================================================
    // Internal wires between spi_top and crypto_fsm
    // =========================================================================

    // spi_top -> crypto_fsm
    wire [127:0] key;
    wire [127:0] nonce;
    wire [255:0] plaintext;
    wire [7:0]   data_len;
    wire         cmd_sha256;
    wire         cmd_ascon;
    wire         data_ready;

    // crypto_fsm -> spi_top
    wire [255:0] result_in;
    wire [7:0]   result_len;
    wire         result_valid;

    // Status
    wire         spi_err;
    wire         fsm_err;

    assign err = spi_err | fsm_err;

    // =========================================================================
    // SPI Interface + Buffer Controller
    // =========================================================================
    spi_top u_spi_top (
        .clk           (clk),
        .rst_n         (rst_n),

        // SPI IO pads
        .sclk          (sclk),
        .mosi          (mosi),
        .miso          (miso),
        .cs_n          (cs_n),

        // To crypto_fsm
        .key_out       (key),
        .nonce_out     (nonce),
        .plaintext_out (plaintext),
        .data_len_out  (data_len),
        .cmd_sha256    (cmd_sha256),
        .cmd_ascon     (cmd_ascon),
        .data_ready    (data_ready),

        // From crypto_fsm
        .result_in     (result_in),
        .result_len    (result_len),
        .result_valid  (result_valid),

        // Status
        .busy          (busy),
        .result_ready  (result_ready),
        .err           (spi_err),
        /* verilator lint_off PINCONNECTEMPTY */
        .cs_active     (  )   // frame status is observable on the cs_n pin
        /* verilator lint_on PINCONNECTEMPTY */
    );

    // =========================================================================
    // Crypto Core Router (contains ascon128 and sha256)
    // =========================================================================
    crypto_fsm u_crypto_fsm (
        .clk          (clk),
        .rst_n        (rst_n),

        // From spi_top
        .key          (key),
        .nonce        (nonce),
        .plaintext    (plaintext),
        .data_len     (data_len),
        .cmd_sha256   (cmd_sha256),
        .cmd_ascon    (cmd_ascon),
        .data_ready   (data_ready),

        // To spi_top
        .result_in    (result_in),
        .result_len   (result_len),
        .result_valid (result_valid),
        .err          (fsm_err)
    );

endmodule
