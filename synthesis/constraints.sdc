# constraints.sdc - timing constraints for TrustCore-v1 synthesis
# FREQ_MHZ is overridable via environment variable (set by a sweep script).
# Falls back to 25 when the design is synthesized standalone -- the
# frequency verified in simulation (tb_chip_top.sv SYS_CLK_HALF=20ns).


if {[info exists ::env(FREQ_MHZ)]} {
    set FREQ_MHZ $::env(FREQ_MHZ)
} else {
    set FREQ_MHZ 25
}

set PERIOD [expr 1000.0 / $FREQ_MHZ]

create_clock -name clk -period $PERIOD [get_ports clk]

# SPI clock is host-driven and not part of the frequency sweep -- fixed at
# 5 MHz (tb_chip_top.sv SCLK_HALF=100ns), always slower than clk.
create_clock -name sclk -period 200.0 [get_ports sclk]
set_clock_groups -asynchronous -group {clk} -group {sclk}

set IN_MAX  [expr 0.35 * $PERIOD]
set IN_MIN  [expr 0.05 * $PERIOD]
set OUT_MAX [expr 0.25 * $PERIOD]
set OUT_MIN [expr -0.05 * $PERIOD]

set DATA_IN_PORTS  [get_ports {mosi cs_n}]
set DATA_OUT_PORTS [get_ports miso]

set_input_delay  -clock sclk -max $IN_MAX  $DATA_IN_PORTS
set_input_delay  -clock sclk -min $IN_MIN  $DATA_IN_PORTS

set_output_delay -clock sclk -max $OUT_MAX $DATA_OUT_PORTS
set_output_delay -clock sclk -min $OUT_MIN $DATA_OUT_PORTS

# Reset is asynchronous active-low -- exclude from setup/hold timing paths
set_false_path -from [get_ports rst_n]

# Output load
set_load 0.05 [all_outputs]

# Driving cell - replace INV_X1 with the actual ETRI buffer/inverter cell name
# set_driving_cell -lib_cell INV_X1 \
#     [remove_from_collection [all_inputs] [get_ports {clk sclk}]]