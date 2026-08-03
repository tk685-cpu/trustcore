`timescale 1ns / 1ps

import ascon_pack::*;

module ascon_top (
    input logic clock_i,
    input logic reset_i,
    input logic start_i,
    input logic ctrl_mux_wave_i, // choisit addr de RAM_wave entre cpt_s et bloc_counter
    input logic ctrl_mux_cipher_i, // Choisit addr de RAM_cipher entre cpt_s et bloc_couter (instruction lire cipher)
    input logic [7:0] uart_TX_i,
    // --- input compteur ---
    input logic [4:0] bloc_counter_i,
    // --- Signaux ena Regshift ---
    // Regshift 64 Wave
    input logic ena_reg_wave_i,
    // Regshift 64 Associated data
    input logic ena_reg_ad_i,
    // Regshift 128 Key
    input logic ena_reg_key_i,
    // Regshift 128 Nonce
    input logic ena_reg_nonce_i,
    // Regshift_Tx 64
    input logic ena_reg_Tx_i,
    input logic wea_reg_Tx_i,
    
    // --- Input ena/wea RAM_Wave ---
    input logic ena_RAM_wave_i,
    input logic wea_RAM_wave_i,
    
    // --- RAM cipher out ---
    input logic ena_RAM_cipher_i,
    input logic wea_RAM_cipher_i,
    
    output logic [7:0] data_Tx_o,
    output logic end_tag_o 
);


    logic [127:0] regshift_nonce_s;
    logic [127:0] regshift_key_s;
    logic [63:0]  regshift_ad_s;
    logic [63:0]  regshift_wave_s;



// --- Signal to link Ascon and Drive_ascon ---
logic init_s;
logic [63:0] data_s;
logic associate_data_s;
logic finalisation_s;
logic data_valid_s;

logic         end_associate_s;
logic [ 63:0] cipher_s;
logic         cipher_valid_s;
logic [127:0] tag_s;
logic         end_initialisation_s;
logic         end_cipher_s;

// --- Signal for Drive_ascon ---
logic [4:0] cpt_s;
logic reset_counter_s;
logic control_counter_s;

// --- RAM Wave ---
logic [4:0] addr_RAM_wave_s;
logic [63:0] data_RAM_wave_s;

// --- Regshift_Tx ---
logic [63:0] data_cipher_s;

// --- Cipher RAM ---
logic [63:0] mux_cipher_s;
logic [4:0] addr_RAM_cipher_write_s;
logic [4:0] addr_RAM_cipher_read_s;
logic [4:0] addr_RAM_cipher_s;
logic [1:0] addr_mux_cipher_s;


always_comb begin
    case (addr_mux_cipher_s)
        2'b00: addr_RAM_cipher_write_s = cpt_s;
        2'b01: addr_RAM_cipher_write_s = 23;
        2'b10: addr_RAM_cipher_write_s = 24;
        default: addr_RAM_cipher_write_s = cpt_s;
    endcase
end
assign addr_RAM_cipher_s = (ctrl_mux_cipher_i == 1'b0) ? addr_RAM_cipher_write_s : addr_RAM_cipher_read_s;
assign mux_cipher_s = (addr_mux_cipher_s == 2'b00) ? cipher_s : ( (addr_mux_cipher_s == 2'b01) ? tag_s[63:0] : tag_s[127:64] );
assign data_s = (associate_data_s == 1'b1)? regshift_ad_s :  data_RAM_wave_s;
assign addr_RAM_wave_s = (ctrl_mux_wave_i == 1'b1) ? bloc_counter_i : cpt_s;
assign addr_RAM_cipher_read_s = bloc_counter_i;  


ascon ascon_module
(
	.clock_i(clock_i),
	.reset_i(~reset_i),
	.init_i(init_s),
	.associate_data_i(associate_data_s),
	.finalisation_i(finalisation_s),
	.data_i(data_s),
	.data_valid_i(data_valid_s),
	.key_i(regshift_key_s),
	.nonce_i(regshift_nonce_s),
	.end_associate_o(end_associate_s),
	.cipher_o(cipher_s),
	.cipher_valid_o(cipher_valid_s),
	.tag_o(tag_s),
	.end_tag_o(end_tag_o),
	.end_initialisation_o(end_initialisation_s),
	.end_cipher_o(end_cipher_s)
);

drive_ascon drive_ascon_module (
    .clock_i(clock_i),
    .reset_i(reset_i),
    .start_i(start_i),
    .end_initialisation_i(end_initialisation_s),
    .end_associate_i(end_associate_s),
    .end_cipher_i(end_cipher_s),
    .end_tag_i(end_tag_o),
    .cpt_i(cpt_s),
    .cipher_valid_i(cipher_valid_s),
    .init_o(init_s),
    .data_valid_o(data_valid_s),
    .associate_data_o(associate_data_s),
    .finalisation_o(finalisation_s),
    .reset_counter_o(reset_counter_s),
    .control_counter_o(control_counter_s),       
    .addr_mux_cipher_o(addr_mux_cipher_s)  
);

bloc_counter cipher_counter
(
	.clock_i(clock_i),
	.resetb_i(reset_i),
	.init_i(reset_counter_s),
	.en_i(control_counter_s),
	.data_o(cpt_s)
);

blk_mem_gen_0 ram_wave_module
(
    .addra(addr_RAM_wave_s),
    .clka(clock_i),
    .dina(regshift_wave_s),
    .douta(data_RAM_wave_s),
    .ena(ena_RAM_wave_i),
    .wea(wea_RAM_wave_i)
);

reg_shift64 reg_shift_wave_module(
    .clock_i(clock_i),
    .reset_i(reset_i),
    .data_i(uart_TX_i),
    .ena_i(ena_reg_wave_i),
    .data_o(regshift_wave_s)
);

reg_shift64 reg_shift_ad_module(
    .clock_i(clock_i),
    .reset_i(reset_i),
    .data_i(uart_TX_i),
    .ena_i(ena_reg_ad_i),
    .data_o(regshift_ad_s)
);

reg_shift128 reg_shift_key_module(
    .clock_i(clock_i),
    .reset_i(reset_i),
    .data_i(uart_TX_i),
    .ena_i(ena_reg_key_i),
    .data_o(regshift_key_s)
);

reg_shift128 reg_shift_nonce_module(
    .clock_i(clock_i),
    .reset_i(reset_i),
    .data_i(uart_TX_i),
    .ena_i(ena_reg_nonce_i),
    .data_o(regshift_nonce_s)
);


blk_mem_gen_1 ram_cipher_module(
    .addra(addr_RAM_cipher_s),
    .clka(clock_i),
    .dina(mux_cipher_s),
    .douta(data_cipher_s),
    .ena(ena_RAM_cipher_i),
    .wea(wea_RAM_cipher_i)
);

regshift_Tx RAM_out(
    .clock_i(clock_i),
    .reset_i(reset_i),
    .data_i(data_cipher_s),
    .ena_i(ena_reg_Tx_i),
    .wea_i(wea_reg_Tx_i),
    .data_o(data_Tx_o)
);


endmodule	