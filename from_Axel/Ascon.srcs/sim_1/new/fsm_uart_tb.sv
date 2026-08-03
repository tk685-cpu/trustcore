`timescale 1ns / 1ps

module fsm_uart_tb(
);

// Input
  logic clock;
  logic resetb;

  logic RXErr_i;
  logic RXRdy_i;
  logic [7:0] RxData_i;
  logic TxBusy_i;

  logic [7:0] TxByte_o;
  logic Load_o;

    // -------- Interconnexion --------
    logic Start_ascon_s;
    logic CipherRdy_s;
    logic [7:0] data_Tx_s;

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
    
    logic [63:0] trame_c [0:22]; 
    assign trame_c = { 64'h5A5B5B5A5A5A5A5A, 64'h59554E4A4C4F5455, 64'h5351535456575857, 64'h5A5A595756595B5A, 64'h5554545252504F4F, 64'h4C4C4D4D4A494444, 64'h4747464442434140, 64'h3B36383E44494947, 64'h4746464443424345, 64'h4745444546474A49, 64'h4745484F58697C92, 64'hAECEEDFFFFE3B47C, 64'h471600041729363C, 64'h3F3E40414141403F, 64'h3F403F3E3B3A3B3E, 64'h3D3E3C393C414646, 64'h46454447464A4C4F, 64'h4C505555524F5155, 64'h595C5A595A5C5C5B, 64'h5959575351504F4F, 64'h53575A5C5A5B5D5E, 64'h6060615F605F5E5A, 64'h5857545252800000 };
    logic [127:0] key_s;
    logic [127:0] nonce_s;
    logic [63:0] ad_s;
    assign key_s = 128'h8A55114D1CB6A9A2_BE263D4D7AECAAFF;
    assign nonce_s = 128'h4ED0EC0B98C529B7_C8CDDF37BCD0284A;
    assign ad_s = 64'h4120746F20428000;

    // -------- FSM --------
    fsm_uart fsm_uart_inst (
        .clock_i(clock),
        .resetb_i(resetb),
        .RXErr_i(RXErr_i),
        .RXRdy_i(RXRdy_i),
        .TxBusy_i(TxBusy_i),
        .RxData_i(RxData_i),
        .CipherRdy_i(CipherRdy_s),
        .data_Tx_i(data_Tx_s),

        .TxByte_o(TxByte_o),
        .Start_ascon_o(Start_ascon_s),
        .Load_o(Load_o),

        .ctrl_mux_wave_o(ctrl_mux_wave_s),
        .ctrl_mux_cipher_o(ctrl_mux_cipher_s),

        .ena_reg_wave_o(ena_reg_wave_s),
        .ena_reg_ad_o(ena_reg_ad_s),
        .ena_reg_key_o(ena_reg_key_s),
        .ena_reg_nonce_o(ena_reg_nonce_s),
        .ena_reg_Tx_o(ena_reg_Tx_s),
        .wea_reg_Tx_o(wea_reg_Tx_s),

        .ena_RAM_wave_o(ena_RAM_wave_s),
        .wea_RAM_wave_o(wea_RAM_wave_s),

        .ena_RAM_cipher_o(ena_RAM_cipher_s),
        .wea_RAM_cipher_o(wea_RAM_cipher_s),

        .bloc_counter_o(bloc_counter_s)
    );

    // -------- ASCON TOP --------
    ascon_top ascon_top_inst (
        .clock_i(clock),
        .reset_i(resetb),
        .start_i(Start_ascon_s),

        .ctrl_mux_wave_i(ctrl_mux_wave_s),
        .ctrl_mux_cipher_i(ctrl_mux_cipher_s),

        .uart_TX_i(RxData_i),

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


  // Clock
  always #5 clock = ~clock;

  // -------- UART stimulus --------
  task send_byte(input [7:0] data);
  begin
    @(posedge clock);
    RxData_i = data;
    RXRdy_i  = 1;
    @(posedge clock);
    RXRdy_i  = 0;
    @(posedge clock);
    RXRdy_i  = 0;
    @(posedge clock);
    RXRdy_i  = 0;
  end
  endtask

  initial begin
    // Init
    clock = 0;
    resetb = 0;
    RXErr_i = 0;
    RXRdy_i = 0;
    TxBusy_i = 0;
    RxData_i = 0;

    // Reset
    #20;
    resetb = 1;

    // -------- KEY --------
    
    send_byte(8'h4B); // 'K'
    
    for (int i = 0; i < 16; i++) begin
        send_byte(key_s[127 - i*8 -: 8]);
    end
    
    #100;

    // -------- NONCE --------
    send_byte(8'h4E); // 'N'
    
    for (int i = 0; i < 16; i++) begin
        send_byte(nonce_s[127 - i*8 -: 8]);
    end

    #100;
    
    // -------- AD --------
    send_byte(8'h41); // 'A'
    
    for (int i = 0; i < 8; i++) begin
        send_byte(ad_s[63 - i*8 -: 8]);
    end

    #100;
    
    // -------- WAVE --------
    send_byte(8'h57); // 'W'
    
    for (int j = 0; j < 23; j++) begin
        for (int i = 0; i < 8; i++) begin
            send_byte(trame_c[j][63 - i*8 -: 8]);
        end
        #30;
    end

    #100;
    
    // -------- START ASCON --------
    send_byte(8'h47);

    // Attendre fin de ascon
    #4000;

    // -------- LECTURE CIPHER --------
    send_byte(8'h43);

    #5000;

    send_byte(8'h54);
    
    #1000;
    

  end

endmodule
