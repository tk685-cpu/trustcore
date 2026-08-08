`timescale 1ns/1ps
module tb_ascon_fix;
    reg clk = 0, rst_n = 0, start = 0;
    reg [127:0] key = 0, nonce = 0;
    reg [255:0] ad = 0, plaintext = 0;
    reg [7:0]   ad_len = 0, pt_len = 0;
    wire busy, done;
    wire [255:0] ciphertext;
    wire [127:0] tag;
    integer errors = 0;

    ascon128 dut(.clk(clk), .rst_n(rst_n), .start(start), .busy(busy), .done(done),
                 .key(key), .nonce(nonce), .ad(ad), .ad_len(ad_len),
                 .plaintext(plaintext), .pt_len(pt_len),
                 .ciphertext(ciphertext), .tag(tag));

    always #2 clk = ~clk;

    task run(input [255:0] pt, input [7:0] plen,
             input [255:0] plad, input [7:0] alen,
             input [255:0] exp_ct, input [127:0] exp_tag);
        begin
            @(posedge clk); plaintext = pt; pt_len = plen; ad = plad; ad_len = alen;
            @(posedge clk); start = 1;
            @(posedge clk); start = 0;
            wait (done == 1);
            @(posedge clk);
            if (ciphertext === exp_ct && tag === exp_tag)
                $display("PASS pt_len=%0d ad_len=%0d", plen, alen);
            else begin
                $display("FAIL pt_len=%0d ad_len=%0d", plen, alen);
                $display("   ct  got %h", ciphertext);
                $display("   ct  exp %h", exp_ct);
                $display("   tag got %h", tag);
                $display("   tag exp %h", exp_tag);
                errors = errors + 1;
            end
            repeat (3) @(posedge clk);
        end
    endtask

    initial begin
        key   = 128'h000102030405060708090A0B0C0D0E0F;
        nonce = 128'h000102030405060708090A0B0C0D0E0F;
        repeat (4) @(posedge clk); rst_n = 1;
        repeat (4) @(posedge clk);
        `include "ascon_vectors.vh"
        $display("ASCON errors=%0d", errors);
        $finish;
    end
endmodule
