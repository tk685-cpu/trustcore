// =============================================================================
// status_led.v
// Pass / fail indicator for FPGA bring-up.
//
// Software writes a 2-bit status code; this module turns it into a blink
// pattern in hardware, so the indication keeps running even if the PS
// application stops or crashes.
//
// All eight ZCU106 user LEDs are driven together as one bar, so the verdict is
// readable across the room without identifying individual LEDs:
//
//   status  meaning     all 8 GPIO LEDs
//   ------  ----------  ------------------------------------------------------
//   2'b00   idle        very slow pulse, 168 ms on every 2.7 s  (~0.37 Hz)
//   2'b01   pass        SOLID ON
//   2'b10   fail        ALL OFF
//   2'b11   running     fast even blink, 84 ms on / 84 ms off   (~6 Hz)
//
// The two moving states are 16x apart in rate, so they cannot be mistaken for
// each other: a lone pulse every few seconds means "alive, waiting for a
// button", a fast even strobe means "test in progress". Anything static is a
// verdict, and the two verdicts are the two extremes: all on, or all off.
//
// WHY IDLE IS NOT SIMPLY DARK
//   Fail is all-dark and steady, and the board sits in idle indefinitely
//   between runs. If idle were dark too, then a board waiting at the menu, a
//   crashed PS application, and a bitstream that never programmed would all
//   look exactly like a failing test. The slow pulse is the only thing
//   separating "no verdict yet" from "verdict: fail".
//
// NOTE ON THE ZCU106
//   The user LEDs are single-colour, not RGB, so a literal red/green pair is
//   not available on the board. Driving all eight together trades colour for
//   area: the whole bar lighting up or going out is unambiguous at a glance.
//   For actual colour, wire a bi-colour LED to a user PMOD header and drive it
//   from any bit of this bus.
// =============================================================================

module status_led #(
    parameter CLK_HZ = 100_000_000
) (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] status,      // 00 idle, 01 pass, 10 fail, 11 running
    output reg  [7:0] led          // all eight user LEDs, driven as one bar
);

    localparam S_IDLE    = 2'b00;
    localparam S_PASS    = 2'b01;
    localparam S_FAIL    = 2'b10;
    localparam S_RUNNING = 2'b11;

    // Bit indices are derived from the clock frequency so the blink rates stay
    // put in wall-clock terms regardless of what the design is clocked at.
    // $clog2(CLK_HZ) is the bit that flips at roughly 1 Hz, so:
    //
    //   TOP_BIT  = $clog2(CLK_HZ)   counter MSB, so the counter wraps ~2.7 s
    //   FAST_BIT = TOP_BIT - 4      toggles every ~84 ms -> ~6 Hz blink
    //
    // At 100 MHz that is cnt[27:0] and cnt[23]; at 50 MHz, cnt[26:0] and
    // cnt[22]. Both land on the same rates.
    localparam integer TOP_BIT  = $clog2(CLK_HZ);
    localparam integer FAST_BIT = TOP_BIT - 4;

    reg [TOP_BIT:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= {(TOP_BIT+1){1'b0}};
        else        cnt <= cnt + 1'b1;
    end

    // Running: even 50/50 strobe at ~6 Hz.
    wire fast = cnt[FAST_BIT];

    // Idle: the top four counter bits sit at zero for 1 of their 16 states, so
    // this is high for one full fast period (~168 ms) once per counter wrap
    // (~2.7 s). Deliberately a short pulse rather than a square wave, so it
    // reads as a slow tick and can never be confused with the running strobe.
    wire beat = (cnt[TOP_BIT -: 4] == 4'b0000);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            led <= 8'h00;
        end else begin
            case (status)
                S_IDLE:    led <= {8{beat}};   // slow tick: alive, waiting
                S_PASS:    led <= 8'hFF;       // solid on: every vector matched
                S_FAIL:    led <= 8'h00;       // all dark: something mismatched
                S_RUNNING: led <= {8{fast}};   // fast strobe: test in progress
            endcase
        end
    end

endmodule
