`timescale 1ns / 1ps

module uart_top
  import uart_pkg::*;
(
    input logic clock_i,
    input logic reset_i,
    
    // ---------- PC ------------
    input logic Rx_i,
    input  logic [2:0] Baud_i,    //baud selection
    output logic Tx_o,
    
    
    // ---------- Ascon ----------
    input logic [7:0] data_Tx_i,
    input logic end_tag_i,

    output logic start_o,
    output logic ctrl_mux_wave_o, // choisit addr de RAM_wave entre cpt_s et bloc_counter
    output logic ctrl_mux_cipher_o, // Choisit addr de RAM_cipher entre cpt_s et bloc_couter (instruction lire cipher)
    output logic [7:0] uart_Tx_o,
    // --- input compteur ---
    output logic [4:0] bloc_counter_o,
    // --- Signaux ena Regshift ---
    // Regshift 64 Wave
    output logic ena_reg_wave_o,
    // Regshift 64 Associated data
    output logic ena_reg_ad_o,
    // Regshift 128 Key
    output logic ena_reg_key_o,
    // Regshift 128 Nonce
    output logic ena_reg_nonce_o,
    // Regshift_Tx 64
    output logic ena_reg_Tx_o,
    output logic wea_reg_Tx_o,
    
    // --- Input ena/wea RAM_Wave ---
    output logic ena_RAM_wave_o,
    output logic wea_RAM_wave_o,
    
    // --- RAM cipher out ---
    output logic ena_RAM_cipher_o,
    output logic wea_RAM_cipher_o
);

logic Load_s;
logic RXErr_s;
logic RXRdy_s;
logic [7:0] Din_s;
logic [7:0] Dout_s;

fsm_uart fsm_uart_0
(
    .clock_i(clock_i),      
    .resetb_i(reset_i),     
    .RXErr_i(RXErr_s),      
    .RXRdy_i(RXRdy_s),      
    .TxBusy_i(TxBusy_s),     
    .RxData_i(Dout_s),     
    .CipherRdy_i(end_tag_i),  
    .TxByte_o(Din_s),
    .uart_Tx_o(uart_Tx_o),  
    .Start_ascon_o(start_o),
    .Load_o(Load_s),
    .ctrl_mux_wave_o(ctrl_mux_wave_o),    
    .ctrl_mux_cipher_o(ctrl_mux_cipher_o),  
    .ena_reg_wave_o(ena_reg_wave_o),     
    .ena_reg_ad_o(ena_reg_ad_o),
    .ena_reg_key_o(ena_reg_key_o),      
    .ena_reg_nonce_o(ena_reg_nonce_o),    
    .ena_reg_Tx_o(ena_reg_Tx_o),       
    .wea_reg_Tx_o(wea_reg_Tx_o),       
    .data_Tx_i(data_Tx_i),             
    .ena_RAM_wave_o(ena_RAM_wave_o),     
    .wea_RAM_wave_o(wea_RAM_wave_o),     
    .ena_RAM_cipher_o(ena_RAM_cipher_o),   
    .wea_RAM_cipher_o(wea_RAM_cipher_o),                  
    .bloc_counter_o(bloc_counter_o)
);

uart_core uart_core_0(
    .clock_i(clock_i),
    .resetb_i(reset_i),
    .Din_i(Din_s),  
    .LD_i(Load_s),   
    .Rx_i(Rx_i),   
    .Baud_i(Baud_i), 
    .RXRdy_o(RXRdy_s),
    .RXErr_o(RXErr_s),
    .Dout_o(Dout_s), 
    .Tx_o(Tx_o),   
    .TxBusy_o(TxBusy_s)
);

ila_0 your_instance_name (
	.clk(clock_i), // input wire clk


	.probe0(clock_i), // input wire [0:0]  probe0  
	.probe1(Rx_i), // input wire [0:0]  probe1 
	.probe2(bloc_counter_o), // input wire [0:0]  probe2 
	.probe3(ena_reg_key_o), // input wire [0:0]  probe3 
	.probe4(reset_i), // input wire [0:0]  probe4 
	.probe5(ena_reg_nonce_o) // input wire [0:0]  probe5
);

endmodule