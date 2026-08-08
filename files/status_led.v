// =============================================================================
// status_led.v
// Pass / fail indicator for FPGA bring-up.
//
// Software writes a 2-bit status code; this module turns it into a blink
// pattern in hardware, so the indication keeps running even if the PS
// application stops or crashes.
//
//   status  meaning     LED_PASS          LED_FAIL
//   ------  ----------  ----------------  ----------------
//   2'b00   idle        slow heartbeat    off
//   2'b01   pass        solid on          off
//   2'b10   fail        off               fast blink
//   2'b11   running     fast blink        fast blink  (alternating)
//
// NOTE ON THE ZCU106
//   The ZCU106 user LEDs are a bank of single-colour LEDs, not RGB, so a
//   literal red/green pair is not available on the board itself. Two options:
//     a) map LED_PASS and LED_FAIL to two different user LEDs and tell them
//        apart by position and blink rate (what the XDC does by default), or
//     b) wire a bi-colour or RGB LED to a user PMOD header and drive it from
//        these same two outputs.
//   Check the LED pin names against the master XDC for your board revision
//   before building.
// =============================================================================

module status_led #(
    parameter CLK_HZ = 100_000_000
) (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] status,      // 00 idle, 01 pass, 10 fail, 11 running
    output reg        led_pass,
    output reg        led_fail
);

    localparam S_IDLE    = 2'b00;
    localparam S_PASS    = 2'b01;
    localparam S_FAIL    = 2'b10;
    localparam S_RUNNING = 2'b11;

    // Divider widths chosen from the clock frequency so the blink rates stay
    // roughly the same regardless of what the design is clocked at.
    //   slow ~= 1 Hz, fast ~= 6 Hz
    localparam integer SLOW_BIT = $clog2(CLK_HZ) - 1;   // ~0.75 Hz at 100 MHz
    localparam integer FAST_BIT = SLOW_BIT - 3;         // ~6 Hz

    reg [SLOW_BIT:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= {(SLOW_BIT+1){1'b0}};
        else        cnt <= cnt + 1'b1;
    end

    wire fast = cnt[FAST_BIT];

    // Short on-pulse so the idle heartbeat reads as a blip, not a square wave
    wire beat = (cnt[SLOW_BIT-1 -: 3] == 3'b000);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            led_pass <= 1'b0;
            led_fail <= 1'b0;
        end else begin
            case (status)
                S_IDLE: begin
                    led_pass <= beat;      // faint heartbeat: board is alive
                    led_fail <= 1'b0;
                end
                S_PASS: begin
                    led_pass <= 1'b1;      // solid: all vectors matched
                    led_fail <= 1'b0;
                end
                S_FAIL: begin
                    led_pass <= 1'b0;
                    led_fail <= fast;      // urgent blink: something mismatched
                end
                S_RUNNING: begin
                    led_pass <=  fast;     // alternating: test in progress
                    led_fail <= ~fast;
                end
            endcase
        end
    end

endmodule
