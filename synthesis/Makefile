#==============================================================================
# Makefile - Xcelium simulation flow for TrustCore-v1
#
# Targets:
#   make            -> batch simulation, dumps waves.shm via run.tcl
#   make gui        -> launch SimVision GUI
#   make wave       -> open the dumped database in SimVision
#   make clean      -> remove simulation artifacts
#
# Override the top module from the command line if needed:
#   make TOP=tb_sha256
#   make TOP=tb_ascon128
#==============================================================================

#------------------------------------------------------------------------------
# Tools
#------------------------------------------------------------------------------
XRUN      := xrun
SIMVISION := simvision

#------------------------------------------------------------------------------
# Top-level testbench module name (must match the TB module)
# Exported so run.tcl can read it via $env(TOP) and probe the right scope
#------------------------------------------------------------------------------
TOP       := tb_chip_top
export TOP

#------------------------------------------------------------------------------
# Source files
#   PKG : package(s) first so enums/typedefs compile before they are used
#         (none yet for this design -- left empty so the structure stays in
#         place if one gets added later)
#   RTL : design files, ordered leaf -> top
#   TB  : testbench files
#------------------------------------------------------------------------------
PKG :=

RTL := \
	rtl/sha256.v \
	rtl/ascon128.v \
	rtl/crypto_fsm.v \
	rtl/spi_slave.v \
	rtl/spi_top.v \
	rtl/spi_buffer_ctrl.v \
	rtl/chip_top.v

TB := \
	tb/$(TOP).sv

#------------------------------------------------------------------------------
# Compile / elaboration options
#   -access +rwc : full read/write/connectivity visibility for probing
#   -sv          : enable SystemVerilog
#   -timescale   : default timescale if not set in source
#   -input       : Tcl command file (database + probe + run)
#------------------------------------------------------------------------------
WAVE_DB   := waves.shm
TCL       := run.tcl

XRUN_OPTS := \
	-sv \
	-access +rwc \
	-timescale 1ns/1ps \
	-top $(TOP)

#------------------------------------------------------------------------------
# Synthesis tools and config (Yosys + Cadence Genus)
#------------------------------------------------------------------------------
YOSYS := yosys
GENUS := genus

# ETRI 0.5um standard-cell Liberty (edit to your install path)
LIB := \
	   lib/khu_etri05_stdcells.lib

LEF := lib/etri050_stdcells.lef \
	   lib/etri050_stdcells_Via_Rule.lef
export LIB

# Synthesis top = design top, NOT the testbench
SYN_TOP := chip_top
export SYN_TOP

# Reuse the simulation file lists as the single source of truth.
# Joined into space-separated strings the Tcl scripts iterate over.
PKG_FILES := $(PKG)
RTL_FILES := $(RTL)
export PKG_FILES
export RTL_FILES

# Output directories
SYN_DIR     := synthesis
RPT_DIR     := $(SYN_DIR)/reports
NETLIST_DIR := $(SYN_DIR)/netlist
export RPT_DIR
export NETLIST_DIR

YOSYS_TCL :=  $(SYN_DIR)/yosys.tcl
GENUS_TCL :=  $(SYN_DIR)/genus.tcl
SDC       :=  $(SYN_DIR)/constraints.sdc
export SDC

#------------------------------------------------------------------------------
# Default: batch simulation with waveform dump
#------------------------------------------------------------------------------
.PHONY: sim
sim: $(TCL)
	$(XRUN) $(XRUN_OPTS) -input $(TCL) $(PKG) $(RTL) $(TB)

#------------------------------------------------------------------------------
# Interactive GUI run (SimVision opens, drive run from there or via run.tcl)
#------------------------------------------------------------------------------
.PHONY: gui
gui: $(TCL)
	$(XRUN) $(XRUN_OPTS) -gui -input $(TCL) $(PKG) $(RTL) $(TB)

#------------------------------------------------------------------------------
# Open an already-dumped waveform database
#------------------------------------------------------------------------------
.PHONY: wave
wave:
	$(SIMVISION) $(WAVE_DB) &

#------------------------------------------------------------------------------
# Lint / compile-only check (no simulation, catches syntax errors fast)
#------------------------------------------------------------------------------
.PHONY: lint
lint:
	$(XRUN) $(XRUN_OPTS) -compile $(PKG) $(RTL) $(TB)

#------------------------------------------------------------------------------
# Clean simulation artifacts
#------------------------------------------------------------------------------
.PHONY: clean
clean:
	rm -rf xcelium.d xrun.* .simvision $(WAVE_DB) \
	       waves.shm* *.log *.history *.dsn *.trn \
	       INCA_libs *.key
	# synthesis artifacts
	rm -rf $(RPT_DIR) $(NETLIST_DIR) \
	       genus.* fv/ *.cmd *.mmmc .cadence/

#------------------------------------------------------------------------------
# Print resolved file lists (debug helper)
#------------------------------------------------------------------------------
.PHONY: files
files:
	@echo "TOP = $(TOP)"
	@echo "PKG files:" ; for f in $(PKG); do echo "  $$f"; done
	@echo "RTL files:" ; for f in $(RTL); do echo "  $$f"; done
	@echo "TB files:"  ; for f in $(TB);  do echo "  $$f"; done

#------------------------------------------------------------------------------
# Create output directories
#------------------------------------------------------------------------------
.PHONY: dirs
dirs:
	@mkdir -p $(RPT_DIR) $(NETLIST_DIR)

#------------------------------------------------------------------------------
# Yosys logic synthesis -> gate-level netlist + cell/area stat
#------------------------------------------------------------------------------
.PHONY: syn-yosys
syn-yosys: dirs $(YOSYS_TCL)
	$(YOSYS) -c $(YOSYS_TCL) -l $(RPT_DIR)/yosys.log

#------------------------------------------------------------------------------
# Cadence Genus logic synthesis -> netlist + timing/area/power reports
#------------------------------------------------------------------------------
.PHONY: syn-genus
syn-genus: dirs $(GENUS_TCL) $(SDC)
	$(GENUS) -batch -log $(RPT_DIR)/genus -files $(GENUS_TCL)

#------------------------------------------------------------------------------
# Run both synthesis flows
#------------------------------------------------------------------------------
.PHONY: syn
syn: syn-yosys syn-genus