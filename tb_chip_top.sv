// tb_chip_top.sv  —  SystemVerilog testbench for chip_top.v
//
// Drives the full SPI interface: sends a formatted packet, reads back the result.
// Tests the full path: SPI -> spi_buffer_ctrl -> crypto_fsm -> ascon128 / sha256
//
// Compile:
//   iverilog -g2012 -o sim_chip tb_chip_top.sv chip_top.v spi_top.v spi_slave.v \
//     spi_buffer_ctrl.v crypto_fsm.v ascon128.v sha256.v
// Run all:  vvp sim_chip
// Run one:  vvp sim_chip +test-case=1     (1=SHA-256, 2=Ascon, 3=random)
// Seed:     vvp sim_chip +test-case=3 +seed=1234
//
// SPI packet format (see spi_buffer_ctrl.v):
//   CMD (1B) | DATA_LEN (1B) | [KEY 16B | NONCE 16B] | DATA (N bytes)
//   CMD 0x01 = SHA-256, CMD 0x02 = Ascon-128

`timescale 1ns/1ps

module tb_chip_top;

    parameter SYS_CLK_HALF = 20;    // 25 MHz system clock
    parameter SCLK_HALF    = 100;   // 5 MHz SPI clock (must be slower than sys clock)
    parameter SETUP_TIME   = 20;    // data setup time before SCLK rising edge

    // DUT signals
    logic clk, rst_n;
    logic sclk, mosi, miso, cs_n;

    chip_top dut (
        .clk(clk), .rst_n(rst_n),
        .sclk(sclk), .mosi(mosi), .miso(miso), .cs_n(cs_n)
    );

    initial clk = 1'b0;
    always #SYS_CLK_HALF clk = ~clk;

    int test_case = 0;   // 0 = run all
    int seed      = 42;
    int pass_cnt  = 0;
    int fail_cnt  = 0;
    bit verbose   = 0;   // set when a specific test case is picked with +test-case=N

    logic [7:0] rx_buf [0:31];   // holds bytes read back over MISO

    // -------------------------------------------------------------------------
    // Low-level SPI byte transfer: send tx MSB-first on MOSI, sample MISO into rx
    // -------------------------------------------------------------------------
    task automatic spi_xfer_byte(input logic [7:0] tx, output logic [7:0] rx);
        for (int b = 7; b >= 0; b--) begin
            mosi = tx[b];
            #SETUP_TIME;
            sclk = 1'b1;
            #SCLK_HALF;
            rx[b] = miso;
            sclk = 1'b0;
            #(SCLK_HALF - SETUP_TIME);
        end
    endtask

    task automatic spi_send_byte(input logic [7:0] tx);
        logic [7:0] dummy;
        spi_xfer_byte(tx, dummy);
    endtask

    task automatic spi_recv_byte(output logic [7:0] rx);
        spi_xfer_byte(8'hFF, rx);   // send dummy byte while reading
    endtask

    // -------------------------------------------------------------------------
    // High-level transactions
    // -------------------------------------------------------------------------

    // Send a SHA-256 packet, read back the 32-byte digest
    task automatic sha256_transaction(
        input  logic [255:0] message, input logic [7:0] msg_len,
        output logic [255:0] digest_out
    );
        cs_n = 1'b0;
        repeat(2) @(posedge clk);

        spi_send_byte(8'h01);      // CMD: SHA-256
        spi_send_byte(msg_len);    // LEN
        for (int i = 0; i < int'(msg_len); i++)
            spi_send_byte(message[255 - (i*8) -: 8]);

        repeat(200) @(posedge clk);   // wait for crypto core to finish

        for (int i = 0; i < 32; i++)
            spi_recv_byte(rx_buf[i]);

        cs_n = 1'b1;
        repeat(4) @(posedge clk);

        for (int i = 0; i < 32; i++)
            digest_out[255 - (i*8) -: 8] = rx_buf[i];
    endtask

    // Send an Ascon packet, read back 32 bytes (ciphertext + tag)
    task automatic ascon_transaction(
        input  logic [127:0] key, nonce,
        input  logic [255:0] plaintext, input logic [7:0] pt_len,
        output logic [255:0] result_out
    );
        cs_n = 1'b0;
        repeat(2) @(posedge clk);

        spi_send_byte(8'h02);      // CMD: Ascon
        spi_send_byte(pt_len);     // LEN
        for (int i = 0; i < 16; i++)
            spi_send_byte(key[127 - (i*8) -: 8]);
        for (int i = 0; i < 16; i++)
            spi_send_byte(nonce[127 - (i*8) -: 8]);
        for (int i = 0; i < int'(pt_len); i++)
            spi_send_byte(plaintext[255 - (i*8) -: 8]);

        repeat(400) @(posedge clk);   // Ascon takes longer than SHA-256

        for (int i = 0; i < 32; i++)
            spi_recv_byte(rx_buf[i]);

        cs_n = 1'b1;
        repeat(4) @(posedge clk);

        for (int i = 0; i < 32; i++)
            result_out[255 - (i*8) -: 8] = rx_buf[i];
    endtask

    // Named check — only prints a line when verbose is on
    task automatic check(input logic cond, input string label);
        if (cond) begin
            if (verbose) $display("  %s: PASS", label);
            pass_cnt++;
        end else begin
            if (verbose) $display("  %s: FAIL", label);
            fail_cnt++;
        end
    endtask

    // Test 1: SHA-256 over SPI
    task automatic test_case_1();
        logic [255:0] digest_a, digest_b;

        sha256_transaction({32'hDEADBEEF, 224'd0}, 8'd4, digest_a);
        check(digest_a !== 256'd0, "1.1");

        sha256_transaction(256'd0, 8'd0, digest_b);
        check(digest_b !== 256'd0, "1.2");
        check(digest_a !== digest_b, "1.3");

        sha256_transaction({32'hDEADBEEF, 224'd0}, 8'd4, digest_b);
        check(digest_a === digest_b, "1.4");
    endtask

    // Test 2: Ascon-128 over SPI
    task automatic test_case_2();
        logic [255:0] result_a, result_b, sha_result;

        ascon_transaction(128'h0102030405060708090a0b0c0d0e0f10,
                           128'hDEADBEEFCAFEBABE0102030405060708,
                           {64'hAABBCCDDEEFF0011, 192'd0}, 8'd8, result_a);
        check(result_a !== 256'd0 && result_a[127:0] !== 128'd0, "2.1");

        ascon_transaction(128'h0102030405060708090a0b0c0d0e0f10,
                           128'hDEADBEEFCAFEBABE0102030405060708,
                           {64'hAABBCCDDEEFF0011, 192'd0}, 8'd8, result_b);
        check(result_a === result_b, "2.2");

        ascon_transaction(128'h0000000000000000090a0b0c0d0e0f10,   // key changed
                           128'hDEADBEEFCAFEBABE0102030405060708,
                           {64'hAABBCCDDEEFF0011, 192'd0}, 8'd8, result_b);
        check(result_a !== result_b, "2.3");

        ascon_transaction(128'h0102030405060708090a0b0c0d0e0f10,
                           128'hFFFFFFFFCAFEBABE0102030405060708,   // nonce changed
                           {64'hAABBCCDDEEFF0011, 192'd0}, 8'd8, result_b);
        check(result_a !== result_b, "2.4");

        sha256_transaction({8'hAB, 248'd0}, 8'd1, sha_result);
        check(sha_result !== 256'd0, "2.5");
    endtask

    // Test 3: Random transactions (aggregated)
    task automatic test_case_3();
        logic [127:0] k, n;
        logic [255:0] pt, msg, result_a, result_b;
        logic [7:0]   len;
        int i, fails;

        // 3.1 SHA-256 determinism, 10 random messages
        fails = 0;
        for (i = 0; i < 20; i++) begin
            msg = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed),
                   $urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            len = ($urandom(seed) % 8) + 1;
            sha256_transaction(msg, len, result_a);
            sha256_transaction(msg, len, result_b);
            if (result_a !== result_b) fails++;
        end
        check(fails == 0, "3.1");

        // 3.2 Ascon determinism, 5 random encryptions
        fails = 0;
        for (i = 0; i < 20; i++) begin
            k   = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            n   = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            pt  = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed),
                   $urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            len = ($urandom(seed) % 8) + 1;
            ascon_transaction(k, n, pt, len, result_a);
            ascon_transaction(k, n, pt, len, result_b);
            if (result_a !== result_b) fails++;
        end
        check(fails == 0, "3.2");

        // 3.3 Interleaved SHA-256 / Ascon, 8 random rounds
        fails = 0;
        for (i = 0; i < 20; i++) begin
            if ($urandom(seed) % 2) begin
                msg = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed),
                       $urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
                len = ($urandom(seed) % 8) + 1;
                sha256_transaction(msg, len, result_a);
            end else begin
                k   = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
                n   = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
                pt  = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed),
                       $urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
                len = ($urandom(seed) % 8) + 1;
                ascon_transaction(k, n, pt, len, result_a);
            end
            if (result_a === 256'd0) fails++;
        end
        check(fails == 0, "3.3");
    endtask

    // Runs one test case, prints how many of its checks passed
    task automatic run_test(input int num);
        int pass_before = pass_cnt;
        int fail_before = fail_cnt;
        int total;
        case (num)
            1: test_case_1();
            2: test_case_2();
            3: test_case_3();
        endcase
        total = (pass_cnt + fail_cnt) - (pass_before + fail_before);
        $display("Test %0d: %0d/%0d passed", num, pass_cnt - pass_before, total);
    endtask

    // Top-level stimulus
    initial begin
        void'($value$plusargs("test-case=%d", test_case));
        void'($value$plusargs("seed=%d", seed));
        verbose = (test_case != 0);   // show per-check detail only when a test is picked

        // Only record a waveform when zoomed into one test — a full run with
        // random SPI transactions can generate a huge trace and blow up memory
        if (verbose) begin
            $dumpfile("tb_chip_top.vcd");
            $dumpvars(0, tb_chip_top);
        end

        rst_n = 1'b0;
        sclk = 1'b0; mosi = 1'b0; cs_n = 1'b1;
        repeat(8) @(posedge clk);
        rst_n = 1'b1;
        repeat(4) @(posedge clk);

        case (test_case)
            1: run_test(1);
            2: run_test(2);
            3: run_test(3);
            default: begin
                run_test(1);
                run_test(2);
                run_test(3);
            end
        endcase

        $display("SUMMARY: %0d passed, %0d failed", pass_cnt, fail_cnt);
        $finish;
    end

endmodule
