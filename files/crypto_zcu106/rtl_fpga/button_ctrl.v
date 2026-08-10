// =============================================================================
// button_ctrl.v
// Pushbutton debouncing and press-event generation.
//
// Turns two mechanical pushbuttons into clean, one-shot events that software
// can poll. Handles the two problems raw buttons always have:
//
//   1. CONTACT BOUNCE
//      A mechanical switch does not close once. It chatters for several
//      milliseconds, which at 100 MHz is hundreds of thousands of clock
//      cycles and looks like hundreds of separate presses. Each input is
//      therefore required to hold a new value for DEBOUNCE_MS before the
//      debounced output follows it.
//
//   2. "BOTH BUTTONS" IS NEVER SIMULTANEOUS
//      No human presses two buttons on the same clock cycle, or even within
//      the same millisecond. Sampling for "both down at once" would almost
//      never fire. Instead, the first press opens a collection window of
//      WINDOW_MS; whatever is pressed during that window is OR-ed together,
//      and the combined result is reported once when the window closes.
//      Press one button and you get that one; press the second within a
//      quarter second and you get both.
//
// After an event fires, no further event is generated until every button has
// been released. Holding a button down does not auto-repeat.
//
// evt_code bit meanings (matches btn_raw bit order):
//   2'b01  button 0 only
//   2'b10  button 1 only
//   2'b11  both
//
// ACTIVE_HIGH selects the electrical polarity of the pushbuttons. Set it to 0
// for buttons that pull to ground when pressed. If you are unsure, read the
// raw bits back through the BTN register and press a button: the raw value
// tells you the polarity in about five seconds.
//
// Timing parameters are derived from CLK_HZ so a testbench can shrink them by
// passing a small CLK_HZ, rather than having to simulate 25 million cycles.
// =============================================================================

module button_ctrl #(
    parameter CLK_HZ      = 100_000_000,
    parameter DEBOUNCE_MS = 10,           // contact settle time
    parameter WINDOW_MS   = 250,          // multi-press collection window
    parameter ACTIVE_HIGH = 1             // 1 = pressed drives high
) (
    input  wire       clk,
    input  wire       rst_n,

    input  wire [1:0] btn_raw,            // straight from the pads

    output wire [1:0] btn_state,          // debounced, normalised active-high
    output reg  [1:0] evt_code,           // which buttons the event covers
    output reg        evt_valid           // 1-cycle pulse: evt_code is new
);

    // -------------------------------------------------------------------------
    // Derived cycle counts
    // -------------------------------------------------------------------------
    localparam integer DB_CYCLES  = (CLK_HZ / 1000) * DEBOUNCE_MS;
    localparam integer WIN_CYCLES = (CLK_HZ / 1000) * WINDOW_MS;

    localparam integer DBW  = $clog2(DB_CYCLES  + 1);
    localparam integer WINW = $clog2(WIN_CYCLES + 1);

    // -------------------------------------------------------------------------
    // Input synchronizers
    //
    // The buttons are asynchronous to clk by definition, so they need the same
    // two-flop treatment as any other asynchronous input. Polarity is
    // normalised here so everything downstream can assume active-high.
    // -------------------------------------------------------------------------
    // ASYNC_REG marks these as a synchronizer chain: it keeps both flops in
    // the same slice for the longest possible metastability settling window,
    // and stops the tool reporting a false setup violation on the pad path.
    // Declared here rather than in the XDC so it applies during synthesis as
    // well as implementation, and survives any later signal rename.
    (* ASYNC_REG = "TRUE" *) reg [1:0] sync0;
    (* ASYNC_REG = "TRUE" *) reg [1:0] sync1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync0 <= 2'b00;
            sync1 <= 2'b00;
        end else begin
            sync0 <= (ACTIVE_HIGH != 0) ? btn_raw : ~btn_raw;
            sync1 <= sync0;
        end
    end

    // -------------------------------------------------------------------------
    // Debounce, one counter per button
    //
    // The counter resets whenever the synchronized input agrees with the
    // current debounced value. It only reaches DB_CYCLES if the input has
    // disagreed continuously for the full settle time, which is exactly the
    // condition for accepting a real transition.
    // -------------------------------------------------------------------------
    reg           db0, db1;
    reg [DBW-1:0] cnt0, cnt1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            db0  <= 1'b0;
            cnt0 <= {DBW{1'b0}};
        end else if (sync1[0] == db0) begin
            cnt0 <= {DBW{1'b0}};                 // stable, restart the timer
        end else if (cnt0 >= DB_CYCLES[DBW-1:0] - 1) begin
            db0  <= sync1[0];                    // held long enough, accept it
            cnt0 <= {DBW{1'b0}};
        end else begin
            cnt0 <= cnt0 + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            db1  <= 1'b0;
            cnt1 <= {DBW{1'b0}};
        end else if (sync1[1] == db1) begin
            cnt1 <= {DBW{1'b0}};
        end else if (cnt1 >= DB_CYCLES[DBW-1:0] - 1) begin
            db1  <= sync1[1];
            cnt1 <= {DBW{1'b0}};
        end else begin
            cnt1 <= cnt1 + 1'b1;
        end
    end

    assign btn_state = {db1, db0};

    // -------------------------------------------------------------------------
    // Press-collection FSM
    //
    //   IDLE    : nothing pressed. Any button going down opens the window.
    //   COLLECT : accumulate every button seen during WINDOW_MS, then fire.
    //   RELEASE : hold off until all buttons are up, so holding a button down
    //             produces exactly one event rather than a stream.
    // -------------------------------------------------------------------------
    localparam W_IDLE    = 2'd0;
    localparam W_COLLECT = 2'd1;
    localparam W_RELEASE = 2'd2;

    reg [1:0]      wstate;
    reg [WINW-1:0] wcnt;
    reg [1:0]      mask;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wstate    <= W_IDLE;
            wcnt      <= {WINW{1'b0}};
            mask      <= 2'b00;
            evt_code  <= 2'b00;
            evt_valid <= 1'b0;
        end else begin
            evt_valid <= 1'b0;               // single-cycle pulse

            case (wstate)

                W_IDLE: begin
                    if (btn_state != 2'b00) begin
                        mask   <= btn_state;
                        wcnt   <= {WINW{1'b0}};
                        wstate <= W_COLLECT;
                    end
                end

                W_COLLECT: begin
                    mask <= mask | btn_state;    // catch the second press

                    if (wcnt >= WIN_CYCLES[WINW-1:0] - 1) begin
                        evt_code  <= mask | btn_state;
                        evt_valid <= 1'b1;
                        wstate    <= W_RELEASE;
                    end else begin
                        wcnt <= wcnt + 1'b1;
                    end
                end

                W_RELEASE: begin
                    if (btn_state == 2'b00) begin
                        mask   <= 2'b00;
                        wstate <= W_IDLE;
                    end
                end

                default: wstate <= W_IDLE;

            endcase
        end
    end

endmodule
