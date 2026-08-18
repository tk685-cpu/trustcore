`timescale 1ns/1ps
// Button controller test. CLK_HZ is scaled down to 100 kHz so the millisecond
// timers become hundreds of cycles instead of millions.
module tb_button;
    localparam CLK_HZ = 100_000;      // 1 ms = 100 cycles
    localparam DB_MS  = 10;           // debounce = 1000 cycles
    localparam WIN_MS = 250;          // window   = 25000 cycles
    localparam CYC_PER_MS = CLK_HZ/1000;

    reg clk = 0, rst_n = 0;
    reg [1:0] btn = 2'b00;
    wire [1:0] btn_state, evt_code;
    wire evt_valid;
    integer errors = 0;

    button_ctrl #(.CLK_HZ(CLK_HZ), .DEBOUNCE_MS(DB_MS), .WINDOW_MS(WIN_MS),
                  .ACTIVE_HIGH(1))
        dut (.clk(clk), .rst_n(rst_n), .btn_raw(btn),
             .btn_state(btn_state), .evt_code(evt_code), .evt_valid(evt_valid));

    always #5 clk = ~clk;

    // capture events
    reg [1:0] last_code; integer evt_count = 0;
    always @(posedge clk) if (evt_valid) begin
        last_code = evt_code; evt_count = evt_count + 1;
    end

    task wait_ms(input integer ms);
        begin repeat (ms*CYC_PER_MS) @(posedge clk); end
    endtask

    task check(input [8*40:1] name, input [1:0] expect_code, input integer expect_n);
        begin
            if (evt_count == expect_n && last_code === expect_code)
                $display("  PASS %0s -> code=%b", name, last_code);
            else begin
                $display("  FAIL %0s: got code=%b n=%0d, expected code=%b n=%0d",
                         name, last_code, evt_count, expect_code, expect_n);
                errors = errors + 1;
            end
        end
    endtask

    // Simulate a bouncing contact: chatter for 3 ms then settle
    task press(input integer idx, input value);
        integer i;
        begin
            for (i = 0; i < 30; i = i + 1) begin
                btn[idx] = value ^ (i[0]);   // chatter
                repeat (CYC_PER_MS/10) @(posedge clk);
            end
            btn[idx] = value;
        end
    endtask

    initial begin
        repeat (20) @(posedge clk); rst_n = 1; repeat (20) @(posedge clk);
        $display("=== button_ctrl test ===");

        // --- 1. single press of button 0 (Ascon) ---
        press(0, 1'b1); wait_ms(300);
        check("single btn0", 2'b01, 1);
        press(0, 1'b0); wait_ms(50);

        // --- 2. single press of button 1 (SHA) ---
        press(1, 1'b1); wait_ms(300);
        check("single btn1", 2'b10, 2);
        press(1, 1'b0); wait_ms(50);

        // --- 3. both, with a realistic 80 ms gap between fingers ---
        press(0, 1'b1); wait_ms(80); press(1, 1'b1);
        wait_ms(300);
        check("both (80ms apart)", 2'b11, 3);
        btn = 2'b00; wait_ms(50);

        // --- 4. second press arrives AFTER the window: two separate events ---
        press(0, 1'b1); wait_ms(300);
        check("late second: first", 2'b01, 4);
        btn = 2'b00; wait_ms(50);
        press(1, 1'b1); wait_ms(300);
        check("late second: second", 2'b10, 5);
        btn = 2'b00; wait_ms(50);

        // --- 5. holding a button must NOT auto-repeat ---
        press(0, 1'b1); wait_ms(1500);
        check("hold does not repeat", 2'b01, 6);
        btn = 2'b00; wait_ms(50);

        // --- 6. a bounce burst shorter than the debounce time is ignored ---
        btn[0] = 1'b1; repeat (CYC_PER_MS*2) @(posedge clk);  // 2 ms glitch
        btn[0] = 1'b0; wait_ms(400);
        check("2ms glitch rejected", 2'b01, 6);   // count unchanged

        $display("=== errors=%0d ===", errors);
        if (errors == 0) $display("RESULT: ALL PASS"); else $display("RESULT: FAIL");
        $finish;
    end
    initial begin #200_000_000; $display("TIMEOUT"); $finish; end
endmodule
