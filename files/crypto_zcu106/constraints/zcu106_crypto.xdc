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
# That leaves only the two LED outputs.
#
# -----------------------------------------------------------------------------
# IMPORTANT: VERIFY THE LED PINS AGAINST YOUR BOARD REVISION
#
# The package pins below are for the ZCU106 user GPIO LEDs. There are multiple
# ZCU106 board revisions and the master XDC is the authoritative source. Before
# building, open the ZCU106 master XDC for your revision (available from the
# AMD/Xilinx board file download) and confirm the GPIO_LED_0 / GPIO_LED_1 pin
# assignments and their I/O standard.
#
# If the pins are wrong the design still builds; the LEDs simply do not light,
# which is a confusing failure to debug. Checking takes one minute.
#
# The ZCU106 user LEDs are single colour, not RGB, so "red vs green" is not
# available on the board itself. The default mapping below uses two separate
# LEDs plus distinct blink rates. To get actual colours, wire a bi-colour LED
# to a user PMOD header and move these constraints to those pins.
# =============================================================================

# -----------------------------------------------------------------------------
# User LEDs
# -----------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN AL11 IOSTANDARD LVCMOS12} [get_ports led_pass]
set_property -dict {PACKAGE_PIN AL13 IOSTANDARD LVCMOS12} [get_ports led_fail]

# The LEDs are human-visible indicators driven from a slow counter. They have
# no meaningful timing relationship to anything, so exclude them from timing
# analysis rather than letting unconstrained-output warnings clutter the report.
set_false_path -to [get_ports led_pass]
set_false_path -to [get_ports led_fail]

# -----------------------------------------------------------------------------
# Reset synchronizer
#
# crypto_axi_top contains a two-flop async-assert / sync-release reset
# synchronizer. The first flop can go metastable when the PS reset releases, so
# mark it as such: this tells the tool to expect it and stops it reporting a
# false setup violation on the asynchronous reset path.
# -----------------------------------------------------------------------------
set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {NAME =~ *rst_meta*}]
set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {NAME =~ *rst_sync_n*}]

# -----------------------------------------------------------------------------
# SPI input synchronizers inside the chip
#
# spi_slave synchronizes sclk, mosi and cs_n with two-flop chains because on
# the real ASIC those arrive from an external master. In this FPGA build they
# happen to be driven from the same clock domain, so the chains are not
# strictly required here, but they are part of the ASIC design and are kept
# unmodified. Marking them ASYNC_REG is harmless and keeps the intent visible.
# -----------------------------------------------------------------------------
set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {NAME =~ *u_spi_slave*sclk_s1*}]
set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {NAME =~ *u_spi_slave*sclk_s2*}]
set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {NAME =~ *u_spi_slave*mosi_s1*}]
set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {NAME =~ *u_spi_slave*mosi_s2*}]
set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {NAME =~ *u_spi_slave*cs_s1*}]
set_property ASYNC_REG TRUE [get_cells -hierarchical -filter {NAME =~ *u_spi_slave*cs_s2*}]

# -----------------------------------------------------------------------------
# Bitstream settings
# -----------------------------------------------------------------------------
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
