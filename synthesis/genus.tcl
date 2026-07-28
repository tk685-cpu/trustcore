# genus.tcl - Cadence Genus logic synthesis for TrustCore-v1
# Run with: genus -batch -files synthesis/genus.tcl

# --- library setup ---
set_db library $::env(LIB)
# Physical-aware synthesis (only if you have these):
# set_db lef_library    $::env(LEF)
# set_db qrc_tech_file  $::env(QRC)

set DESIGN $::env(SYN_TOP)

# --- read RTL (no package for this design; leaf -> top) ---
# -v, not -sv: these are plain Verilog-2001 sources (.v), no SystemVerilog
# constructs -- only the testbenches use SV, and they aren't part of synthesis.
set RTL_LIST { \
    ../rtl/sha256.v \
    ../rtl/ascon128.v \
    ../rtl/crypto_fsm.v \
    ../rtl/spi_slave.v \
    ../rtl/spi_top.v \
    ../rtl/spi_buffer_ctrl.v \
    ../rtl/chip_top.v \
}
read_hdl -v $RTL_LIST

# --- elaborate and check for unresolved refs ---
elaborate $DESIGN
check_design -unresolved

# --- timing constraints ---
read_sdc constraints.sdc

# --- effort levels ---
set_db syn_generic_effort medium
set_db syn_map_effort     medium
set_db syn_opt_effort     medium

# --- synthesize ---
syn_generic
syn_map
syn_opt

# --- reports ---
report_timing > $::env(RPT_DIR)/genus_timing_${FREQ_MHZ}.rpt
report_area   > $::env(RPT_DIR)/genus_area_${FREQ_MHZ}.rpt
report_power  > $::env(RPT_DIR)/genus_power_${FREQ_MHZ}.rpt
report_gates  > $::env(RPT_DIR)/genus_gates_${FREQ_MHZ}.rpt

# --- outputs ---
write_hdl > $::env(NETLIST_DIR)/${DESIGN}_genus.v
write_sdc > $::env(NETLIST_DIR)/${DESIGN}_genus.sdc

exit