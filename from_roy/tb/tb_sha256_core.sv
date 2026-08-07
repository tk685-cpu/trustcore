// tb_sha256_core.sv
//
// Demonstrates the testbench methodology discussed for TrustCore-v1:
//   1. How to drive reset correctly before any stimulus.
//   2. How to apply an input block and check the resulting output
//      against a golden reference (here: a hardcoded KAT vector for
//      SHA-256("abc") — replace with values from sha256.c / a
//      Python `hashlib.sha256` run for additional vectors).
//   3. SVA-style assertions on reset behavior.
//
// This is a unit-level testbench for sha256_core in isolation —
// separate from (and a prerequisite to) the full-chip tb_top.sv that
// exercises the SPI interface and Security Control FSM end-to-end.

`timescale 1ns/1ps

module tb_sha256_core;

    // ---- Clock / reset generation ----
    logic clk = 0;
    logic rst_n;

    always #5 clk = ~clk;  // 100 MHz

    // ---- DUT I/O ----
    logic         init;
    logic         block_valid;
    logic [511:0] block_in;
    logic         busy;
    logic         block_done;
    logic [255:0] state_out;

    sha256_core dut (
        .clk(clk), .rst_n(rst_n),
        .init(init), .block_valid(block_valid), .block_in(block_in),
        .busy(busy), .block_done(block_done), .state_out(state_out)
    );

    // =====================================================================
    // 1. RESET SEQUENCE
    // =====================================================================
    // General rule for this project: assert rst_n LOW asynchronously,
    // hold it for several clock cycles (covers POR noise), then release
    // it synchronously to a clock edge. Verify the DUT lands in a known
    // state before any stimulus is applied.

    task automatic apply_reset();
        rst_n       = 0;
        init        = 0;
        block_valid = 0;
        block_in    = '0;
        repeat (5) @(posedge clk);      // hold reset >= 5 cycles
        @(negedge clk);                 // release away from an edge
        rst_n = 1;
        @(posedge clk);

        // Post-reset checks — the DUT must be idle and quiescent.
        assert (busy == 1'b0)
            else $error("[RESET] busy should be 0 immediately after reset, got %0b", busy);
        assert (block_done == 1'b0)
            else $error("[RESET] block_done should be 0 immediately after reset, got %0b", block_done);
        $display("[RESET] OK at time %0t", $time);
    endtask

    // =====================================================================
    // 2. STIMULUS -> OUTPUT CHECK
    // =====================================================================
    // Golden reference: SHA-256("abc") padded to one 512-bit block.
    // "abc" = 0x61 0x62 0x63, padded per SHA-256 rules:
    //   61 62 63 80 00...00 <64-bit length = 0x18 (24 bits)>
    // Expected digest (well-known SHA-256 test vector):
    //   ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad

    localparam logic [511:0] ABC_PADDED_BLOCK = {
        8'h61, 8'h62, 8'h63, 8'h80,
        {26{8'h00}},           // zero padding (fills to byte 56)
        64'h0000000000000018   // bit length of "abc" = 24 bits, big-endian
    };

    localparam logic [255:0] ABC_EXPECTED_DIGEST =
        256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015;

    task automatic run_one_block(
        input  logic [511:0] block,
        input  logic [255:0] expected_digest,
        input  string        test_name
    );
        // Load IV (init pulse) — required before the first block of a
        // new message. For a multi-block message, init is pulsed only
        // once; subsequent blocks reuse the running state.
        init = 1;
        @(posedge clk);
        init = 0;

        // Present the block and pulse block_valid for exactly one cycle.
        block_in    = block;
        block_valid = 1;
        @(posedge clk);
        block_valid = 0;

        // Wait for the core to finish (busy deasserts, block_done pulses).
        wait (block_done == 1'b1);
        @(posedge clk); // sample on the block_done cycle boundary

        if (state_out === expected_digest) begin
            $display("[PASS] %s: digest = %h", test_name, state_out);
        end else begin
            $error("[FAIL] %s:\n  expected = %h\n  got      = %h",
                    test_name, expected_digest, state_out);
        end
    endtask

    // =====================================================================
    // 3. SVA-STYLE ASSERTIONS
    // =====================================================================
    // busy must never be high without a preceding init or block_valid pulse
    // having occurred since the last idle period (basic sanity/no-X check).
    property busy_implies_was_kicked;
        @(posedge clk) disable iff (!rst_n)
        $rose(busy) |-> ($past(init) || $past(block_valid));
    endproperty
    assert property (busy_implies_was_kicked)
        else $error("[SVA] busy asserted without init/block_valid pulse");

    // block_done must be a single-cycle pulse (not stuck high).
    property block_done_is_pulse;
        @(posedge clk) disable iff (!rst_n)
        block_done |-> ##1 !block_done;
    endproperty
    assert property (block_done_is_pulse)
        else $error("[SVA] block_done held high for more than one cycle");

    // =====================================================================
    // MAIN TEST SEQUENCE
    // =====================================================================
    initial begin
        apply_reset();
        run_one_block(ABC_PADDED_BLOCK, ABC_EXPECTED_DIGEST, "SHA256(\"abc\")");

        // Reset again mid-simulation and confirm clean recovery —
        // mirrors the "FAULT -> reset -> IDLE" recovery check used
        // for the Security Control FSM.
        apply_reset();
        run_one_block(ABC_PADDED_BLOCK, ABC_EXPECTED_DIGEST, "SHA256(\"abc\") after re-reset");

        $display("=== All SHA-256 core tests complete ===");
        $finish;
    end

    // Safety timeout in case block_done never arrives (hang detection).
    initial begin
        #100000;
        $error("[TIMEOUT] Simulation did not finish in time — possible hang");
        $finish;
    end

endmodule
