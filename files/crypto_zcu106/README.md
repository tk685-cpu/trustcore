# Crypto chip: bug fixes and ZCU106 bring-up

Verified fixes to the SHA-256 / Ascon-128 SPI chip, plus the FPGA scaffolding
needed to validate it on a ZCU106 before tape-out.

Everything in `rtl/` is the ASIC deliverable. Everything in `rtl_fpga/` is
FPGA-only test scaffolding and is not intended to tape out. `chip_top` is
instantiated by the FPGA wrapper completely unmodified.

---

## 1. What was wrong

Six defects were found and fixed. Five of them were confirmed by running the
original RTL in simulation, not just by reading it.

### 1.1 Ascon-128 produced the wrong authentication tag

**Severity: critical. This is a cryptographic correctness bug, not just an
FPGA issue, and it would have shipped in silicon.**

Ascon requires the plaintext to be padded with `0x80` followed by zeros up to
a multiple of the 8-byte rate, and critically **a full padding block is
appended even when the length is already a multiple of 8**. The original core
skipped the padding block entirely.

The ciphertext still came out correct, because the padding block contributes no
ciphertext bytes. But the padding block is absorbed into the state before
finalization, so the tag was wrong for every single input.

Measured against the golden reference:

```
pt_len=0   tag got 2cd6a332f04aaf580df298a559aa76a9
           tag exp e355159f292911f794cb1432a0103a8a   <- NIST LWC KAT

pt_len=16  ct  got bc820dbdf7a4631c5b29884ad69175c3   <- ciphertext correct
           tag got f949e005f483688490270dd7033dfba5
           tag exp f58e28436dd71556d58dfa56ac890beb   <- tag wrong
```

A wrong tag is the worst kind of failure here: encryption looks like it works,
and the fault only surfaces when someone tries to decrypt or authenticate.

Fixed by implementing the padding inside the core, including the ciphertext
truncation mask so pad bytes never leak into the output. Now passes all 37
vectors covering every plaintext length 0 to 32, plus associated-data cases.

### 1.2 Result transmission never terminated

`byte_idx` in `spi_buffer_ctrl` was `reg [4:0]`, so it counted 0 to 31. The
transmit loop exited on `byte_idx >= result_len_latch` with `result_len_latch`
always 32. **A 5-bit counter can never reach 32**, so the comparison was never
true. The FSM streamed 32 correct bytes, then wrapped to 0 and kept streaming
zeros forever, never returning to idle.

The observable symptom: the first command works, and every command after it is
silently ignored.

Fixed by widening `byte_idx` to 6 bits.

### 1.3 MISO was one bit early from the second byte onward

The controller asserts `tx_load` a few system clocks after a byte completes,
which lands *before* the SCLK falling edge that ends that bit period. The
original code applied the load straight to the shift register, so that falling
edge then shifted the freshly loaded byte one more time.

Confirmed in simulation. Note the first byte is correct and it diverges from
the second:

```
got 63 1b 9b 53 cd 89 ...
exp 63 0d cd 29 66 c4 ...
     ^  ^^ every byte after the first is shifted left by one bit
```

This is the kind of bug that passes a core-level testbench and only appears
once you drive real SPI traffic.

Fixed by staging the incoming byte in `tx_hold` / `tx_pending` and swapping it
into the shifter **on** the falling edge, which is the actual byte boundary.

### 1.4 Message alignment mismatch

`spi_buffer_ctrl` accumulated data bytes by shifting into the LSB end, leaving
the message **right**-aligned. Both cores expect it **left**-aligned. The two
only agree when `DATA_LEN` is exactly 32, so any shorter message hashed the
wrong block.

Fixed by writing bytes to fixed left-aligned slots.

### 1.5 Zero-length input hung the receive loop

`S_RX_DATA` exited on `byte_idx == data_len_out - 1`. With `data_len_out` zero
that is `0xFF`, which `byte_idx` never reaches. Zero-length input is now a
valid request that launches the core directly, which also gives you
`SHA256("")` as a test vector.

### 1.6 Unrecognised commands still ran SHA-256

`sel_ascon <= cmd_ascon` meant a request with neither command bit set fell into
the SHA branch and returned a plausible-looking wrong answer. Commands and
lengths are now validated, and an invalid request raises `err` instead.

### Also corrected

- **SCLK frequency limit.** The header claimed 12.5 MHz at a 25 MHz system
  clock (`f_clk / 2`). That is not achievable. Edge detection compares adjacent
  synchronizer stages, and the TX byte handover needs three system clocks
  between a rising edge and the following falling edge. Measured by sweeping
  the rate in simulation:

  | SCLK      | Result |
  |-----------|--------|
  | f_clk/16  | pass   |
  | f_clk/10  | pass   |
  | f_clk/8   | pass   |
  | f_clk/6   | pass   |
  | f_clk/4   | **fail** |
  | f_clk/2   | **fail** |

  The documented limit is now `f_clk / 8`, which leaves margin above the
  measured failure point.

- **Frame abort recovery.** A frame that ends early used to leave the FSM stuck
  until reset. Receive states now abort cleanly back to idle, which matters a
  lot during bring-up: one glitch no longer means a board reset.

- **Watchdog.** If a core never asserted `done`, the chip locked up forever.
  `crypto_fsm` now bounds the wait and returns an error result.

- **Reset domain crossing.** `rst_n` was being used as an asynchronous reset in
  some blocks and a synchronous reset in others. That lets different parts of
  the design leave reset on different clock edges, which produces intermittent
  start-up failures that are very hard to reproduce. The FPGA wrapper now
  contains a proper async-assert / sync-release reset synchronizer and uses one
  consistent style throughout.

---

## 2. Architecture decisions

You asked me to choose rather than list options. Here is what I picked and why.

### Custom AXI4-Lite peripheral, not AXI Quad SPI

The obvious route is to drop in an AXI Quad SPI IP as the master. I went with a
small custom peripheral instead, for one decisive reason: **I can verify it end
to end in simulation, and I cannot verify your IP GUI settings.**

Concretely:

- AXI Quad SPI has a build-time frequency ratio, a slave-select register, FIFO
  behaviour and a driver (`XSpi`) with real subtleties around manual slave
  select. Every one of those is a place to lose a day.
- The custom peripheral has a runtime-settable clock divider, so you can sweep
  the SCLK rate on hardware to reproduce the margin table above.
- The whole PS-to-PL path is simulated in `tb_axi_top.v` using a real AXI4-Lite
  bus-functional model. That test passes.

The trade-off is roughly 300 lines of extra Verilog that you own. Given that
accuracy was the priority, having a verified path beat having a supported one.

### One clock domain

The AXI interface, the SPI master and `chip_top` all run on `pl_clk0` at
100 MHz. That means:

- No clock domain crossing anywhere in the design.
- The SPI path is an ordinary register-to-register path that static timing
  analysis fully covers, so there are no I/O timing constraints to get wrong.
- Timing closure at 100 MHz is strictly harder than at the 25 MHz ASIC target,
  so passing here tells you something useful.

Behaviour is identical to a 25 MHz clock because the design is fully
synchronous. What matters is the SCLK-to-clock ratio, not the absolute
frequency, and the default divider keeps that at `f_clk / 16`.

If you want ASIC fidelity, set `PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ` to 25 in
the block design. Nothing else needs to change.

### Software comparison, hardware blinking

The PS holds the golden vectors and does the comparison, so you can change test
cases without re-running synthesis. The blink patterns are generated in the PL,
so the indication keeps running even if the application stops or crashes.

### On the LEDs

You asked for red on failure and green on success. **The ZCU106 user LEDs are a
bank of single-colour LEDs, not RGB**, so literal red and green are not
available on the board itself. Two options:

1. Use two different user LEDs, told apart by position and blink rate. That is
   what the XDC does by default: `LED_PASS` solid on for success, `LED_FAIL`
   blinking fast for failure.
2. Wire a bi-colour or RGB LED to one of the user PMOD headers and move the two
   constraints to those pins. The RTL needs no changes.

Also: **verify the LED package pins against the master XDC for your board
revision** before building. There are several ZCU106 revisions. If the pins are
wrong the design still builds and the LEDs simply never light, which is a
frustrating thing to debug.

---

## 3. Verification

Everything below was actually run, not asserted.

| Test | What it covers | Result |
|---|---|---|
| `sha256_unit` | 36 vectors, every length 0 to 32, against Python `hashlib` | pass |
| `ascon_unit` | 37 vectors, every length 0 to 32 plus AD cases | pass |
| `chip_e2e` | 29 vectors through the real SPI pins, plus rejection and abort tests | pass |
| `axi_stack` | 12 vectors through a real AXI4-Lite bus-functional model | pass |
| `sclk_margin` | SCLK rate sweep to find the actual failure point | see table above |
| lint | Verilator `-Wall` on both `chip_top` and `crypto_axi_top` | clean |
| C build | `gcc -Wall -Wextra` on the Vitis application | clean |

The Ascon golden reference is validated against the published NIST LWC
known-answer test: key and nonce `000102...0F`, empty AD, empty plaintext gives
tag `E355159F292911F794CB1432A0103A8A`.

Run it all:

```bash
bash scripts/run_sim.sh
```

Requires `iverilog` and `python3`; `verilator` is optional and only used for
the lint step. On Ubuntu: `sudo apt install iverilog verilator`.

The script regenerates every vector from the Python golden reference before it
runs, so the `.vh` files are build artefacts rather than checked-in data. It
exits non-zero if anything regresses.

---

## 4. Building it

### Automatic

```bash
cd scripts
vivado -mode batch -source build_zcu106.tcl
```

**The Tcl was not executed** because no Vivado installation was available here.
The RTL and C were both verified by running them; the Tcl is written against
the standard API and resolves IP versions dynamically, but treat it as a
starting point. If it fails, build by hand: it is six steps.

### Manual block design

1. New RTL project, part `xczu7ev-ffvc1156-2-e` or board ZCU106. Add all files
   from `rtl/` and `rtl_fpga/`, and the XDC from `constraints/`.
2. Create a block design. Add **Zynq UltraScale+ MPSoC**, run block automation
   with the board preset.
3. Double-click the PS. Enable **PL Clock 0 at 100 MHz** and the
   **M_AXI_HPM0_LPD** master port. Everything else stays at the preset.
4. Right-click the canvas, Add Module, select `crypto_axi_top`. Vivado infers
   the AXI4-Lite interface from the `s_axi_*` port names.
5. Run connection automation on `crypto_0/s_axi`. That inserts the interconnect
   and reset block and wires the clocks.
6. Right-click `led_pass` and `led_fail`, Make External. Then Address Editor,
   Assign All. Validate, create HDL wrapper, generate bitstream.

Note the base address from the Address Editor. You will need it in the next
step.

### Vitis

1. Export hardware including the bitstream, creating an XSA.
2. New Application Project on that XSA, `psu_cortexa53_0`, standalone BSP,
   Empty Application (C).
3. Copy `vitis/main.c` and `vitis/crypto_vectors.h` into `src/`.
4. If the ID register read fails, set `CRYPTO_BASE` in `main.c` to the address
   from the Address Editor.
5. Program the FPGA, run, watch the UART at 115200 baud.

---

## 5. Bring-up order

Do not try to light the whole thing up at once.

**Step 1: read the ID register.** It returns `0x5AA5C0DE`. This is the single
most useful thing in the design. If it reads back correctly, then the
bitstream, clock, reset, address map and AXI path are all working, and any
later failure is a logic problem rather than an infrastructure problem. If it
reads `0x00000000` or `0xFFFFFFFF`, stop and fix that first: the application
prints a checklist for exactly this case.

**Step 2: run the SHA vectors.** These need no key or nonce, so they are the
simplest end-to-end path.

**Step 3: run the Ascon vectors.** If the ciphertext matches but the tag does
not, you are running the old core.

**Step 4: negative tests.** Bad command and oversize length must be rejected,
and the chip must answer correctly afterwards.

If something stalls, put an ILA on `data_ready`, `cmd_sha256`, `cmd_ascon`, the
`spi_buffer_ctrl` state register, `byte_idx`, `result_valid` and `busy`. On a
ZU7EV that costs almost nothing and shows you exactly which state it stalled
in.

---

## 6. Register map

Offsets from the base address in the Address Editor.

| Offset | Name | Access | Description |
|---|---|---|---|
| 0x00 | ID | RO | `0x5AA5C0DE`. Read this first. |
| 0x04 | CTRL | RW | `[0]` cs_n level (0 opens the frame), `[15:8]` SCLK divider |
| 0x08 | XFER | WO/RO | Write a byte to start a transfer. Read: `[7:0]` received byte, `[8]` busy |
| 0x0C | STATUS | RO | `[0]` spi_busy, `[1]` chip_busy, `[2]` result_ready, `[3]` chip_err |
| 0x10 | LED | RW | `[1:0]` 00 idle, 01 pass, 10 fail, 11 running |

SCLK divider is system clocks per half period, so
`f_SCLK = f_clk / (2 * divider)`. Minimum safe value 4; default 8.

## 7. Wire protocol

Command frame, one CS assertion:

| Bytes | Field |
|---|---|
| 0 | CMD: `0x01` SHA-256, `0x02` Ascon |
| 1 | DATA_LEN |
| 2-17 | KEY, 16 bytes, Ascon only |
| 18-33 | NONCE, 16 bytes, Ascon only |
| next | DATA, DATA_LEN bytes |

Length limits: SHA-256 accepts 0 to 32 bytes. Ascon accepts 0 to 16, because
the 256-bit result bus carries 16 ciphertext bytes plus the 16-byte tag.
Out-of-range requests raise `err` rather than silently truncating.

Then poll `STATUS.result_ready` and read 32 bytes back in a second frame:

- SHA-256: the digest
- Ascon: ciphertext (16 bytes, zero-padded above DATA_LEN) followed by the tag

Two separate frames matter. The crypto latency is not a fixed number of SPI
byte times, so reading in the same frame is fragile.

---

## 8. Files

```
rtl/                  ASIC deliverable, unchanged interface
  chip_top.v          top level, now with status pins
  spi_top.v
  spi_slave.v         TX byte-boundary fix
  spi_buffer_ctrl.v   counter width, alignment, length and abort handling
  crypto_fsm.v        command validation, watchdog
  sha256.v            length clamp, algorithm was already correct
  ascon128.v          spec-compliant padding

rtl_fpga/             FPGA-only scaffolding, do not tape out
  crypto_axi_top.v    AXI4-Lite peripheral, reset synchronizer
  spi_master_lite.v   SPI Mode 0 master
  status_led.v        blink patterns

constraints/zcu106_crypto.xdc
scripts/build_zcu106.tcl    Vivado project and block design (untested)
scripts/run_sim.sh          full regression runner

vitis/main.c                bare-metal known-answer test application
vitis/crypto_vectors.h      generated golden vectors

sim/golden.py               Python reference: SHA-256 and Ascon-128
sim/gen_vectors.py          regenerates every .vh vector file
sim/tb_sha_fix.v            SHA-256 unit test
sim/tb_ascon_fix.v          Ascon-128 unit test
sim/tb_chip_top.v           end to end through the SPI pins
sim/tb_axi_top.v            end to end through an AXI4-Lite bus model
sim/tb_rate.v               SCLK rate characterisation
```

## 9. Things to watch

- **Verify the LED pins** against the master XDC for your board revision.
- **The Tcl script is untested.** The RTL and C are not.
- **Ascon plaintext is capped at 16 bytes** by the result bus width, not by the
  core. If you need 32, the result readback has to grow to 48 bytes and both
  `crypto_fsm` and the protocol need updating.
- **Associated data is not reachable** over the SPI protocol (`ad_len` is tied
  to zero). The core implements AD correctly and it is covered by the unit
  tests, so exposing it later is a protocol change, not a core change.
- The async reset style in `rtl/` was deliberately left alone. Synchronous
  reset is the usual FPGA preference, but you want the FPGA exercising the same
  logic that tapes out.
