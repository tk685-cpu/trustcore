# =============================================================================
# ASYNC_REG marking for the spi_slave input synchronizers
#
# Split out of zcu106_crypto.xdc because Vivado does not allow control flow
# (foreach / if) inside a .xdc file:
#
#   "command foreach is not supported in the xdc constraint file"
#
# A .tcl constraint file is sourced as full Tcl, so the loop is legal here.
#
# This is OPTIONAL for the ZCU106 build. The SPI master and slave share one
# clock in this design, so these chains are not crossing a clock domain and
# ASYNC_REG has no effect on correctness. It is kept because spi_slave.v is the
# ASIC deliverable and is deliberately free of FPGA-specific attributes, so the
# intent has to live outside the RTL.
#
# TO ENABLE:
#   Sources -> Add Sources -> Add or create constraints -> select this file.
#   Then right-click it in the Sources pane -> File Type -> TCL.
#   (Vivado assigns XDC by default, which would fail the same way.)
#
# The loop, rather than seven bare set_property calls, is deliberate: a
# set_property on an empty object list is a hard ERROR ([Common 17-55]) and
# kills the run, so a pattern that stops matching after a rename would break
# the build. This warns instead. The REF_NAME filter keeps the match to actual
# registers, since ASYNC_REG is only legal on register cells.
# =============================================================================

foreach async_pat {
    *u_spi_slave*sclk_s1*
    *u_spi_slave*sclk_s2*
    *u_spi_slave*sclk_s3*
    *u_spi_slave*mosi_s1*
    *u_spi_slave*mosi_s2*
    *u_spi_slave*cs_s1*
    *u_spi_slave*cs_s2*
} {
    set async_cells [get_cells -quiet -hierarchical \
        -filter "REF_NAME =~ FD* && NAME =~ $async_pat"]
    if {[llength $async_cells] > 0} {
        set_property ASYNC_REG TRUE $async_cells
    } else {
        puts "async_reg.tcl: WARNING no registers matched $async_pat"
    }
}
