# Testbench Design Methodology — TrustCore-v1

This note answers the two specific questions raised: **how to handle
reset**, and **how to verify that a given input produces the correct
output**. It uses `tb_sha256_core.sv` as the worked example, but the
same pattern applies to the ASCON core and the full-chip testbench.

---

## 1. Reset handling

### The rule
Reset is **asynchronous assert, synchronous de-assert**:

```systemverilog
task automatic apply_reset();
    rst_n = 0;                  // assert immediately (async)
    repeat (5) @(posedge clk);  // hold for several cycles — covers POR noise
    @(negedge clk);             // move away from a clock edge
    rst_n = 1;                  // release
    @(posedge clk);             // let the DUT register the release
endtask
```

**Why hold it for multiple cycles?** A single-cycle reset pulse can race
with clock-tree skew or POR (power-on-reset) glitches in real silicon.
Holding it for ~5 cycles in simulation is cheap insurance and mirrors
what you'd want on the actual board.

**Why release on `negedge`, not `posedge`?** Releasing reset exactly on
a rising edge creates ambiguity about whether the DUT "saw" the release
this cycle or next — a classic source of simulation/synthesis mismatch.
Releasing on the falling edge means the very next rising edge is
unambiguously the first cycle of normal operation.

### What to check immediately after reset
Every reset-recovery check should assert the DUT is in a **known idle
state** — not just "didn't crash":

```systemverilog
assert (busy == 1'b0)       else $error("busy should be 0 after reset");
assert (block_done == 1'b0) else $error("block_done should be 0 after reset");
```

For the top-level Security Control FSM specifically, this also means
checking `state_q == IDLE` and that `boot_ok`/`boot_err` are both 0 —
exactly the checks described earlier for the FSM-level testbench.

### Testing reset recovery from an error state
Don't just reset once at the start of the testbench. Reset **again**
after driving the DUT through a real operation, and confirm it comes
back to the same clean state:

```systemverilog
apply_reset();
run_one_block(...);   // do real work
apply_reset();         // reset again, mid-simulation
run_one_block(...);   // confirm it works identically the second time
```

For the FAULT-latching FSM discussed earlier, this is the *only* way
to exit `FAULT` — so a testbench that never re-resets after a
deliberate failure never actually tests the recovery path.

---

## 2. Input -> Output verification ("does this input give the right output")

### The three-part pattern
Every stimulus/check task follows the same shape:

1. **Drive the input** — hold it stable for exactly as many cycles as
   the DUT's protocol requires (usually one cycle for a "pulse" signal
   like `block_valid`, held-until-acknowledged for others).
2. **Wait for the DUT's own completion signal** — never use a fixed
   `#100` delay and hope it's done; wait on `block_done`, `busy`
   deasserting, or an explicit ready/valid handshake.
3. **Compare against a golden value** — using `===` (not `==`) so that
   any `X`/`Z` bits in the output are caught as failures rather than
   silently treated as mismatches or (worse) matches.

```systemverilog
task automatic run_one_block(input logic [511:0] block,
                              input logic [255:0] expected,
                              input string name);
    block_in    = block;
    block_valid = 1;
    @(posedge clk);
    block_valid = 0;

    wait (block_done == 1'b1);   // DUT tells us when it's ready
    @(posedge clk);

    if (state_out === expected)
        $display("[PASS] %s", name);
    else
        $error("[FAIL] %s: expected %h, got %h", name, expected, state_out);
endtask
```

### Where the "expected" value comes from — the golden model
This is the same **golden model** concept discussed for the overall
verification methodology: a trusted, independently-written reference
(here, `sha256.c` / `ascon.c`, or a well-known published test vector)
that the RTL's output is checked against. Two acceptable sources:

- **Hardcoded known-answer vectors** (as in `tb_sha256_core.sv`, using
  the standard SHA-256("abc") test vector) — good for a handful of
  fixed cases, easy to eyeball, and independent of your own C code
  (catches bugs that might exist in *both* your RTL and your C model
  if you only ever compared RTL against your own reference).
- **Scoreboard against `sha256.c`/`ascon.c` at runtime** — for
  randomized or larger-scale testing, a SystemVerilog DPI-C call into
  the actual golden-model C functions, comparing every RTL output
  against a freshly-computed reference for that specific random input.
  This scales far better than hand-writing vectors once you're doing
  hundreds of random test cases.

### Timing details that matter (and are easy to get wrong)
- **Sample outputs on the same edge the DUT intends them to be valid.**
  In `sha256_core.sv`, `block_done` was deliberately delayed by one
  cycle from the internal `S_FINALIZE` state specifically so that
  `state_out` is guaranteed valid *on* the `block_done` pulse — a
  testbench sampling `state_out` one cycle too early would see stale
  data and report a false failure.
- **Use `===`/`!==`, not `==`/`!=`, for pass/fail comparisons.** A
  4-valued `X` in the output compared with `==` against a known value
  evaluates to `X` in SystemVerilog (neither true nor false) — which
  can silently fail to trigger your `if`/`else`. `===` treats `X`
  correctly as "not equal to a known value."
- **Add a global timeout.** Every testbench in this project should
  have an `initial begin #TIMEOUT; $error(...); $finish; end` block
  running in parallel with the main test sequence, so that a stuck FSM
  (e.g., waiting forever for a `done` signal that never arrives)
  produces a clear failure instead of an indefinite hang.

---

## 3. Applying this to the ASCON core and the full-chip testbench

The same three building blocks — `apply_reset()`, a per-operation
stimulus/check task, and a golden-model comparison — extend directly:

- **`tb_ascon_core.sv`** (not yet written): same reset task, but the
  stimulus/check task drives `key`/`nonce`/`plaintext` and compares
  `ciphertext`+`tag` against `ascon_aead_encrypt()` from `ascon.c`, or
  `digest_out` against `ascon_hash()` for the hash-only core.
- **`tb_top.sv`** (full chip, not yet written): the stimulus becomes
  SPI transactions (via an SPI Master BFM — Bus Functional Model) that
  emulate the Host, and the "expected output" becomes the Security
  Control FSM's `boot_ok`/`boot_err` result, cross-checked against
  what the golden model computes for a given (firmware image, golden
  hash) pair — including the deliberate-mismatch test case described
  earlier (feed a tampered image, confirm `boot_err` latches and
  survives a retry attempt).

Known-Answer-Test (KAT) vectors for ASCON should be pulled from the
official Ascon test-vector release rather than hand-derived, given the
verification notice already flagged in `ascon.c`.
