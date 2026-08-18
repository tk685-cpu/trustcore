`timescale 1ns/1ps
module tb_sha_fix;
    reg clk = 0, rst_n = 0, start = 0;
    reg [255:0] message = 0;
    reg [7:0]   msg_len = 0;
    wire busy, done;
    wire [255:0] digest;
    integer errors = 0;
    sha256 dut(.clk(clk), .rst_n(rst_n), .start(start), .busy(busy), .done(done),
               .message(message), .msg_len(msg_len), .digest(digest));
    always #2 clk = ~clk;
    task run(input [255:0] msg, input [7:0] len, input [255:0] expect);
        begin
            @(posedge clk); message = msg; msg_len = len;
            @(posedge clk); start = 1;
            @(posedge clk); start = 0;
            wait (done == 1); @(posedge clk);
            if (digest === expect) $display("PASS len=%0d", len);
            else begin
                $display("FAIL len=%0d  got %h  exp %h", len, digest, expect);
                errors = errors + 1;
            end
            repeat (3) @(posedge clk);
        end
    endtask
    initial begin
        repeat (4) @(posedge clk); rst_n = 1; repeat (4) @(posedge clk);
        `include "sha_vectors.vh"
        $display("SHA errors=%0d", errors);
        $finish;
    end
endmodule
