#!/usr/bin/env bash
# ============================================================================
# run_sim.sh
# Runs the full verification regression with Icarus Verilog.
#
#   ./run_sim.sh          run everything
#   ./run_sim.sh lint     lint only
#
# Requires: iverilog, python3. verilator is optional and used for lint.
# ============================================================================
set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$HERE")"
RTL="$ROOT/rtl"
FPGA="$ROOT/rtl_fpga"
SIM="$ROOT/sim"

FAILED=0
banner() { echo; echo "##########  $1  ##########"; }

# ---------------------------------------------------------------------------
# Lint
# ---------------------------------------------------------------------------
if command -v verilator >/dev/null 2>&1; then
    banner "LINT"
    out=$(verilator --lint-only -Wall --top-module chip_top "$RTL"/*.v 2>&1)
    if [ -z "$out" ]; then echo "  chip_top:        clean"
    else echo "  chip_top:        WARNINGS"; echo "$out" | head -20; FAILED=1; fi

    out=$(verilator --lint-only -Wall --top-module crypto_axi_top \
                    "$RTL"/*.v "$FPGA"/*.v 2>&1)
    if [ -z "$out" ]; then echo "  crypto_axi_top:  clean"
    else echo "  crypto_axi_top:  WARNINGS"; echo "$out" | head -20; FAILED=1; fi
else
    echo "NOTE: verilator not installed, skipping lint"
fi

if [ "${1:-}" = "lint" ]; then exit $FAILED; fi

# ---------------------------------------------------------------------------
# Golden vectors
# ---------------------------------------------------------------------------
banner "GOLDEN VECTORS"
cd "$SIM" || exit 1
if ! python3 gen_vectors.py; then
    echo "  vector generation FAILED"
    exit 1
fi

# ---------------------------------------------------------------------------
# Simulations
#
# Every self-checking testbench prints a summary line. A run counts as failed
# if it does not report zero errors.
# ---------------------------------------------------------------------------
run_tb () {
    local name="$1"; shift
    banner "$name"
    if ! iverilog -g2005 -o "/tmp/${name}.vvp" "$@" 2>&1; then
        echo "  COMPILE FAILED"; FAILED=1; return
    fi
    local out
    out="$(vvp "/tmp/${name}.vvp")"
    if echo "$out" | grep -q "FAIL"; then
        echo "$out"
    else
        echo "$out" | grep -E "errors=|RESULT" | tail -4
    fi
    if ! echo "$out" | grep -qE "errors=0"; then FAILED=1; fi
}

run_tb button_unit  tb_button.v    "$FPGA/button_ctrl.v"
run_tb sha256_unit  tb_sha_fix.v   "$RTL/sha256.v"
run_tb ascon_unit   tb_ascon_fix.v "$RTL/ascon128.v"
run_tb chip_e2e     tb_chip_top.v  "$RTL"/*.v
run_tb axi_stack    tb_axi_top.v   "$RTL"/*.v "$FPGA"/*.v

# ---------------------------------------------------------------------------
# SCLK rate margin sweep
#
# This one is characterisation, not pass/fail. It deliberately drives the SPI
# link past its documented limit to show where it actually breaks, so the FAIL
# lines below f_clk/6 are the expected result, not a regression.
# ---------------------------------------------------------------------------
banner "sclk_margin (characterisation, FAIL past f_clk/6 is expected)"
if iverilog -g2005 -o /tmp/sclk_margin.vvp tb_rate.v "$RTL"/*.v 2>&1; then
    vvp /tmp/sclk_margin.vvp | grep -E "SCLK ="
else
    echo "  COMPILE FAILED"; FAILED=1
fi

# ---------------------------------------------------------------------------
banner "SUMMARY"
if [ "$FAILED" -eq 0 ]; then
    echo "ALL TESTS PASSED"
else
    echo "SOME TESTS FAILED"
fi
exit $FAILED
