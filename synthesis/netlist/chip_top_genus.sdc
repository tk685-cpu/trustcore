# ####################################################################

#  Created by Genus(TM) Synthesis Solution 23.14-s090_1 on Wed Jul 22 14:35:40 KST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design chip_top

create_clock -name "clk" -period 5.0 -waveform {0.0 2.5} [get_ports clk]
create_clock -name "sclk" -period 200.0 -waveform {0.0 100.0} [get_ports sclk]
set_load -pin_load 0.05 [get_ports miso]
set_false_path -from [get_ports rst_n]
set_clock_groups -name "clock_groups_clk_to_sclk" -asynchronous -group [get_clocks clk] -group [get_clocks sclk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks sclk] -add_delay -max 1.75 [get_ports mosi]
set_input_delay -clock [get_clocks sclk] -add_delay -max 1.75 [get_ports cs_n]
set_input_delay -clock [get_clocks sclk] -add_delay -min 0.25 [get_ports mosi]
set_input_delay -clock [get_clocks sclk] -add_delay -min 0.25 [get_ports cs_n]
set_output_delay -clock [get_clocks sclk] -add_delay -max 1.25 [get_ports miso]
set_output_delay -clock [get_clocks sclk] -add_delay -min -0.25 [get_ports miso]
set_wire_load_mode "enclosed"
