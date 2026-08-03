`timescale 1ns / 1ps

module fsm_uart
  import uart_pkg::*;
(
    input  logic          clock_i,
    input  logic          resetb_i,
    input  logic          RXErr_i,
    input  logic          RXRdy_i,
    input  logic          TxBusy_i,
    input  logic [   7:0] RxData_i,       //byte received by uart
    input  logic          CipherRdy_i,    //end ascon computation (= end_tag_i)
    input logic  [   7:0] data_Tx_i,
    output logic [   7:0] uart_Tx_o,
    output logic [   7:0] TxByte_o,       //byte to send by uart (UART_Tx)
    output logic          Start_ascon_o,  // = start_i
    output logic          Load_o,         //load signal for byte transmission
    
    output logic ctrl_mux_wave_o, 
    output logic ctrl_mux_cipher_o,
    // --- Signaux ena Regshift ---
    output logic ena_reg_wave_o,
    output logic ena_reg_ad_o,
    output logic ena_reg_key_o,
    output logic ena_reg_nonce_o,
    output logic ena_reg_Tx_o, 
    output logic wea_reg_Tx_o, 
    
    
    // --- RAM Wave out ---
    output logic ena_RAM_wave_o,
    output logic wea_RAM_wave_o,
    
    // --- RAM cipher out ---
    output logic ena_RAM_cipher_o,
    output logic wea_RAM_cipher_o,
    
    // output compteur
    output logic [4:0] bloc_counter_o
);

  //internal signals for trans_receive
  logic [7:0] data_converted_s;
  logic en_trans_s;
  
  assign uart_Tx_o = data_converted_s;

  // internal signals for fsm counter
  logic init_cpt_s;
  logic ena_cpt_s;
  logic [3:0] cpt_s;
  
  // internal signals for bloc_counter
  logic ena_bloc_counter_s;
  logic init_bloc_counter_s;
  logic [4:0] bloc_counter_s;
  
      
  typedef enum {
    init,
    idle_cmd,
    get_cmd,
    init_key,  //key
    idle_key0,
    idle_key1,
    get_key0,
    get_key1,
    flush_key,
    init_nonce,  //nonce
    idle_nonce0,
    idle_nonce1,
    get_nonce0,
    get_nonce1,
    flush_nonce,
    //add states to parse associate data 
    init_ad,
    idle_ad0,
    idle_ad1,
    get_ad0,
    get_ad1,
    flush_ad,
    //add states to parse ecg wave
    init_wave,
    idle_wave0,
    idle_wave1,
    get_wave0,
    get_wave1,
    flush_wave,
    //start ascon cipher GO 
    start_ascon,
    wait_end_ascon,
    //send the cipher result all the cipher wave
    init_cipher,
    idle_cipher,
    wait1_cipher,
    wait2_cipher,
    start_cipher,
    next_cipher,
    send_cipher,
    
    //send the tag
    init_tag,
    idle_tag,
    wait1_tag,
    wait2_tag,
    start_tag,
    next_tag,
    send_tag,
    
    starto,  //letter O
    sendo,
    startk,  //letter K
    sendk,
    startlf,  //Line Field
    sendlf
  } state_t;

  state_t etat_p;
  state_t etat_f;

  assign bloc_counter_o = (
    etat_p == init_tag ||
    etat_p == idle_tag ||
    etat_p == wait1_tag ||
    etat_p == wait2_tag ||
    etat_p == start_tag ||
    etat_p == next_tag ||
    etat_p == send_tag) ? 
        23 + bloc_counter_s : 
        bloc_counter_s;


fsm_counter fsm_counter0(
    .clock_i(clock_i),
    .resetb_i(resetb_i),
    .en_i(ena_cpt_s),
    .init_i(init_cpt_s),
    .data_o(cpt_s)
);

bloc_counter bloc_counter_module(
    .clock_i(clock_i),
    .resetb_i(resetb_i),
    .en_i(ena_bloc_counter_s),
    .init_i(init_bloc_counter_s),
    .data_o(bloc_counter_s)
);

  trans_receive trans_receive_0 (
      .clock_i(clock_i),
      .resetb_i(resetb_i),
      .RxData_i(RxData_i),
      .en_i(en_trans_s),
      .data_converted_o(data_converted_s)
  );

  always_ff @(posedge clock_i, negedge resetb_i) begin : seq_0
    if (resetb_i == 1'b0) begin
      etat_p <= init;
    end else begin
      etat_p <= etat_f;
    end
  end : seq_0

  always_comb begin : comb_0
    case (etat_p)
      init: etat_f = idle_cmd;
      idle_cmd:
      if (RXRdy_i == 1'b1) begin
        etat_f = get_cmd;
      end else begin
        etat_f = idle_cmd;
      end
      get_cmd:
      if (TxBusy_i == 1'b0) begin
        case (RxData_i)
          8'h4B:   etat_f = init_key;  //K
          8'h6B:   etat_f = init_key;  //k
          8'h57:   etat_f = init_wave;  //W
          8'h77:   etat_f = init_wave;  //w
          8'h41:   etat_f = init_ad;  //A
          8'h61:   etat_f = init_ad;  //a
          8'h4E:   etat_f = init_nonce;  //N
          8'h6E:   etat_f = init_nonce;  //n
          8'h47:   etat_f = start_ascon;  //G
          8'h67:   etat_f = start_ascon;  //g
          8'h43:   etat_f = init_cipher; //C
          8'h63:   etat_f = init_cipher; //c
          8'h54:   etat_f = init_tag; //T
          8'h74:   etat_f = init_tag; //t
          default: etat_f = idle_cmd;
        endcase
      end else begin
        etat_f = idle_cmd;
      end
      // Write key
      init_key: etat_f = idle_key0;
      idle_key0:
      if (RXRdy_i == 1'b1) begin
        etat_f = idle_key1;
      end else begin
        etat_f = idle_key0;
      end
      idle_key1: etat_f = get_key0;
      get_key0: etat_f = get_key1;
      get_key1:
      if (TxBusy_i == 1'b0) begin
        if (cpt_s == 4'b1111) begin
          etat_f = flush_key;
        end else begin
          etat_f = idle_key0;
        end
      end else begin
        etat_f = idle_cmd;
      end
      flush_key: etat_f = starto;
      // Write nonce
      init_nonce: etat_f = idle_nonce0;
      idle_nonce0:
      if (RXRdy_i == 1'b1) begin
        etat_f = idle_nonce1;
      end else begin
        etat_f = idle_nonce0;
      end
      idle_nonce1: etat_f = get_nonce0;
      get_nonce0: etat_f = get_nonce1;
      get_nonce1:
      if (TxBusy_i == 1'b0) begin
        if (cpt_s == 4'b1111) begin
          etat_f = flush_nonce;
        end else begin
          etat_f = idle_nonce0;
        end
      end else begin
        etat_f = idle_cmd;
      end
      flush_nonce: etat_f = starto;
      // Write ad
      init_ad: etat_f = idle_ad0;
      idle_ad0:
      if (RXRdy_i == 1'b1) begin
        etat_f = idle_ad1;
      end else begin
        etat_f = idle_ad0;
      end
      idle_ad1: etat_f = get_ad0;
      get_ad0: etat_f = get_ad1;
      get_ad1:
      if (TxBusy_i == 1'b0) begin
        if (cpt_s == 4'b0111) begin
          etat_f = flush_ad;
        end else begin
          etat_f = idle_ad0;
        end
      end else begin
        etat_f = idle_cmd;
      end
      flush_ad: etat_f = starto;
      // Write wave
      init_wave: etat_f = idle_wave0;
      idle_wave0:
      if (RXRdy_i == 1'b1) begin
        etat_f = idle_wave1;
      end else begin
        etat_f = idle_wave0;
      end
      idle_wave1: etat_f = get_wave0;
      get_wave0: etat_f = get_wave1;
      get_wave1:
      if (TxBusy_i == 1'b0) begin
        if (cpt_s == 4'b0111) begin
          etat_f = flush_wave;
        end else begin
          etat_f = idle_wave0;
        end
      end else begin
        etat_f = idle_cmd;
      end
      flush_wave: 
      if (bloc_counter_s == 5'h16) begin
        etat_f = starto;
      end else begin
        etat_f = idle_wave0;
      end
      //init Ascon
      start_ascon: etat_f = wait_end_ascon;
      wait_end_ascon:
      if (CipherRdy_i == 1'b1) begin
        etat_f = starto;
      end else begin
        etat_f = wait_end_ascon;
      end
      //read cipher
      init_cipher: etat_f = idle_cipher;
      idle_cipher: etat_f = wait1_cipher;
      wait1_cipher: etat_f = wait2_cipher;
      wait2_cipher: etat_f = start_cipher;
      start_cipher: etat_f = next_cipher;
      next_cipher: if(cpt_s == 4'b0111) etat_f = send_cipher; else etat_f = start_cipher;
      send_cipher: if(bloc_counter_s == 5'b10110) etat_f = starto; else etat_f = idle_cipher;     
      
      //read tag
      init_tag: etat_f = idle_tag;
      idle_tag: etat_f = wait1_tag;
      wait1_tag: etat_f = wait2_tag;
      wait2_tag: etat_f = start_tag;
      start_tag: etat_f = next_tag;
      next_tag: if(cpt_s == 4'b0111) etat_f = send_tag; else etat_f = start_tag;
      send_tag: if(bloc_counter_s == 5'b00001) etat_f = starto; else etat_f = idle_tag;
      //Respond to commands
      starto: etat_f = sendo;
      sendo:
      if (TxBusy_i == 1'b0) begin
        etat_f = startk;
      end else begin
        etat_f = sendo;
      end
      startk: etat_f = sendk;
      sendk:
      if (TxBusy_i == 1'b0) begin
        etat_f = startlf;
      end else begin
        etat_f = sendk;
      end
      startlf: etat_f = sendlf;
      sendlf:
      if (TxBusy_i == 1'b0) begin
        etat_f = idle_cmd;
      end else begin
        etat_f = sendlf;
      end
      default: etat_f = init;
    endcase
  end : comb_0

  always_comb begin : comb_1
    case (etat_p)
      init: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      idle_cmd: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      get_cmd: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      //write key
      init_key: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b1;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      idle_key0: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      idle_key1: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b1;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      get_key0: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b1;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      get_key1: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      flush_key: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      init_nonce: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b1;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      idle_nonce0: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      idle_nonce1: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b1;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      get_nonce0: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b1;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      get_nonce1: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      flush_nonce: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      //write DA
      init_ad: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b1;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      idle_ad0: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      idle_ad1: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b1;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      get_ad0: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b1;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      get_ad1: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      flush_ad: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      //write wave
      init_wave: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b1;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b1;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b1; 
        init_bloc_counter_s = 1'b1;
      end
      idle_wave0: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b1;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      idle_wave1: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b1;
        ctrl_mux_wave_o = 1'b1;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      get_wave0: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b1;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b1;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      get_wave1: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b1;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0; 
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      flush_wave: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b1;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b1;
        wea_RAM_wave_o = 1'b1;
        ena_RAM_cipher_o = 1'b0;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b1;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b1; 
        init_bloc_counter_s = 1'b0;
	end
      //go
      start_ascon: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b1;  //
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b1;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b1;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      wait_end_ascon: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b1;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b1;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      //send cipher
      init_cipher: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b1;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b1; 
        init_bloc_counter_s = 1'b1;
      end
      idle_cipher: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      wait1_cipher: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      wait2_cipher: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b1;
        wea_reg_Tx_o = 1'b1;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      start_cipher: begin
        TxByte_o      = data_Tx_i;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b1;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      next_cipher: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b1;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      send_cipher: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b1;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b1;
        init_bloc_counter_s = 1'b0;
      end
      //send tag
      init_tag: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b1;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b1; 
        init_bloc_counter_s = 1'b1;
      end
      idle_tag: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      wait1_tag: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      wait2_tag: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b1;
        wea_reg_Tx_o = 1'b1;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      start_tag: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      next_tag: begin
        TxByte_o      = data_Tx_i;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b1;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b1;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      send_tag: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b1;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b1;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b1;
        ena_cpt_s = 1'b1;
        ena_bloc_counter_s = 1'b1;
        init_bloc_counter_s = 1'b0;
      end
      //respond to commands
      starto: begin
        TxByte_o      = 8'h4F;  //
        Start_ascon_o = 1'b0;
        Load_o        = 1'b1;  //
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      sendo: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      startk: begin
        TxByte_o      = 8'h4B;  //
        Start_ascon_o = 1'b0;
        Load_o        = 1'b1;  //
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      sendk: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      startlf: begin
        TxByte_o      = 8'h0A;  //
        Start_ascon_o = 1'b0;
        Load_o        = 1'b1;  //
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      sendlf: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
      default: begin
        TxByte_o      = '0;
        Start_ascon_o = 1'b0;
        Load_o        = 1'b0;
        en_trans_s    = 1'b0;
        ctrl_mux_wave_o = 1'b0;
        ctrl_mux_cipher_o = 1'b0;
        ena_reg_wave_o = 1'b0;
        ena_reg_ad_o = 1'b0;
        ena_reg_key_o = 1'b0;
        ena_reg_nonce_o = 1'b0;
        ena_reg_Tx_o = 1'b0;
        wea_reg_Tx_o = 1'b0;
        ena_RAM_wave_o = 1'b0;
        wea_RAM_wave_o = 1'b0;
        ena_RAM_cipher_o = 1'b0;
        wea_RAM_cipher_o = 1'b0;
        init_cpt_s = 1'b0;
        ena_cpt_s = 1'b0;
        ena_bloc_counter_s = 1'b0; 
        init_bloc_counter_s = 1'b0;
      end
    endcase
  end : comb_1
endmodule