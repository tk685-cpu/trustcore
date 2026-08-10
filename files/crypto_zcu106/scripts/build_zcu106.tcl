#-----------------------------------------------------------------------------
# build_zcu106.tcl
# Creates the Vivado project, block design and bitstream for the crypto chip
# validation design on the ZCU106.
#
# Run from the directory containing this script:
#     vivado -mode batch -source build_zcu106.tcl
#
# or from the Vivado Tcl console:
#     cd <this directory>
#     source build_zcu106.tcl
#
#-----------------------------------------------------------------------------
# HONEST CAVEAT
#
# The RTL and the C application in this deliverable were both verified by
# actually running them (simulation and compilation respectively). This Tcl
# script was NOT executed, because no Vivado installation was available. It is
# written against the standard IP Integrator API and resolves IP version
# numbers dynamically rather than hard-coding them, but treat it as a starting
# point rather than a guaranteed one-shot build.
#
# If a step fails, the block design is small enough to build by hand in a few
# minutes: see the "Manual block design" section of README.md, which lists the
# same six steps in GUI terms.
#
# Requires the ZCU106 board files to be installed. If Vivado reports that the
# board part is unknown, install them via Tools > Vivado Store > Boards, or set
# BOARD_PART to "" below and configure the PS DDR manually.
#-----------------------------------------------------------------------------

set PROJ_NAME   "crypto_zcu106"
set PROJ_DIR    "./vivado_proj"
set PART        "xczu7ev-ffvc1156-2-e"
set BOARD_PART  "xilinx.com:zcu106:part0:2.6"
set BD_NAME     "system"
set TOP_MODULE  "crypto_axi_top"

# Source locations, relative to this script
set RTL_DIR     "../rtl"
set FPGA_DIR    "../rtl_fpga"
set XDC_DIR     "../constraints"

#-----------------------------------------------------------------------------
# Helper: find the newest installed version of an IP, so the script does not
# break every time Vivado bumps a minor version number.
#-----------------------------------------------------------------------------
proc latest_vlnv {ipname} {
    set matches [lsort -dictionary [get_ipdefs -all "xilinx.com:ip:${ipname}:*"]]
    if {[llength $matches] == 0} {
        error "IP '$ipname' not found in the catalog"
    }
    return [lindex $matches end]
}

#-----------------------------------------------------------------------------
# Project
#-----------------------------------------------------------------------------
file delete -force $PROJ_DIR
create_project $PROJ_NAME $PROJ_DIR -part $PART -force

if {$BOARD_PART ne ""} {
    if {[llength [get_board_parts -quiet $BOARD_PART]] > 0} {
        set_property board_part $BOARD_PART [current_project]
        puts "INFO: board part set to $BOARD_PART"
    } else {
        puts "WARNING: board part $BOARD_PART not installed."
        puts "WARNING: continuing without it; you must configure PS DDR manually."
        set BOARD_PART ""
    }
}

#-----------------------------------------------------------------------------
# Sources
#
# The chip RTL is added unmodified. crypto_axi_top, spi_master_lite and
# status_led are FPGA-only scaffolding and are kept in a separate directory so
# it stays obvious which files are part of the ASIC deliverable.
#-----------------------------------------------------------------------------
add_files -norecurse [glob $RTL_DIR/*.v]
add_files -norecurse [glob $FPGA_DIR/*.v]
add_files -fileset constrs_1 -norecurse [glob $XDC_DIR/*.xdc]
update_compile_order -fileset sources_1

#-----------------------------------------------------------------------------
# Block design
#-----------------------------------------------------------------------------
create_bd_design $BD_NAME

# ---- Zynq UltraScale+ MPSoC processing system ----
set ps [create_bd_cell -type ip -vlnv [latest_vlnv zynq_ultra_ps_e] zynq_ps]

if {$BOARD_PART ne ""} {
    apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e \
        -config {apply_board_preset "1"} [get_bd_cells zynq_ps]
}

# One PL clock at 100 MHz, one AXI master port, no PL-to-PS ports needed.
set_property -dict [list \
    CONFIG.PSU__USE__M_AXI_GP0            {1} \
    CONFIG.PSU__USE__M_AXI_GP1            {0} \
    CONFIG.PSU__USE__M_AXI_GP2            {0} \
    CONFIG.PSU__USE__S_AXI_GP0            {0} \
    CONFIG.PSU__FPGA_PL0_ENABLE__ENABLE   {1} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
] [get_bd_cells zynq_ps]

# ---- The peripheral under test ----
# Added as an RTL module rather than a packaged IP. Vivado infers the AXI4-Lite
# slave interface from the s_axi_* port naming, and the clock and reset from
# s_axi_aclk / s_axi_aresetn.
set dut [create_bd_cell -type module -reference $TOP_MODULE crypto_0]

#-----------------------------------------------------------------------------
# Connect the PS master to the peripheral.
# The axi4 automation rule inserts the interconnect and the reset block and
# wires the clocks, which is the part that is tedious and error-prone by hand.
#-----------------------------------------------------------------------------
set ps_master ""
foreach cand {M_AXI_HPM0_LPD M_AXI_HPM0_FPD} {
    if {[llength [get_bd_intf_pins -quiet "zynq_ps/$cand"]] > 0} {
        set ps_master "/zynq_ps/$cand"
        break
    }
}
if {$ps_master eq ""} {
    error "No PS AXI master port found. Enable M_AXI_HPM0_LPD in the PS config."
}
puts "INFO: using PS master $ps_master"

apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
    -config [list Master $ps_master Clk "Auto"] \
    [get_bd_intf_pins crypto_0/s_axi]

#-----------------------------------------------------------------------------
# LEDs out to the pins named in the XDC
#-----------------------------------------------------------------------------
create_bd_port -dir O led_pass
create_bd_port -dir O led_fail
connect_bd_net [get_bd_pins crypto_0/led_pass] [get_bd_ports led_pass]
connect_bd_net [get_bd_pins crypto_0/led_fail] [get_bd_ports led_fail]

# Pushbuttons in: btn[0] = GPIO_SW_W (Ascon), btn[1] = GPIO_SW_E (SHA-256)
create_bd_port -dir I -from 1 -to 0 btn
connect_bd_net [get_bd_ports btn] [get_bd_pins crypto_0/btn]

#-----------------------------------------------------------------------------
# Address map, validate, wrapper
#-----------------------------------------------------------------------------
assign_bd_address
puts "INFO: address map"
puts [report_bd_address -quiet -return_string]

validate_bd_design
save_bd_design

make_wrapper -files [get_files "$PROJ_DIR/$PROJ_NAME.srcs/sources_1/bd/$BD_NAME/$BD_NAME.bd"] -top
add_files -norecurse "$PROJ_DIR/$PROJ_NAME.gen/sources_1/bd/$BD_NAME/hdl/${BD_NAME}_wrapper.v"
set_property top "${BD_NAME}_wrapper" [current_fileset]
update_compile_order -fileset sources_1

#-----------------------------------------------------------------------------
# Build
#-----------------------------------------------------------------------------
launch_runs synth_1 -jobs 8
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    error "Synthesis failed. See the run log for details."
}

launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    error "Implementation failed. See the run log for details."
}

#-----------------------------------------------------------------------------
# Reports and hardware handoff for Vitis
#-----------------------------------------------------------------------------
open_run impl_1
puts "\n================ TIMING ================"
puts [report_timing_summary -quiet -return_string -max_paths 1]
puts "\n============== UTILIZATION ============="
puts [report_utilization -quiet -return_string]

write_hw_platform -fixed -include_bit -force -file "$PROJ_DIR/${PROJ_NAME}.xsa"
puts "\nDONE. Hardware platform written to $PROJ_DIR/${PROJ_NAME}.xsa"
puts "Import that XSA into Vitis to build the test application."
