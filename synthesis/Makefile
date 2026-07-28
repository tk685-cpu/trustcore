#==============================================================================
# Makefile - Cadence Genus synthesis flow for TrustCore-v1
# Lives in synthesis/, alongside constraints.sdc and genus.tcl.
#==============================================================================
GENUS := genus

SYN_TOP := chip_top
export SYN_TOP

PKG :=

RTL := \
	../rtl/sha256.v \
	../rtl/ascon128.v \
	../rtl/crypto_fsm.v \
	../rtl/spi_slave.v \
	../rtl/spi_top.v \
	../rtl/spi_buffer_ctrl.v \
	../rtl/chip_top.v

PKG_FILES := $(PKG)
RTL_FILES := $(RTL)
export PKG_FILES
export RTL_FILES

LIB := ../lib/khu_etri05_stdcells.lib
export LIB

SDC := constraints.sdc
export SDC

GENUS_TCL := genus.tcl

RPT_DIR     := reports
NETLIST_DIR := netlist
export RPT_DIR
export NETLIST_DIR

.PHONY: syn
syn: dirs $(GENUS_TCL) $(SDC)
	$(GENUS) -batch -log $(RPT_DIR)/genus -files $(GENUS_TCL)

.DEFAULT_GOAL := syn

.PHONY: dirs
dirs:
	@mkdir -p $(RPT_DIR) $(NETLIST_DIR)

.PHONY: files
files:
	@echo "SYN_TOP = $(SYN_TOP)"
	@echo "LIB     = $(LIB)"
	@echo "SDC     = $(SDC)"
	@echo "PKG files:" ; for f in $(PKG); do echo "  $$f"; done
	@echo "RTL files:" ; for f in $(RTL); do echo "  $$f"; done

.PHONY: clean
clean:
	rm -rf $(RPT_DIR) $(NETLIST_DIR) genus.* fv/ *.cmd *.mmmc .cadence/