`timescale 1ns / 1ps

import ascon_pack::*;

module ascon_top_tb();

    // =========================
    // Signaux TB
    // =========================
    logic clock_s;
    logic reset_s;
    logic start_s;

    logic ctrl_mux_wave_s;
    logic ctrl_mux_cipher_s;
    logic [7:0] uart_TX_s;

    logic init_a_s;
    logic init_b_s;
    logic ena_compteur_double_s;

    logic enable_bloc_counter_s;
    logic init_bloc_counter_s;

    logic ena_RAM_wave_s;
    logic wea_RAM_wave_s;
    
    logic ena_RAM_cipher_s;
    logic wea_RAM_cipher_s;
    // outputs
    logic [63:0] data_cipher_s;
    logic [4:0] compteur_double_s;
    logic [4:0] bloc_counter_s;

    // Constant declaration 
    logic [63:0] trame_c [0:22]; 
    assign trame_c = { 64'h5A5B5B5A5A5A5A5A, 64'h59554E4A4C4F5455, 64'h5351535456575857, 64'h5A5A595756595B5A, 64'h5554545252504F4F, 64'h4C4C4D4D4A494444, 64'h4747464442434140, 64'h3B36383E44494947, 64'h4746464443424345, 64'h4745444546474A49, 64'h4745484F58697C92, 64'hAECEEDFFFFE3B47C, 64'h471600041729363C, 64'h3F3E40414141403F, 64'h3F403F3E3B3A3B3E, 64'h3D3E3C393C414646, 64'h46454447464A4C4F, 64'h4C505555524F5155, 64'h595C5A595A5C5C5B, 64'h5959575351504F4F, 64'h53575A5C5A5B5D5E, 64'h6060615F605F5E5A, 64'h5857545252800000 };
    logic [319:0] ciphertext_tb;
    logic [127:0] key_s;
    logic [127:0] nonce_s;
    logic [63:0] ad_s;
    assign key_s = 128'h8A55114D1CB6A9A2_BE263D4D7AECAAFF;
    assign nonce_s = 128'h4ED0EC0B98C529B7_C8CDDF37BCD0284A;
    assign ad_s = 64'h4120746F20428000;
    
    logic ena_reg_wave_s = 1'b1;
    logic ena_reg_ad_s = 1'b1;
    logic ena_reg_key_s = 1'b1;
    logic ena_reg_nonce_s = 1'b1;
 
    
    
    // =========================
    // Clock generation
    // =========================
    parameter HALF_PERIOD = 5;

    initial begin
        clock_s = 0;
        forever #HALF_PERIOD clock_s = ~clock_s;
    end


    // =========================
    // DUT
    // =========================
    ascon_top DUT (
        .clock_i(clock_s),
        .reset_i(reset_s),
        .start_i(start_s),
        .ctrl_mux_wave_i(ctrl_mux_wave_s),
        .ctrl_mux_cipher_i(ctrl_mux_cipher_s),
        .uart_TX_i(uart_TX_s),

        .init_a_i(init_a_s),
        .init_b_i(init_b_s),
        .ena_compteur_double_i(ena_compteur_double_s),

        .enable_bloc_counter_i(enable_bloc_counter_s),
        .init_bloc_counter_i(init_bloc_counter_s),
        
        .ena_reg_wave_i(ena_reg_wave_s),
        .ena_reg_ad_i(ena_reg_ad_s),
        .ena_reg_key_i(ena_reg_key_s),
        .ena_reg_nonce_i(ena_reg_nonce_s),
        
        .ena_RAM_cipher_i(ena_RAM_cipher_s),
        .wea_RAM_cipher_i(wea_RAM_cipher_s),
        .ena_RAM_wave_i(ena_RAM_wave_s),
        .wea_RAM_wave_i(wea_RAM_wave_s),

        .data_cipher_o(data_cipher_s),

        .compteur_double_o(compteur_double_s),
        .bloc_counter_o(bloc_counter_s)
    );


    // =========================
    // Stimulus
    // =========================
    initial begin

        // Init
        reset_s = 1'b0;
        start_s = 1'b0;
        ctrl_mux_wave_s = 1'b0;
        ctrl_mux_cipher_s = 1'b0;
        uart_TX_s = 4'b0;

        init_a_s = 1'b0;
        init_b_s = 1'b0;
        ena_compteur_double_s = 1'b0;

        enable_bloc_counter_s = 1'b0;
        init_bloc_counter_s = 1'b0;

        ena_RAM_wave_s = 1'b0;
        wea_RAM_wave_s = 1'b0;
        
        ena_RAM_cipher_s = 1'b0;
        wea_RAM_cipher_s = 1'b0;

        // Reset
        #20
        reset_s = 1'b0;

        #40
        reset_s = 1'b1;
        
        init_bloc_counter_s = 1'b1;
        enable_bloc_counter_s = 1'b1;
        
        ena_RAM_wave_s = 1'b1;
        ena_RAM_cipher_s = 1'b1;
        ena_reg_wave_s = 1'b0;
        ena_reg_ad_s = 1'b0;   
        ena_reg_key_s = 1'b0;  
        ena_reg_nonce_s = 1'b0;
        
        #10;
        enable_bloc_counter_s = 1'b0;
        init_bloc_counter_s = 1'b0;
        
        // On donne les valeurs au regshift wave
        ctrl_mux_wave_s = 1'b1;
        ena_reg_wave_s = 1'b1;
        for(int j = 0; j <= 22; j++) begin
            for (int i = 7; i >= 0; i--) begin
                #10;
                uart_TX_s = trame_c[j][8*i +: 8];
            end
            #10;
            wea_RAM_wave_s = 1'b1;
            #10;
            wea_RAM_wave_s = 1'b0;
            enable_bloc_counter_s = 1'b1;
            #10;
            enable_bloc_counter_s = 1'b0;
        end
        ena_reg_wave_s = 1'b0;
        ctrl_mux_wave_s = 1'b0;
        
        // On donne les valeurs au regshift key
        ena_reg_key_s = 1'b1;  
        for (int i = 15; i >= 0; i--) begin
            uart_TX_s = key_s[8*i +: 8];
            #10;
        end
        ena_reg_key_s = 1'b0;  
            
        // On donne les valeurs au regshift nonce
        ena_reg_nonce_s = 1'b1;
        for (int i = 15; i >= 0; i--) begin
            uart_TX_s = nonce_s[8*i +: 8];
            #10;
        end
        ena_reg_nonce_s = 1'b0;
        
        // On donne les valeurs au regshift data associee
        ena_reg_ad_s = 1'b1;
        for (int i = 7; i >= 0 ; i--) begin
            uart_TX_s = ad_s[8*i +: 8];
            #10;
        end
        ena_reg_ad_s = 1'b0;
        
        // Start ASCON
        #50
        start_s = 1;
        wea_RAM_cipher_s = 1'b1;

        #10
        start_s = 0;

        // Laisser tourner
        #2000

        $finish;

    end


    // =========================
    // Monitoring
    // =========================
    initial begin
        $display("Simulation start");
        $monitor("t=%0t | start=%0b | cipher=%h | cpt=%d",
                  $time,
                  start_s,
                  data_cipher_s,
                  compteur_double_s);
    end

endmodule