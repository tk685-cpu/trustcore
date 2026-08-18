// =============================================================================
// spi_top.v
// SPI Interface Top Level
//
// Connects spi_slave <-> spi_buffer_ctrl. This module is the boundary between
// the SPI IO pads and the crypto FSM.
//
// Target : 0.5um CMOS ASIC, 25 MHz system clock (also FPGA validated)
//
// SCLK limit: f_SCLK <= f_clk / 8. See the note in spi_slave.v.
// =============================================================================

module spi_top (
    input  wire         clk,       // system clock
    input  wire         rst_n,     // active-low async reset

    // SPI IO pads (connect to the chip boundary)
    input  wire         sclk,      // SPI clock from master
    input  wire         mosi,      // master out slave in
    output wire         miso,      // master in slave out
    input  wire         cs_n,      // chip select, active low

    // To the crypto FSM
    output wire [127:0] key_out,        // 128-bit key   (Ascon)
    output wire [127:0] nonce_out,      // 128-bit nonce (Ascon)
    output wire [255:0] plaintext_out,  // message / plaintext, LEFT-aligned
    output wire [7:0]   data_len_out,   // length of the message / plaintext
    output wire         cmd_sha256,     // high when SHA-256 was requested
    output wire         cmd_ascon,      // high when Ascon was requested
    output wire         data_ready,     // pulse: the crypto FSM can start

    // From the crypto FSM
    input  wire [255:0] result_in,      // ciphertext+tag, or digest (MSB first)
    input  wire [7:0]   result_len,     // bytes to return
    input  wire         result_valid,   // pulse: result_in is ready

    // Status
    output wire         busy,           // high while a transaction is in progress
    output wire         result_ready,   // high while a result is readable
    output wire         err,            // sticky: bad command or bad length
    output wire         cs_active       // high while the SPI frame is open
);

    // Internal wires between spi_slave and spi_buffer_ctrl
    wire [7:0] rx_byte;
    wire       rx_valid;
    wire       byte_done;
    wire [7:0] tx_byte;
    wire       tx_load;

    // -------------------------------------------------------------------------
    // SPI Slave core
    // Bit-level shifting, input synchronization, edge detection
    // -------------------------------------------------------------------------
    spi_slave u_spi_slave (
        .clk       (clk),
        .rst_n     (rst_n),
        .sclk      (sclk),
        .mosi      (mosi),
        .miso      (miso),
        .cs_n      (cs_n),
        .rx_byte   (rx_byte),
        .rx_valid  (rx_valid),
        .tx_byte   (tx_byte),
        .tx_load   (tx_load),
        .byte_done (byte_done),
        .cs_active (cs_active)
    );

    // -------------------------------------------------------------------------
    // Buffer Controller
    // Packet parsing, buffer filling, FSM handshake, result streaming
    // -------------------------------------------------------------------------
    spi_buffer_ctrl u_buf_ctrl (
        .clk           (clk),
        .rst_n         (rst_n),
        .rx_byte       (rx_byte),
        .rx_valid      (rx_valid),
        .byte_done     (byte_done),
        .cs_active     (cs_active),
        .tx_byte       (tx_byte),
        .tx_load       (tx_load),
        .key_out       (key_out),
        .nonce_out     (nonce_out),
        .plaintext_out (plaintext_out),
        .data_len_out  (data_len_out),
        .cmd_sha256    (cmd_sha256),
        .cmd_ascon     (cmd_ascon),
        .data_ready    (data_ready),
        .result_in     (result_in),
        .result_len    (result_len),
        .result_valid  (result_valid),
        .busy          (busy),
        .result_ready  (result_ready),
        .err           (err)
    );

endmodule
