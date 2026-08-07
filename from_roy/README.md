# TrustCore-v1 — SHA-256 / ASCON C Reference + RTL Package

## Contents

```
c_reference/
  sha256.h / sha256.c   — SHA-256 golden model (streaming, no-malloc)
  ascon.h  / ascon.c    — Ascon-Hash256 + Ascon-AEAD128 golden model
  test_sha256.c         — verifies sha256.c against known test vectors
  test_ascon.c           — verifies ascon.c self-consistency (encrypt/
                            decrypt round-trip, tamper detection)
  test_ascon2.c           — isolates the full-block (16-byte) decrypt case

rtl/
  sha256_core.sv         — streaming SHA-256 RTL core
  ascon_core.sv           — Ascon permutation core + Ascon-Hash256 wrapper

tb/
  tb_sha256_core.sv       — unit testbench: reset sequencing + KAT check
  TESTBENCH_METHODOLOGY.md — write-up of the reset / stimulus-check pattern,
                              applicable to all future testbenches in this project
```

## Verification status (as actually run in this session)

| Component | Status | How verified |
|---|---|---|
| `sha256.c` | **Verified correct** | Compiled and cross-checked against Python's `hashlib.sha256` for `"abc"` and `""` — exact match |
| `ascon.c` (AEAD128) | **Verified self-consistent** after one bug fix | Compiled; found and fixed a real bug in `ascon_aead_decrypt`'s finalization (was using `=` instead of `^=`, causing tag mismatches even on untampered data); after the fix: full-block and partial-block round-trip both pass, tamper detection correctly rejects modified ciphertext |
| `ascon.c` (Hash256) | **NOT independently verified** | Produces an output, but has not been cross-checked against an official Ascon-Hash256 KAT vector — do not trust this digest value yet |
| `sha256_core.sv` | Written, not yet simulated | `tb_sha256_core.sv` is provided to run this — requires a SystemVerilog simulator (e.g. Verilator, ModelSim/Questa, VCS) not available in this environment |
| `ascon_core.sv` | Written as a first-pass skeleton, not yet simulated | Round constants/rotations must be checked bit-for-bit against `ascon.c` and official KAT vectors before trusting |

## Critical action items before relying on any of this for tapeout

1. **Get official Ascon KAT vectors** (from the NIST SP 800-232 reference
   package or the Ascon team's GitHub) and add them to `test_ascon.c` /
   a future `tb_ascon_core.sv`. Self-consistency (this session's testing)
   proves the encrypt/decrypt pair agrees with *itself* — it does NOT
   prove agreement with the actual standard. Only official KAT vectors do that.
2. **Run `tb_sha256_core.sv` in an actual SystemVerilog simulator** — it
   was written and reviewed but not simulated in this environment (no
   SV simulator available here). The C-side SHA-256 logic it's meant to
   match has been verified; the RTL itself has not.
3. **`ascon_core.sv` is a first-pass skeleton**, explicitly flagged in
   its own header comment — the squeeze-phase timing in
   `ascon_hash_core` in particular should be reviewed carefully, and a
   dedicated `ascon_aead_core.sv` (full AEAD datapath, not just the
   permutation) still needs to be written following the same pattern
   as `sha256_core.sv`.
