#resetb_i
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports reset_i]

## Clock signal 50 MHz
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clock_i]
create_clock -period 20.000 -name sys_clk_pin -waveform {0.000 10.000} -add [get_ports clock_i]

#UART PMODA pin jap1-> RTS jan1-> Tx_o jap2-> Rx_o
#set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports RTS_o]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports Tx_o]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports Rx_i]





create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clock_i_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {data_Tx_s[0]} {data_Tx_s[1]} {data_Tx_s[2]} {data_Tx_s[3]} {data_Tx_s[4]} {data_Tx_s[5]} {data_Tx_s[6]} {data_Tx_s[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 5 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {bloc_counter_s[0]} {bloc_counter_s[1]} {bloc_counter_s[2]} {bloc_counter_s[3]} {bloc_counter_s[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list Rx_i_IBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clock_i_IBUF_BUFG]
