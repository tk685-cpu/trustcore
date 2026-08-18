// =============================================================================
// spi_slave.v
// SPI Slave Core - Mode 0 (CPOL=0, CPHA=0)
//
// Target : 0.5um CMOS ASIC, 25 MHz system clock (also FPGA validated)
// SPI    : 8-bit, full duplex, MSB first
// Reset  : Active-low asynchronous
//
// Packet boundary is controlled by CS_N:
//   CS_N low  = transfer active
//   CS_N high = transfer idle, shift registers reset/preloaded
//
// SCLK FREQUENCY LIMIT (important):
//   SCLK is oversampled by the system clock. Edge detection compares two
//   adjacent synchronizer stages, so each SCLK phase must last at least one
//   full system clock period simply to be observed, and the TX byte handover
//   needs three system clocks between a SCLK rising edge and the following
//   falling edge. The safe design rule is
//
//        f_SCLK  <=  f_clk / 8
//
//   At the 25 MHz system clock that is 3.125 MHz. The previous revision of
//   this header claimed 12.5 MHz (f_clk / 2), which does not leave enough
//   margin for either edge detection or the byte handover and will drop or
//   misalign bits.
//
// TX PATH DESIGN NOTE:
//   The controller asserts tx_load a few system clocks after a byte completes,
//   which lands BEFORE the SCLK falling edge that ends that bit period. If the
//   load were applied straight to the shift register, that falling edge would
//   then shift the freshly loaded byte once more and every byte after the
//   first would be transmitted one bit early.
//
//   Instead the incoming byte is staged in tx_hold/tx_pending and swapped into
//   the shifter ON the falling edge itself, which is exactly the byte
//   boundary. MISO is driven straight off the shift register MSB, so it is a
//   registered output with no combinational logic in the path to the pad.
// =============================================================================

module spi_slave (
    input  wire       clk,        // system clock
    input  wire       rst_n,      // active-low async reset

    // SPI pads (connect directly to chip IO pads)
    input  wire       sclk,       // SPI clock from master
    input  wire       mosi,       // master out slave in
    output wire       miso,       // master in slave out
    input  wire       cs_n,       // chip select, active low

    // Byte interface to the buffer controller
    output reg  [7:0] rx_byte,    // received byte (valid when rx_valid = 1)
    output reg        rx_valid,   // 1-cycle pulse: rx_byte is ready
    input  wire [7:0] tx_byte,    // next byte to transmit
    input  wire       tx_load,    // 1-cycle pulse: stage tx_byte for sending
    output reg        byte_done,  // 1-cycle pulse: 8 bits transferred

    // Frame status (synchronized into the system clock domain)
    output wire       cs_active   // high while the master holds CS_N low
);

    // -------------------------------------------------------------------------
    // 2-FF synchronizers for all SPI inputs, plus a third SCLK stage so edges
    // can be detected without a combinational path from the pad.
    // -------------------------------------------------------------------------
    reg sclk_s1, sclk_s2, sclk_s3;
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
    wire sclk_rise = ( sclk_s2) & (~sclk_s3);   // rising  edge of SCLK
    wire sclk_fall = (~sclk_s2) & ( sclk_s3);   // falling edge of SCLK

    assign cs_active = ~cs_s2;                  // CS_N asserted = slave selected

    // -------------------------------------------------------------------------
    // RX shift register
    // Mode 0: sample MOSI on the rising SCLK edge, MSB first.
    //
    // mosi_s2 and sclk_s2 are delayed by the same number of stages, so at the
    // cycle where sclk_rise is seen, mosi_s2 holds the MOSI value from the
    // instant of the real SCLK rising edge. That is the correct sample point.
    // -------------------------------------------------------------------------
    reg [6:0] rx_shift;   // only 7 bits are ever re-read; bit 8 is mosi_s2
    reg [2:0] bit_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_shift  <= 7'h00;
            rx_byte   <= 8'h00;
            rx_valid  <= 1'b0;
            byte_done <= 1'b0;
            bit_cnt   <= 3'd0;
        end else begin
            rx_valid  <= 1'b0;
            byte_done <= 1'b0;

            if (!cs_active) begin
                // CS_N deasserted: drop any partial byte, ready for next frame
                bit_cnt  <= 3'd0;
                rx_shift <= 7'h00;
            end else if (sclk_rise) begin
                rx_shift <= {rx_shift[5:0], mosi_s2};   // shift in MSB first

                if (bit_cnt == 3'd7) begin
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
    // TX shift register with a staged next-byte register
    //
    //   tx_load  -> capture tx_byte into tx_hold, raise tx_pending
    //   CS idle  -> park the staged byte directly, so its MSB is already on
    //               MISO before the master's very first SCLK rising edge
    //   SCLK fall-> if a byte is staged, swap it in whole (this is the byte
    //               boundary); otherwise shift the current byte left by one
    // -------------------------------------------------------------------------
    reg [7:0] tx_shift;
    reg [7:0] tx_hold;
    reg       tx_pending;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_shift   <= 8'hFF;
            tx_hold    <= 8'hFF;
            tx_pending <= 1'b0;
        end else begin
            // Stage whatever the controller offers, in every state
            if (tx_load) begin
                tx_hold    <= tx_byte;
                tx_pending <= 1'b1;
            end

            if (!cs_active) begin
                // Frame idle: load the shifter directly. tx_pending is cleared
                // here, overriding the assignment above if both happen in the
                // same cycle, because the byte has just been consumed.
                if (tx_load)         tx_shift <= tx_byte;
                else if (tx_pending) tx_shift <= tx_hold;
                tx_pending <= 1'b0;
            end else if (sclk_fall) begin
                if (tx_pending) begin
                    tx_shift   <= tx_hold;               // byte boundary swap
                    tx_pending <= 1'b0;
                end else begin
                    tx_shift <= {tx_shift[6:0], 1'b1};   // shift out next bit
                end
            end
        end
    end

    // MISO is driven straight from the shift register MSB. This is a register
    // output, so there is no combinational delay between the flop and the pad.
    assign miso = tx_shift[7];

endmodule
