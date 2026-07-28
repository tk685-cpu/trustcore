// =============================================================================
// chip_top.v
// Full Chip Top Level
//
// Connects spi_top (SPI interface + buffer controller) and
// crypto_fsm (core router containing ascon128 + sha256).
//
// This is the module that gets synthesized as the complete chip.
//
// Block diagram:
//
//   SPI pins ──► spi_top ──► crypto_fsm ──► ascon128
//                   │             │
//                   │             └───────► sha256
//                   ◄─────────────┘
//
// All internal wires between spi_top and crypto_fsm are defined here.
//
// Target : 0.5um CMOS ASIC, 1mm² die, 25 MHz system clock
// =============================================================================

module chip_top (
    input  wire clk,      // 25 MHz system clock
    input  wire rst_n,    // active-low async reset

    // SPI pins (connect to chip IO pads)
    input  wire sclk,     // SPI clock from master (max 12.5 MHz)
    input  wire mosi,     // master out slave in
    output wire miso,     // master in slave out
    input  wire cs_n      // chip select, active low
);

    // =========================================================================
    // Internal wires between spi_top and crypto_fsm
    // =========================================================================

    // spi_top → crypto_fsm
    wire [127:0] key;
    wire [127:0] nonce;
    wire [255:0] plaintext;
    wire [7:0]   data_len;
    wire         cmd_sha256;
    wire         cmd_ascon;
    wire         data_ready;

    // crypto_fsm → spi_top
    wire [255:0] result_in;
    wire [7:0]   result_len;
    wire         result_valid;

    // Status (unused at top level but kept for observability / debug pads)
    wire         busy;

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
        .busy          (busy)
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
        .result_valid (result_valid)
    );

endmodule
