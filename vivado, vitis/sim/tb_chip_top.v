// =============================================================================
// tb_chip_top.v
// Self-checking chip-level testbench.
//
// Drives chip_top through its real SPI pins with a bit-accurate Mode 0 master
// model, exactly the way the ZCU106 PS will drive it through the AXI Quad SPI
// core. Every vector goes through the full packet parse, crypto core and
// result readback path.
//
// System clock : 25 MHz (40 ns period)
// SCLK         : 3.125 MHz (f_clk / 8), the documented safe maximum
// =============================================================================
`timescale 1ns/1ps

module tb_chip_top;

    // ---------------------------------------------------------------------
    // Clock and reset
    // ---------------------------------------------------------------------
    localparam CLK_PERIOD = 40;             // 25 MHz
    localparam SCLK_HALF  = CLK_PERIOD * 4; // SCLK = clk/8

    reg clk   = 1'b0;
    reg rst_n = 1'b0;

    always #(CLK_PERIOD/2) clk = ~clk;

    // ---------------------------------------------------------------------
    // SPI master model signals
    // ---------------------------------------------------------------------
    reg  sclk_r = 1'b0;
    reg  mosi_r = 1'b0;
    reg  cs_n_r = 1'b1;
    wire miso;

    wire busy, result_ready, err;

    chip_top dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .sclk         (sclk_r),
        .mosi         (mosi_r),
        .miso         (miso),
        .cs_n         (cs_n_r),
        .busy         (busy),
        .result_ready (result_ready),
        .err          (err)
    );

    integer errors  = 0;
    integer vectors = 0;

    // ---------------------------------------------------------------------
    // SPI Mode 0 master: one byte, full duplex, MSB first.
    // MOSI changes while SCLK is low; MISO is sampled on the rising edge.
    // ---------------------------------------------------------------------
    reg [7:0] rx_cap;

    task spi_xfer_byte(input [7:0] tx);
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                mosi_r = tx[i];
                #(SCLK_HALF);
                sclk_r    = 1'b1;
                rx_cap[i] = miso;      // sample on the rising edge
                #(SCLK_HALF);
                sclk_r    = 1'b0;
            end
        end
    endtask

    task cs_assert;   begin cs_n_r = 1'b0; #(SCLK_HALF); end endtask
    task cs_release;  begin #(SCLK_HALF); cs_n_r = 1'b1; #(SCLK_HALF*4); end endtask

    // ---------------------------------------------------------------------
    // Wait for the core to stage a result, with a bounded timeout so a
    // regression shows up as a failure rather than a hung simulation.
    // ---------------------------------------------------------------------
    task wait_result;
        integer guard;
        begin
            guard = 0;
            while (result_ready !== 1'b1 && guard < 20000) begin
                @(posedge clk);
                guard = guard + 1;
            end
            if (result_ready !== 1'b1) begin
                $display("  !! TIMEOUT waiting for result_ready");
                errors = errors + 1;
            end
        end
    endtask

    // ---------------------------------------------------------------------
    // Read the 32-byte result back in a second frame
    // ---------------------------------------------------------------------
    reg [255:0] result_buf;

    task read_result;
        integer i;
        begin
            result_buf = 256'd0;
            cs_assert;
            for (i = 0; i < 32; i = i + 1) begin
                spi_xfer_byte(8'h00);          // dummy bytes to generate SCLK
                result_buf = {result_buf[247:0], rx_cap};
            end
            cs_release;
        end
    endtask

    // ---------------------------------------------------------------------
    // SHA-256 request
    // ---------------------------------------------------------------------
    task do_sha(input [255:0] msg, input [7:0] len, input [255:0] expect);
        integer i;
        begin
            vectors = vectors + 1;
            cs_assert;
            spi_xfer_byte(8'h01);              // CMD = SHA-256
            spi_xfer_byte(len);                // DATA_LEN
            for (i = 0; i < len; i = i + 1)
                spi_xfer_byte(msg[255 - i*8 -: 8]);
            cs_release;

            wait_result;
            read_result;

            if (result_buf === expect) begin
                $display("  PASS sha len=%0d", len);
            end else begin
                $display("  FAIL sha len=%0d", len);
                $display("       got %h", result_buf);
                $display("       exp %h", expect);
                errors = errors + 1;
            end
        end
    endtask

    // ---------------------------------------------------------------------
    // Ascon-128 request
    // ---------------------------------------------------------------------
    task do_ascon(input [127:0] k, input [127:0] n,
                  input [255:0] pt, input [7:0] len,
                  input [255:0] expect);
        integer i;
        begin
            vectors = vectors + 1;
            cs_assert;
            spi_xfer_byte(8'h02);              // CMD = Ascon
            spi_xfer_byte(len);                // DATA_LEN
            for (i = 0; i < 16; i = i + 1)
                spi_xfer_byte(k[127 - i*8 -: 8]);
            for (i = 0; i < 16; i = i + 1)
                spi_xfer_byte(n[127 - i*8 -: 8]);
            for (i = 0; i < len; i = i + 1)
                spi_xfer_byte(pt[255 - i*8 -: 8]);
            cs_release;

            wait_result;
            read_result;

            if (result_buf === expect) begin
                $display("  PASS ascon len=%0d", len);
            end else begin
                $display("  FAIL ascon len=%0d", len);
                $display("       got %h", result_buf);
                $display("       exp %h", expect);
                errors = errors + 1;
            end
        end
    endtask

    // ---------------------------------------------------------------------
    // Negative test: send a bad command and check err is raised and the
    // core recovers for the next request.
    // ---------------------------------------------------------------------
    task do_bad_cmd(input [7:0] cmd, input [7:0] len);
        begin
            vectors = vectors + 1;
            cs_assert;
            spi_xfer_byte(cmd);
            spi_xfer_byte(len);
            cs_release;
            repeat (50) @(posedge clk);
            if (err === 1'b1)
                $display("  PASS reject cmd=%02h len=%0d (err raised)", cmd, len);
            else begin
                $display("  FAIL reject cmd=%02h len=%0d (err NOT raised)", cmd, len);
                errors = errors + 1;
            end
        end
    endtask

    // ---------------------------------------------------------------------
    // Negative test: abandon a frame halfway and confirm recovery
    // ---------------------------------------------------------------------
    task do_abort;
        begin
            vectors = vectors + 1;
            cs_assert;
            spi_xfer_byte(8'h01);              // CMD
            spi_xfer_byte(8'd8);               // LEN = 8
            spi_xfer_byte(8'hAA);              // only one data byte, then stop
            cs_release;
            repeat (50) @(posedge clk);
            if (busy === 1'b0)
                $display("  PASS aborted frame recovered to idle");
            else begin
                $display("  FAIL aborted frame left core busy");
                errors = errors + 1;
            end
        end
    endtask

    // ---------------------------------------------------------------------
    // Main sequence
    // ---------------------------------------------------------------------
    initial begin
        repeat (10) @(posedge clk);
        rst_n = 1'b1;
        repeat (10) @(posedge clk);

        $display("=== chip_top end-to-end SPI test ===");
        `include "chip_vectors.vh"

        $display("=== vectors=%0d errors=%0d ===", vectors, errors);
        if (errors == 0) $display("RESULT: ALL PASS");
        else             $display("RESULT: FAILURES PRESENT");
        $finish;
    end

    // Global safety net
    initial begin
        #500_000_000;
        $display("GLOBAL TIMEOUT");
        $finish;
    end

endmodule
