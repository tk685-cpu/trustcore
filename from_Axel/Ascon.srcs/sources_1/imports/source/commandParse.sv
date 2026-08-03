`timescale 1ns / 1ps

module commandParse
  import uart_pkg::*;
(
    input logic clock_i,
    input logic resetb_i,
    input logic RXErr_i,
    input logic RXRdy_i,
    input logic Fifo_full_i,
    input logic [7:0] RxData_i,  //byte received by uart
    output logic [7:0] TxByte_o,  //byte to send by uart
    output logic [7:0] Memory_o,
    output logic Load_o,  //load signal for byte transmission
    output logic Go_o
);


  // internal signals for register saving memory address
  logic en_addr_s; 
  logic init_addr_s;
  logic [7:0] addr_s;   // input wire [7 : 0] dina

  // internal signals for register saving memory data 
  logic en_data_s; 
  logic init_data_s;
  logic [7:0] data_s;   // input wire [7 : 0] dina

  // internal signals for memory
  logic [0:0] mem_write_s; // input wire [0:0] wea
  logic [7:0] mem_dout_s;  // output wire [7 : 0] douta
  assign mem_dout_s = Memory_o;

  // internal signals for fsm_dcounter
  // OP: signal width must be equal to the maximum read byte * 2 in commands (here 2)
  logic [1:0] cpt_s;
  logic en_cpt_s;
  logic init_cpt_s;
  logic [1:0] load_cpt_s;

  // internal signals for trans_receive
  logic [3:0] data_converted_s;
  logic enable_convert_s;

  typedef enum {
    init,
    
    // wait for command
    idle_cmd,
    get_cmd,
    
    // command is A<> which implies writing data in memory
    write_addr,
    idle_wa0, idle_wa1, 
    get_wa0, get_wa1, 
    flush_wa,

    // command is W<> which implies writing data in memory
    write_data,
    idle_wd0, idle_wd1, 
    get_wd0, get_wd1, 
    flush_wd,
    
    // command is R<> which implies reading data from memory
    read_data,
    idle_rd0, idle_rd1, 
    get_rd0, get_rd1, 
    flush_rd, wait_load_rd,
    
    // make correct answer according to commands
    starto, sendo, startk, sendk, startlf, sendlf, startrd, sendrd,
    
    // command is G so GO GO GO
    start, end_start

  } state_t;

  state_t etat_p;
  state_t etat_f;

  serialLoad_regN #(.WIDTH(8)) addr_reg_0 (
      .clock_i(clock_i),
      .resetb_i(resetb_i),
      .data_i(data_converted_s),
      .en_i(en_addr_s),
      .init_i(init_addr_s),
      .value_o(addr_s)
  );

  serialLoad_regN #(.WIDTH(8)) data_reg_0 (
      .clock_i(clock_i),
      .resetb_i(resetb_i),
      .data_i(data_converted_s),
      .en_i(en_data_s),
      .init_i(init_data_s),
      .value_o(data_s)
  );

  fsm_dcounter #(.WIDTH(2)) fsm_dcounter_0 (
      .clock_i(clock_i),
      .resetb_i(resetb_i),
      .en_i(en_cpt_s),
      .init_i(init_cpt_s),
      .load_i(load_cpt_s),
      .cpt_o(cpt_s)
  );

  trans_receive trans_receive_0 (
      .clock_i(clock_i),
      .resetb_i(resetb_i),
      .RxData_i(RxData_i),
      .en_i(enable_convert_s),
      .data_converted_o(data_converted_s)
  );

  // TODO : RAM memory to save data
  blk_RAM BRAMO (
  .clka(clock_i),    // input wire clka
  .wea(mem_write_s),      // input wire [0 : 0] wea
  .addra(addr_s),  // input wire [4 : 0] addra
  .dina(data_s),    // input wire [7 : 0] dina
  .douta(Memory_o)  // output wire [7 : 0] douta
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
      init: 
        etat_f = idle_cmd;
      idle_cmd:
        if (RXRdy_i == 1'b1) begin
            etat_f = get_cmd;
      end else begin
        etat_f = idle_cmd;
      end
      get_cmd:
      if (Fifo_full_i == 1'b0) begin
        case (RxData_i)
          8'h41:   etat_f = write_addr;  //A
          8'h61:   etat_f = write_addr;  //a
          8'h57:   etat_f = write_data;  //W
          8'h77:   etat_f = write_data;  //w
          8'h47:   etat_f = start;  //G
          8'h67:   etat_f = start;  //g
          8'h52:   etat_f = read_data;  //R
          8'h72:   etat_f = read_data;  //r
          default: etat_f = idle_cmd;
        endcase
      end else begin
        etat_f = idle_cmd;
      end
      // Write memory address
      write_addr: 
            etat_f = idle_wa0;
      idle_wa0:
            if (RXRdy_i == 1'b1) begin
                etat_f = idle_wa1;
            end else begin
                etat_f = idle_wa0;
            end
      idle_wa1: 
            etat_f = get_wa0;
      get_wa0: 
            etat_f = get_wa1;
      get_wa1:
            if (Fifo_full_i == 1'b0) begin
                if (cpt_s == 9'h1) begin
                    etat_f = flush_wa;
                end else begin
                    etat_f = idle_wa0;
                end
            end else begin
                etat_f = idle_cmd;
            end            
      flush_wa: etat_f = starto;

      // write memory data
      write_data: 
            etat_f = idle_wd0;
      idle_wd0:
            if (RXRdy_i == 1'b1) begin
                etat_f = idle_wd1;
            end else begin
                etat_f = idle_wd0;
            end
      idle_wd1: 
            etat_f = get_wd0;
      get_wd0: 
            etat_f = get_wd1;
      get_wd1:
            if (Fifo_full_i == 1'b0) begin
                if (cpt_s == 9'h1) begin
                  etat_f = flush_wd;
                end else begin
                  etat_f = idle_wd0;
                end
            end else begin
                etat_f = idle_cmd;
            end
      flush_wd: etat_f = starto;
      
      // read memory data
      read_data: 
            etat_f = idle_rd0;
      idle_rd0:
            if (RXRdy_i == 1'b1) begin
                etat_f = idle_rd1;
            end else begin
                etat_f = idle_rd0;
            end
      idle_rd1: 
            etat_f = get_rd0;
      get_rd0: 
            etat_f = get_rd1;
      get_rd1:
            if (Fifo_full_i == 1'b0) begin
                if (cpt_s == 9'h1) begin
                  etat_f = flush_rd;
                end else begin
                  etat_f = idle_rd0;
                end
            end else begin
                etat_f = idle_cmd;
            end
      flush_rd: etat_f = wait_load_rd;
      wait_load_rd: etat_f = startrd;
       
            
      // Start system...
      start: etat_f = end_start;
      end_start: etat_f = starto;
      
      // Respond to commands
      starto: etat_f = sendo;
      sendo:
      if (Fifo_full_i == 1'b0) begin
        etat_f = startk;
      end else begin
        etat_f = sendo;
      end
      startk: etat_f = sendk;
      sendk:
      if (Fifo_full_i == 1'b0) begin
        etat_f = startlf;
      end else begin
        etat_f = sendk;
      end
      startlf: etat_f = sendlf;
      sendlf:
      if (Fifo_full_i == 1'b0) begin
        etat_f = idle_cmd;
      end else begin
        etat_f = sendlf;
      end
      startrd: etat_f = sendrd;
      sendrd:
      if (Fifo_full_i == 1'b0) begin
        etat_f = startlf;
      end else begin
        etat_f = sendrd;
      end
      default: etat_f = init;
    endcase
  end : comb_0

  always_comb begin : comb_1
    case (etat_p)
      init: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      idle_cmd: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      get_cmd: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end      
      
      //write data in memory
      write_addr: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b1;
        init_cpt_s = 1'b1;
        load_cpt_s = 2'b10;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b1;
        en_addr_s = 1'b1;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      idle_wa0: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b1;  //
      end
      idle_wa1: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      get_wa0: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
 
        init_addr_s = 1'b0;
        en_addr_s = 1'b1;       
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      get_wa1: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b1;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
     flush_wa: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      
      write_data: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b1;
        init_cpt_s = 1'b1;
        load_cpt_s = 2'b10;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b1;
        en_data_s = 1'b1;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      idle_wd0: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b1;  //
      end
      idle_wd1: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      get_wd0: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
 
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;       
        init_data_s = 1'b0;
        en_data_s = 1'b1;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      get_wd1: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b1;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      flush_wd: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b1;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      
      //read data memory
      read_data: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b1;
        init_cpt_s = 1'b1;
        load_cpt_s = 2'b10;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b1;
        en_addr_s = 1'b1;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      idle_rd0: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b1;  //
      end
      idle_rd1: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      get_rd0: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
 
        init_addr_s = 1'b0;
        en_addr_s = 1'b1;       
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      get_rd1: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b1;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
     flush_rd: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      wait_load_rd: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      
      // start system...
      start: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;
        
        Go_o = 1'b1;

        enable_convert_s = 1'b0;
      end
      end_start: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
 
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;
        
        Go_o = 1'b0;
        
        enable_convert_s = 1'b0;
      end
      
      //respond to commands
      
      //send read data
      
      //rd
      startrd: begin    
        TxByte_o = mem_dout_s;
        Load_o = 1'b1;  //

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;
        
        Go_o = 1'b0;
        
        enable_convert_s = 1'b0;
      end
      sendrd: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      
      //send OK
      starto: begin
        TxByte_o = 8'h4F;  // O
        Load_o = 1'b1;  //

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;
        
        Go_o = 1'b0;
        
        enable_convert_s = 1'b0;
      end
      sendo: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      startk: begin
        TxByte_o = 8'h4B;  // K
        Load_o = 1'b1;  //

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      sendk: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      startlf: begin
        TxByte_o = 8'h0A;  // lf
        Load_o = 1'b1;  //

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      sendlf: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
      default: begin
        TxByte_o = '0;
        Load_o = 1'b0;

        en_cpt_s = 1'b0;
        init_cpt_s = 1'b0;
        load_cpt_s = '0;
        
        mem_write_s = 1'b0;
        
        init_addr_s = 1'b0;
        en_addr_s = 1'b0;
        init_data_s = 1'b0;
        en_data_s = 1'b0;

        Go_o = 1'b0;

        enable_convert_s = 1'b0;
      end
    endcase
  end : comb_1
ila_0 ila_RAM_i0 (
	.clk(clock_i), // input wire clk
	.probe0(mem_write_s), // input wire [0:0]  probe0  
	.probe1(mem_dout_s) // input wire [7:0]  probe1
);
endmodule : commandParse

