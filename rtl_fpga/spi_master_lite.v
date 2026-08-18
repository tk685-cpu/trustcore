// =============================================================================
// spi_master_lite.v
// Minimal SPI Mode 0 master (CPOL=0, CPHA=0), one byte per transfer.
//
// This is the FPGA-side counterpart to the chip's spi_slave. It exists so the
// whole PS-to-PL path can be simulated before it ever reaches the board, and
// so the SCLK divider is settable at run time from software rather than baked
// into an IP configuration at build time.
//
// Protocol timing (Mode 0):
//   MOSI is driven while SCLK is low; both sides sample on the rising edge.
//   MISO is sampled at the instant SCLK is asserted, which is the correct
//   Mode 0 sample point.
//
// Clock divider:
//   sclk_div sets the number of system clocks per SCLK half period, so
//       f_SCLK = f_clk / (2 * sclk_div)
//   The slave requires f_SCLK <= f_clk / 8, so sclk_div must be >= 4.
//   A value of 0 is coerced to 1 to avoid a divide-by-zero lockup.
//
// Chip select is held by software (cs_n input), not by this module, because a
// command packet spans many byte transfers inside a single frame.
// =============================================================================

module spi_master_lite (
    input  wire       clk,
    input  wire       rst_n,

    // Control
    input  wire [7:0] sclk_div,    // system clocks per SCLK half period (>= 4)
    input  wire [7:0] tx_data,     // byte to send
    input  wire       start,       // 1-cycle pulse: begin a byte transfer
    output reg  [7:0] rx_data,     // byte received during the last transfer
    output reg        busy,        // high while a byte is in flight

    // SPI pins to the slave
    output reg        sclk,
    output reg        mosi,
    input  wire       miso
);

    localparam ST_IDLE = 2'd0;
    localparam ST_LOW  = 2'd1;   // SCLK low phase, MOSI settled
    localparam ST_HIGH = 2'd2;   // SCLK high phase, MISO sampled

    reg [1:0] state;
    // tx_sh[7] is driven onto MOSI and then shifted out, so it is written but
    // never re-read. That is the intended behaviour of a shift register.
    /* verilator lint_off UNUSEDSIGNAL */
    reg [7:0] tx_sh;
    /* verilator lint_on UNUSEDSIGNAL */
    reg [7:0] rx_sh;
    reg [2:0] bit_cnt;
    reg [7:0] tick;

    // Guard against a zero divider, which would otherwise never tick
    wire [7:0] div_safe = (sclk_div == 8'd0) ? 8'd1 : sclk_div;
    wire       tick_now = (tick >= div_safe - 8'd1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= ST_IDLE;
            sclk    <= 1'b0;
            mosi    <= 1'b0;
            busy    <= 1'b0;
            tx_sh   <= 8'd0;
            rx_sh   <= 8'd0;
            rx_data <= 8'd0;
            bit_cnt <= 3'd0;
            tick    <= 8'd0;
        end else begin
            case (state)

                ST_IDLE: begin
                    sclk <= 1'b0;
                    if (start) begin
                        tx_sh   <= tx_data;
                        mosi    <= tx_data[7];   // MSB out before the first edge
                        bit_cnt <= 3'd0;
                        tick    <= 8'd0;
                        busy    <= 1'b1;
                        state   <= ST_LOW;
                    end else begin
                        busy <= 1'b0;
                    end
                end

                // Hold SCLK low for one half period, then raise it and sample
                ST_LOW: begin
                    if (tick_now) begin
                        tick  <= 8'd0;
                        sclk  <= 1'b1;
                        rx_sh <= {rx_sh[6:0], miso};   // sample on rising edge
                        state <= ST_HIGH;
                    end else begin
                        tick <= tick + 8'd1;
                    end
                end

                // Hold SCLK high for one half period, then drop it and advance
                ST_HIGH: begin
                    if (tick_now) begin
                        tick <= 8'd0;
                        sclk <= 1'b0;
                        if (bit_cnt == 3'd7) begin
                            rx_data <= rx_sh;          // rx_sh already has 8 bits
                            busy    <= 1'b0;
                            state   <= ST_IDLE;
                        end else begin
                            tx_sh   <= {tx_sh[6:0], 1'b0};
                            mosi    <= tx_sh[6];       // next bit while SCLK low
                            bit_cnt <= bit_cnt + 3'd1;
                            state   <= ST_LOW;
                        end
                    end else begin
                        tick <= tick + 8'd1;
                    end
                end

                default: state <= ST_IDLE;

            endcase
        end
    end

endmodule
