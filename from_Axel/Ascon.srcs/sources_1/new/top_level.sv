`timescale 1ns / 1ps

module top_level(
// Input
  input logic clock_i,
  input logic reset_i,

  input logic Rx_i,

// Output
  output logic Tx_o
);


    // -------- Interconnexion --------
    logic Start_ascon_s;
    logic CipherRdy_s;
    logic [7:0] data_Tx_s;
    logic [2:0] Baud_i;

    logic ctrl_mux_wave_s;
    logic ctrl_mux_cipher_s;

    logic ena_reg_wave_s;
    logic ena_reg_ad_s;
    logic ena_reg_key_s;
    logic ena_reg_nonce_s;
    logic ena_reg_Tx_s;
    logic wea_reg_Tx_s;

    logic ena_RAM_wave_s;
    logic wea_RAM_wave_s;

    logic ena_RAM_cipher_s;
    logic wea_RAM_cipher_s;

    logic [4:0] bloc_counter_s;
    logic [7:0] uart_Tx_s;
    
    
    assign Baud_i = 3'b000;

    // -------- FSM --------
    uart_top uart_top0 (
        .clock_i(clock_i),                 
        .reset_i(~reset_i),                 

        .Rx_i(Rx_i),                    
        .Baud_i(Baud_i),   
        .Tx_o(Tx_o),                   

        .data_Tx_i(data_Tx_s),
        .end_tag_i(CipherRdy_s),

        .start_o(Start_ascon_s),                
        .ctrl_mux_wave_o(ctrl_mux_wave_s), 
        .ctrl_mux_cipher_o(ctrl_mux_cipher_s), 
        .uart_Tx_o(uart_Tx_s),        
        .bloc_counter_o(bloc_counter_s),     
        .ena_reg_wave_o(ena_reg_wave_s), 
        .ena_reg_ad_o(ena_reg_ad_s), 
        .ena_reg_key_o(ena_reg_key_s),
        .ena_reg_nonce_o(ena_reg_nonce_s), 
        .ena_reg_Tx_o(ena_reg_Tx_s),     
        .wea_reg_Tx_o(wea_reg_Tx_s),

        .ena_RAM_wave_o(ena_RAM_wave_s),         
        .wea_RAM_wave_o(wea_RAM_wave_s),

        .ena_RAM_cipher_o(ena_RAM_cipher_s),       
        .wea_RAM_cipher_o(wea_RAM_cipher_s)
    );
    
    
    // -------- ASCON TOP --------
    ascon_top ascon_top0 (
        .clock_i(clock_i),
        .reset_i(~reset_i),
        .start_i(Start_ascon_s),

        .ctrl_mux_wave_i(ctrl_mux_wave_s),
        .ctrl_mux_cipher_i(ctrl_mux_cipher_s),

        .uart_TX_i(uart_Tx_s),

        .bloc_counter_i(bloc_counter_s),

        .ena_reg_wave_i(ena_reg_wave_s),
        .ena_reg_ad_i(ena_reg_ad_s),
        .ena_reg_key_i(ena_reg_key_s),
        .ena_reg_nonce_i(ena_reg_nonce_s),
        .ena_reg_Tx_i(ena_reg_Tx_s),
        .wea_reg_Tx_i(wea_reg_Tx_s),

        .ena_RAM_wave_i(ena_RAM_wave_s),
        .wea_RAM_wave_i(wea_RAM_wave_s),

        .ena_RAM_cipher_i(ena_RAM_cipher_s),
        .wea_RAM_cipher_i(wea_RAM_cipher_s),

        .data_Tx_o(data_Tx_s),
        .end_tag_o(CipherRdy_s)
    );
    
    

endmodule
