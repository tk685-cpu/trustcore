# =============================================================================
# zcu106_crypto.xdc
# Constraints for the crypto chip validation design on the ZCU106
# (Zynq UltraScale+ MPSoC, XCZU7EV-FFVC1156)
#
# -----------------------------------------------------------------------------
# WHAT IS AND IS NOT CONSTRAINED HERE
#
# The PL clock comes from the PS through pl_clk0, and the block design already
# creates that clock object. Do NOT add a create_clock for it here or you will
# end up with two clock objects on the same net and misleading timing reports.
#
# There are no external SPI pins to constrain. The SPI master and the SPI slave
# are both inside the PL and share pl_clk0, so the entire path is an ordinary
# register-to-register path that static timing analysis already covers. That is
# a deliberate benefit of putting the master in the PL rather than routing the
# chip's SPI pins off-board.
#
# That leaves the two LED outputs and the two pushbutton inputs.
#
# -----------------------------------------------------------------------------
# PIN ASSIGNMENTS
#
# Package pins and I/O standards below were taken from the ZCU106 Rev1.0 master
# XDC (dated 02/10/2018). If you are on a different board revision, re-check
# against that revision's master file.
#
# The ZCU106 user LEDs are single colour, not RGB, so "red vs green" is not
# available on the board itself. The mapping below uses two separate LEDs plus
# distinct blink rates. To get actual colours, wire a bi-colour LED to a user
# PMOD header and move these constraints to those pins.
#
# -----------------------------------------------------------------------------
# PORT NAMES MUST MATCH THE TOP LEVEL
#
# The strings inside get_ports match the port names on whatever module is set
# as top. If the block design wrapper is top (the normal case here), they must
# match the names of the EXTERNAL PORTS in IP Integrator, NOT the port names
# inside crypto_axi_top.v.
#
# WATCH OUT: right-clicking a pin and choosing "Make External" usually appends
# an instance suffix, so led_pass becomes led_pass_0 and btn becomes btn_0.
# The build then fails with "No objects matched 'get_ports led_pass'". Fix it
# in the block design, not here: click the external port, and in the External
# Port Properties panel set Name back to led_pass / led_fail / btn. Keeping the
# BD port names equal to the RTL port names avoids a whole class of confusion.
#
# Check them with this in the Tcl console after opening the synthesized design:
#     get_ports *
# The list must contain exactly led_pass, led_fail, btn[0] and btn[1].
#
# The pushbuttons are ONE 2-bit port, not two scalars:
#     btn[0] = GPIO_SW_W -> Ascon-128
#     btn[1] = GPIO_SW_E -> SHA-256
# The braces around {btn[0]} are required: without them Tcl treats the brackets
# as command substitution and the constraint fails.
# =============================================================================

# -----------------------------------------------------------------------------
# User LEDs
#
# GPIO_LED_0_LS / GPIO_LED_1_LS, bank 66, VCCO = VCC1V2 so LVCMOS12.
# Note for later expansion: LEDs 0, 1, 2, 4, 5, 6, 7 are all in bank 66, but
# GPIO_LED_3_LS is AE15 in bank 64. If you ever use LED 3, confirm bank 64's
# VCCO on your board before assuming LVCMOS12 is still correct there.
# -----------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN AL11 IOSTANDARD LVCMOS12} [get_ports led_pass]
set_property -dict {PACKAGE_PIN AL13 IOSTANDARD LVCMOS12} [get_ports led_fail]

# The LEDs are human-visible indicators driven from a slow counter. They have
# no meaningful timing relationship to anything, so exclude them from timing
# analysis rather than letting unconstrained-output warnings clutter the report.
set_false_path -to [get_ports led_pass]
set_false_path -to [get_ports led_fail]

# -----------------------------------------------------------------------------
# User pushbuttons
#
# Part of the 5-way switch (SW14-SW18). Both are in bank 66 at 1.2V.
#
# Do NOT use SW3 or SW4: those are PS_SRST_B and PS_POR_B and will reset the
# whole MPSoC. The remaining 5-way positions, if needed later, are
# GPIO_SW_N = AG13 and GPIO_SW_C = AL10 (bank 66), GPIO_SW_S = AP20 (bank 65).
# Bank 65 is a different bank, so re-check its VCCO before reusing LVCMOS12
# for GPIO_SW_S.
# -----------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN AK12 IOSTANDARD LVCMOS12} [get_ports {btn[0]}] ;# GPIO_SW_W -> Ascon
set_property -dict {PACKAGE_PIN AC14 IOSTANDARD LVCMOS12} [get_ports {btn[1]}] ;# GPIO_SW_E -> SHA-256

# Mechanical contacts, debounced in RTL over 10 ms. There is no launching clock
# and no real input timing relationship to constrain.
set_false_path -from [get_ports {btn[0]}]
set_false_path -from [get_ports {btn[1]}]

# -----------------------------------------------------------------------------
# Synchronizer registers
#
# Three groups are marked here:
#
#   NOT here any more: the reset synchronizer in crypto_axi_top and the button
#   synchronizer in button_ctrl. Those two are genuinely asynchronous crossings
#   and now carry (* ASYNC_REG = "TRUE" *) on their declarations in the RTL.
#   That is strictly better: an XDC get_cells with a REF_NAME filter resolves
#   reliably at implementation but may not match during SYNTHESIS, when the
#   netlist has not settled into FD* primitives yet, so the synthesis-side
#   effect (blocking optimisation and replication) could be silently lost. The
#   RTL attribute applies at elaboration and covers both, and survives renames.
#
#   What remains here: the SPI input synchronizers in spi_slave. On the real ASIC sclk, mosi
#      and cs_n arrive from an external master. In this FPGA build they happen
#      to be driven from the same clock domain, so the chains are not strictly
#      required, but they are part of the ASIC design and are kept unmodified.
#      Marking them is harmless and keeps the intent visible.
#      sclk_s3 is the edge-detect stage rather than part of the metastability
#      chain, but marking it keeps all three flops placed together.
#
#   These stay in the XDC on purpose: spi_slave.v is the ASIC deliverable and
#   is kept free of FPGA-specific attributes. They are also the low-risk case,
#   because in this build the SPI master and slave share one clock, so those
#   chains are not actually crossing a domain at all.
#
# The loop is deliberate. A bare set_property on an empty object list is a hard
# ERROR in Vivado ([Common 17-55]) and kills the run, so a pattern that stops
# matching after a signal rename would break the build. This warns instead. The
# REF_NAME filter keeps the match to actual registers, since ASYNC_REG is only
# legal on register cells.
#
# If spi_slave.v ever stops being an ASIC deliverable, move these to RTL
# attributes as well and delete this whole block.
# -----------------------------------------------------------------------------
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
        puts "zcu106_crypto.xdc: WARNING no registers matched $async_pat"
    }
}

# -----------------------------------------------------------------------------
# Bitstream settings
# -----------------------------------------------------------------------------
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
