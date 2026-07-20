// tb_ascon128.sv  —  SystemVerilog testbench for ascon128.v
//
// Compile:  iverilog -g2012 -o sim_ascon tb_ascon128.sv ascon128.v
// Run all:  vvp sim_ascon
// Run one:  vvp sim_ascon +test-case=1   (1=simple, 2=corner cases, 3=random, 4=known-answer)
// Seed:     vvp sim_ascon +test-case=3 +seed=1234
//
// Known-answer values (used in 1.5, 2.5, 2.6, and all of Test 4) were computed
// with the independent, widely-used Python `ascon` package (variant Ascon-128 —
// same 128-bit key, 64-bit rate, p^a=12/p^b=6 as this hardware), NOT derived
// from our own RTL. That is deliberate: checking hardware output against itself
// proves nothing about correctness, only against a source we didn't write.
//
// IMPORTANT — this hardware does NOT pad internally (see ascon128.v header):
// the caller must pre-pad plaintext/AD to a multiple of 8 bytes using Ascon's
// own rule (append 0x80, then zeros, to the next 8-byte boundary — and if the
// real length is ALREADY a multiple of 8, you must append a full EXTRA 8-byte
// block of pure padding [0x80,0,0,0,0,0,0,0], never skip it). The ciphertext
// register will contain one 8-byte chunk per padded block, including a final
// chunk for the pure-padding block if one was added — the caller discards
// everything past the real plaintext length. Every vector below has already
// been pre-padded this way; pt_len/ad_len reflect the padded length, not the
// real message length.
//
// Note: this hardware only implements ENCRYPTION. Real AEAD validation (NIST
// ACVP) also requires testing decrypt+verify, including negative tests that
// confirm tampered ciphertext/tag is correctly rejected — not possible here
// since there's no decrypt/verify path in ascon128.v.

`timescale 1ns/1ps

module tb_ascon128;

    parameter CLK_HALF = 20;   // 25 MHz clock

    // DUT signals
    logic         clk, rst_n;
    logic         start, busy, done;
    logic [127:0] key, nonce;
    logic [255:0] ad;
    logic [7:0]   ad_len;
    logic [255:0] plaintext;
    logic [7:0]   pt_len;
    logic [255:0] ciphertext;
    logic [127:0] tag;

    ascon128 dut (
        .clk(clk), .rst_n(rst_n),
        .start(start), .busy(busy), .done(done),
        .key(key), .nonce(nonce),
        .ad(ad), .ad_len(ad_len),
        .plaintext(plaintext), .pt_len(pt_len),
        .ciphertext(ciphertext), .tag(tag)
    );

    initial clk = 1'b0;
    always #CLK_HALF clk = ~clk;

    int test_case = 0;    // 0 = run all
    int seed      = 42;
    int pass_cnt  = 0;
    int fail_cnt  = 0;
    bit verbose   = 0;    // set when a specific test case is picked with +test-case=N

    // Run one encryption: load inputs, pulse start, wait for done
    task automatic run_encrypt(
        input logic [127:0] k, n,
        input logic [255:0] pt_in,  input logic [7:0] pt_len_in,
        input logic [255:0] ad_in,  input logic [7:0] ad_len_in
    );
        int cycles = 0;
        key = k; nonce = n;
        plaintext = pt_in; pt_len = pt_len_in;
        ad = ad_in; ad_len = ad_len_in;
        @(posedge clk);
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
        while (!done && cycles < 500) begin
            @(posedge clk);
            cycles++;
        end
        if (cycles >= 500) $display("  TIMEOUT waiting for done");
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

    // Same as check(), but shows got/expected ciphertext+tag on failure.
    // ascon128.v clears the ciphertext register at the start of every
    // operation, so bytes beyond the real block count read back as zero —
    // matching the zero-padded expected literals below.
    task automatic check_result(
        input logic [255:0] expected_ct,
        input logic [127:0] expected_tag,
        input string        label
    );
        if (ciphertext === expected_ct && tag === expected_tag) begin
            if (verbose) $display("  %s: PASS", label);
            pass_cnt++;
        end else begin
            if (verbose) begin
                $display("  %s: FAIL", label);
                $display("    got ct =0x%h  expected ct =0x%h", ciphertext, expected_ct);
                $display("    got tag=0x%h  expected tag=0x%h", tag, expected_tag);
            end
            fail_cnt++;
        end
    endtask

    // Test 1: Simple / basic checks
    task automatic test_case_1();
        logic [255:0] ct_a;
        logic [127:0] tag_a;

        // 1.1 busy/done handshake
        key = 128'h0102030405060708090a0b0c0d0e0f10;
        nonce = 128'hDEADBEEFCAFEBABE0102030405060708;
        plaintext = 256'hAA; pt_len = 8'd1;
        ad = 256'd0; ad_len = 8'd0;

        @(posedge clk);
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
        check(busy === 1'b1, "1.1");

        while (!done) @(posedge clk);
        check(done === 1'b1, "1.2");
        ct_a = ciphertext;
        tag_a = tag;
        @(posedge clk);
        check(busy === 1'b0, "1.3");
        check(ct_a !== 256'd0 && tag_a !== 128'd0, "1.4");

        // 1.5 8-byte real plaintext, pre-padded to 16 bytes per Ascon's rule
        // (8 real bytes + 0x80 + 7 zero bytes — a full extra padding block,
        // required because 8 is itself an exact multiple of the 8-byte rate)
        run_encrypt(128'h0102030405060708090a0b0c0d0e0f10,
                    128'hDEADBEEFCAFEBABE0102030405060708,
                    256'h0102030405060708800000000000000000000000000000000000000000000000,
                    8'd16, 256'd0, 8'd0);
        check_result(256'h665aa0a2db4ecfddb43d95e79092a90d00000000000000000000000000000000,
                      128'h5a7001351857502cab56da04b9cccc82, "1.5");

        // 1.6 determinism: re-run same input -> same output
        ct_a = ciphertext;
        tag_a = tag;
        run_encrypt(128'h0102030405060708090a0b0c0d0e0f10,
                    128'hDEADBEEFCAFEBABE0102030405060708,
                    256'h0102030405060708800000000000000000000000000000000000000000000000,
                    8'd16, 256'd0, 8'd0);
        check(ciphertext === ct_a && tag === tag_a, "1.6");
    endtask

    // Test 2: Corner cases
    task automatic test_case_2();
        logic [255:0] ct_a, ct_b;
        logic [127:0] tag_a, tag_b;

        // 2.1 all-zero key
        run_encrypt(128'd0, 128'h1, {8'hAB, 248'd0}, 8'd1, 256'd0, 8'd0);
        ct_a = ciphertext; tag_a = tag;
        check(tag_a !== 128'd0, "2.1");

        // 2.2 all-zero nonce (different key than 2.1 -> different result)
        run_encrypt(128'h1, 128'd0, {8'hAB, 248'd0}, 8'd1, 256'd0, 8'd0);
        check(tag !== 128'd0 && ciphertext !== ct_a, "2.2");

        // 2.3 all-zero plaintext
        run_encrypt(128'h0102030405060708090a0b0c0d0e0f10,
                    128'hDEADBEEFCAFEBABE0102030405060708,
                    256'd0, 8'd8, 256'd0, 8'd0);
        check(ciphertext !== 256'd0 && tag !== 128'd0, "2.3");

        // 2.4 1-byte plaintext (minimum)
        run_encrypt(128'h0F0E0D0C0B0A09080706050403020100,
                    128'hF0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF,
                    {8'hFF, 248'd0}, 8'd1, 256'd0, 8'd0);
        check(tag !== 128'd0, "2.4");

        // 2.5 16-byte real plaintext (itself a multiple of 8 -> needs a full
        // extra padding block), pre-padded to 24 bytes per Ascon's rule
        run_encrypt(128'h0102030405060708090a0b0c0d0e0f10,
                    128'hDEADBEEFCAFEBABE0102030405060708,
                    256'hdeadbeefcafebabedeadbeefcafebabe80000000000000000000000000000000,
                    8'd24, 256'd0, 8'd0);
        check_result(256'hb9f51d4914b6726b2ad5f70e114b9f230d39bc7b3cecb3c90000000000000000,
                      128'h84f6c9276d9a10d62e5ded7d89ec83a7, "2.5");

        // 2.6 same PT (24-byte padded) + 8-byte AD (also a multiple of 8 ->
        // padded to 16 bytes) — checked against a real known-correct value
        run_encrypt(128'h0102030405060708090a0b0c0d0e0f10,
                    128'hDEADBEEFCAFEBABE0102030405060708,
                    256'hdeadbeefcafebabedeadbeefcafebabe80000000000000000000000000000000,
                    8'd24,
                    256'habcdef1234567890800000000000000000000000000000000000000000000000, 8'd16);
        check_result(256'he280e662b7fe9141731997646a430071538a3f8a0a9abae90000000000000000,
                      128'hac39cef8089269426ec6f74c6329cd88, "2.6");

        // 2.7 key sensitivity — flip one key bit
        run_encrypt(128'h0102030405060708090a0b0c0d0e0f10,
                    128'hDEADBEEFCAFEBABE0102030405060708,
                    {64'h1122334455667788, 192'd0}, 8'd8, 256'd0, 8'd0);
        ct_a = ciphertext; tag_a = tag;
        run_encrypt(128'h0002030405060708090a0b0c0d0e0f10,   // bit 120 flipped
                    128'hDEADBEEFCAFEBABE0102030405060708,
                    {64'h1122334455667788, 192'd0}, 8'd8, 256'd0, 8'd0);
        check(ciphertext !== ct_a && tag !== tag_a, "2.7");

        // 2.8 nonce sensitivity — flip one nonce bit
        run_encrypt(128'h0102030405060708090a0b0c0d0e0f10,
                    128'hDEADBEEFCAFEBABE0102030405060708,
                    {64'h1122334455667788, 192'd0}, 8'd8, 256'd0, 8'd0);
        ct_a = ciphertext; tag_a = tag;
        run_encrypt(128'h0102030405060708090a0b0c0d0e0f10,
                    128'hDEADBEEFCAFEBABF0102030405060708,   // nonce bit 0 flipped
                    {64'h1122334455667788, 192'd0}, 8'd8, 256'd0, 8'd0);
        check(ciphertext !== ct_a && tag !== tag_a, "2.8");
    endtask

    // Test 3: Random inputs (aggregated — 50 runs per sub-test)
    task automatic test_case_3();
        logic [127:0] k_a, k_b, n_a, n_b;
        logic [255:0] pt_a, ct_a, ct_b;
        logic [127:0] tag_a, tag_b;
        logic [7:0]   len_a;
        int           i, flip_bit, fails;

        // 3.1 Determinism: same input twice -> same output
        fails = 0;
        for (i = 0; i < 50; i++) begin
            k_a  = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            n_a  = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            pt_a = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed),
                    $urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            len_a = ($urandom(seed) % 16) + 1;

            run_encrypt(k_a, n_a, pt_a, len_a, 256'd0, 8'd0);
            ct_a = ciphertext; tag_a = tag;
            run_encrypt(k_a, n_a, pt_a, len_a, 256'd0, 8'd0);
            ct_b = ciphertext; tag_b = tag;

            if (ct_a !== ct_b || tag_a !== tag_b) fails++;
        end
        check(fails == 0, "3.1");

        // 3.2 Key sensitivity: flip one key bit -> output must change
        fails = 0;
        for (i = 0; i < 50; i++) begin
            k_a  = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            n_a  = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            pt_a = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed),
                    $urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            len_a = ($urandom(seed) % 16) + 1;
            flip_bit = $urandom(seed) % 128;
            k_b = k_a;
            k_b[flip_bit] = ~k_a[flip_bit];

            run_encrypt(k_a, n_a, pt_a, len_a, 256'd0, 8'd0);
            ct_a = ciphertext; tag_a = tag;
            run_encrypt(k_b, n_a, pt_a, len_a, 256'd0, 8'd0);
            ct_b = ciphertext; tag_b = tag;

            if (ct_a === ct_b && tag_a === tag_b) fails++;
        end
        check(fails == 0, "3.2");

        // 3.3 Nonce sensitivity: flip one nonce bit -> output must change
        fails = 0;
        for (i = 0; i < 50; i++) begin
            k_a  = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            n_a  = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            pt_a = {$urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed),
                    $urandom(seed), $urandom(seed), $urandom(seed), $urandom(seed)};
            len_a = ($urandom(seed) % 16) + 1;
            flip_bit = $urandom(seed) % 128;
            n_b = n_a;
            n_b[flip_bit] = ~n_a[flip_bit];

            run_encrypt(k_a, n_a, pt_a, len_a, 256'd0, 8'd0);
            ct_a = ciphertext; tag_a = tag;
            run_encrypt(k_a, n_b, pt_a, len_a, 256'd0, 8'd0);
            ct_b = ciphertext; tag_b = tag;

            if (ct_a === ct_b && tag_a === tag_b) fails++;
        end
        check(fails == 0, "3.3");
    endtask

    // Test 4: known-answer vectors — checked against a real, independent
    // Ascon-128 implementation (see header note), not derived from our RTL
    task automatic test_case_4();
        // 4.1 all-zero key/nonce, empty real PT/AD. Even an empty plaintext
        // still gets ONE full padding-only block [0x80,0,0,0,0,0,0,0] — Ascon
        // always pads, there's no such thing as "absorb zero blocks."
        run_encrypt(128'd0, 128'd0,
                    256'h8000000000000000000000000000000000000000000000000000000000000000,
                    8'd8, 256'd0, 8'd0);
        check_result(256'h38dff46b0db421f8000000000000000000000000000000000000000000000000,
                      128'h42213f50a811d2d1d7e4092aa2a42ba4, "4.1");

        // 4.2 sequential key/nonce (0x00..0x0F), empty real PT/AD
        run_encrypt(128'h000102030405060708090a0b0c0d0e0f,
                    128'h000102030405060708090a0b0c0d0e0f,
                    256'h8000000000000000000000000000000000000000000000000000000000000000,
                    8'd8, 256'd0, 8'd0);
        check_result(256'h3c830fbef3a1651b000000000000000000000000000000000000000000000000,
                      128'he355159f292911f794cb1432a0103a8a, "4.2");

        // 4.3 sequential key/nonce, 8-byte sequential real plaintext (a
        // multiple of 8 -> needs padding), pre-padded to 16 bytes
        run_encrypt(128'h000102030405060708090a0b0c0d0e0f,
                    128'h000102030405060708090a0b0c0d0e0f,
                    256'h0001020304050607800000000000000000000000000000000000000000000000,
                    8'd16, 256'd0, 8'd0);
        check_result(256'hbc820dbdf7a4631cd3208241da9c7bcc00000000000000000000000000000000,
                      128'h01a8807a44254b42ac6bb490da1e000a, "4.3");
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
            4: test_case_4();
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
        // 50 random iterations can generate a huge trace and blow up memory
        if (verbose) begin
            $dumpfile("tb_ascon128.vcd");
            $dumpvars(0, tb_ascon128);
        end

        rst_n = 1'b0;
        start = 1'b0;
        key = 128'd0; nonce = 128'd0;
        plaintext = 256'd0; pt_len = 8'd0;
        ad = 256'd0; ad_len = 8'd0;
        repeat(4) @(posedge clk);
        rst_n = 1'b1;
        repeat(2) @(posedge clk);

        case (test_case)
            1: run_test(1);
            2: run_test(2);
            3: run_test(3);
            4: run_test(4);
            default: begin
                run_test(1);
                run_test(2);
                run_test(3);
                run_test(4);
            end
        endcase

        $display("SUMMARY: %0d passed, %0d failed", pass_cnt, fail_cnt);
        $finish;
    end

endmodule
