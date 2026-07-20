// =============================================================================
// spi_slave.v
// SPI Slave Core - Mode 0 (CPOL=0, CPHA=0)
//
// Target : 0.5um CMOS ASIC, 25 MHz system clock
// SPI    : 8-bit, full duplex, MSB first
// Reset  : Active-low asynchronous
//
// Packet boundary is controlled by CS_N:
//   CS_N low  = transfer active
//   CS_N high = transfer idle, shift registers reset
//
// TX preload:
//   Load tx_byte + assert tx_load BEFORE or on the first falling SCLK edge
//   so MISO is valid when the master samples on the rising edge.
// =============================================================================

module spi_slave (
    input  wire       clk,        // 25 MHz system clock
    input  wire       rst_n,      // active-low async reset

    // SPI pads (connect directly to chip IO pads)
    input  wire       sclk,       // SPI clock from master
    input  wire       mosi,       // master out slave in
    output reg        miso,       // master in slave out
    input  wire       cs_n,       // chip select, active low

    // Byte interface to buffer controller
    output reg  [7:0] rx_byte,    // received byte (valid when rx_valid=1)
    output reg        rx_valid,   // 1-cycle pulse: rx_byte is ready
    input  wire [7:0] tx_byte,    // next byte to transmit
    input  wire       tx_load,    // 1-cycle pulse: load tx_byte into TX shift reg
    output reg        byte_done   // 1-cycle pulse: 8 bits transferred
);

    // -------------------------------------------------------------------------
    // 2-FF synchronizers for all SPI inputs
    // Prevents metastability when crossing from slow SPI clock domain
    // to 25 MHz system clock domain
    // -------------------------------------------------------------------------
    reg sclk_s1, sclk_s2, sclk_s3; // extra stage for edge detect
    reg mosi_s1, mosi_s2;
    reg cs_s1,   cs_s2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sclk_s1 <= 1'b0; sclk_s2 <= 1'b0; sclk_s3 <= 1'b0;
            mosi_s1 <= 1'b0; mosi_s2 <= 1'b0;
            cs_s1   <= 1'b1; cs_s2   <= 1'b1;
        end else begin
            sclk_s1 <= sclk;    sclk_s2 <= sclk_s1;    sclk_s3 <= sclk_s2;
            mosi_s1 <= mosi;    mosi_s2 <= mosi_s1;
            cs_s1   <= cs_n;    cs_s2   <= cs_s1;
        end
    end

    // Synchronized edge detection
    wire sclk_rise = ( sclk_s2) & (~sclk_s3); // rising  edge of SCLK
    wire sclk_fall = (~sclk_s2) & ( sclk_s3); // falling edge of SCLK
    wire cs_active = ~cs_s2;                   // CS_N deasserted = slave selected

    // -------------------------------------------------------------------------
    // RX shift register
    // Mode 0: sample MOSI on rising SCLK edge, MSB first
    // -------------------------------------------------------------------------
    reg [7:0] rx_shift;
    reg [2:0] bit_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_shift <= 8'h00;
            rx_byte  <= 8'h00;
            rx_valid <= 1'b0;
            byte_done<= 1'b0;
            bit_cnt  <= 3'd0;
        end else begin
            rx_valid  <= 1'b0;
            byte_done <= 1'b0;

            if (!cs_active) begin
                // CS_N deasserted: reset counter ready for next transfer
                bit_cnt  <= 3'd0;
                rx_shift <= 8'h00;
            end else if (sclk_rise) begin
                rx_shift <= {rx_shift[6:0], mosi_s2}; // shift in MSB first

                if (bit_cnt == 3'd7) begin
                    // 8th bit just clocked in
                    rx_byte   <= {rx_shift[6:0], mosi_s2};
                    rx_valid  <= 1'b1;
                    byte_done <= 1'b1;
                    bit_cnt   <= 3'd0;
                end else begin
                    bit_cnt <= bit_cnt + 1'b1;
                end
            end
        end
    end

    // -------------------------------------------------------------------------
    // TX shift register
    // Mode 0: change MOSI on falling SCLK edge so master samples on rising
    // Preload: when tx_load is asserted or CS_N goes active
    // -------------------------------------------------------------------------
    reg [7:0] tx_shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_shift <= 8'hFF;
            miso     <= 1'b1;
        end else begin
            if (tx_load) begin
                // Buffer controller loading next byte to send
                tx_shift <= tx_byte;
                miso     <= tx_byte[7]; // put MSB on line immediately
            end else if (!cs_active) begin
                // CS inactive: preload so first bit is ready
                tx_shift <= tx_byte;
                miso     <= tx_byte[7];
            end else if (sclk_fall) begin
                // Shift out next bit on falling edge
                miso     <= tx_shift[6];
                tx_shift <= {tx_shift[6:0], 1'b1};
            end
        end
    end

endmodule
