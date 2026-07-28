#!/bin/bash
export SYN_TOP=chip_top
export LIB=../lib/khu_etri05_stdcells.lib
export RPT_DIR=reports
export NETLIST_DIR=netlist

for FREQ_MHZ in 150 175 200; do
    export FREQ_MHZ
    echo "Running synthesis at ${FREQ_MHZ} MHz..."
    genus -batch -files genus.tcl
done
