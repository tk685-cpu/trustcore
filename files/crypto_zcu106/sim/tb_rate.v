`timescale 1ns/1ps
module tb_rate;
    localparam CLK_PERIOD = 40;
    reg clk = 0, rst_n = 0;
    always #(CLK_PERIOD/2) clk = ~clk;
    reg sclk_r = 0, mosi_r = 0, cs_n_r = 1;
    wire miso, busy, result_ready, err;
    integer HALF;
    chip_top dut(.clk(clk), .rst_n(rst_n), .sclk(sclk_r), .mosi(mosi_r),
                 .miso(miso), .cs_n(cs_n_r), .busy(busy),
                 .result_ready(result_ready), .err(err));
    reg [7:0] rx_cap;
    task spi_xfer_byte(input [7:0] tx);
        integer i;
        begin
            for (i=7;i>=0;i=i-1) begin
                mosi_r = tx[i]; #(HALF);
                sclk_r = 1; rx_cap[i] = miso; #(HALF);
                sclk_r = 0;
            end
        end
    endtask
    reg [255:0] rb;
    integer i, guard;
    task try(input integer div, input [255:0] expect);
        begin
            HALF = (CLK_PERIOD*div)/2;
            cs_n_r = 0; #(HALF);
            spi_xfer_byte(8'h01); spi_xfer_byte(8'd3);
            spi_xfer_byte(8'h61); spi_xfer_byte(8'h62); spi_xfer_byte(8'h63);
            #(HALF); cs_n_r = 1; #(HALF*4);
            guard = 0;
            while (result_ready !== 1'b1 && guard < 20000) begin @(posedge clk); guard = guard+1; end
            rb = 0; cs_n_r = 0; #(HALF);
            for (i=0;i<32;i=i+1) begin spi_xfer_byte(8'h00); rb = {rb[247:0], rx_cap}; end
            #(HALF); cs_n_r = 1; #(HALF*8);
            $display("  SCLK = clk/%0d (%0.3f MHz) : %s", div, 25.0/div,
                     (rb === expect) ? "PASS" : "FAIL");
            repeat (20) @(posedge clk);
        end
    endtask
    initial begin
        repeat (10) @(posedge clk); rst_n = 1; repeat (10) @(posedge clk);
        $display("=== SCLK rate margin sweep (system clock 25 MHz) ===");
        try(16, 256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD);
        try(10, 256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD);
        try( 8, 256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD);
        try( 6, 256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD);
        try( 4, 256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD);
        try( 2, 256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD);
        $finish;
    end
    initial begin #900_000_000; $display("TIMEOUT"); $finish; end
endmodule
