`timescale 1ns / 1ps

import ascon_pack::*;

module drive_ascon(
    // inputs
    input logic         clock_i,
    input logic         reset_i,
    input logic         start_i,
    input logic         end_initialisation_i,
    input logic         end_associate_i,
    input logic         end_cipher_i,
    input logic         end_tag_i,
    input logic         [4:0] cpt_i,
    input logic         cipher_valid_i,
    // outputs
    output logic         init_o,
    output logic         data_valid_o,
    output logic         associate_data_o,
    output logic         finalisation_o,
    // Gestion compteur
    output logic         reset_counter_o,
    output logic         control_counter_o,
    // gestion selection mux cipher
    output logic [1:0] addr_mux_cipher_o
);

    
      // state list
  typedef enum {
    start,
    idle,
    init,
    phase_init,
    associate,
    phase_associate,
    cipher,
    cipher_valid,
    increment_counter,
    finalisation,
    tag,
    tag1,
    tag2,
    restart
  } State_t;

  // Present and futur states declaration
  State_t Ep, Ef;


assign addr_mux_cipher_o = (Ef == tag1) ? 2'b10 : ( (Ef == tag2) ? 2'b01 : 2'b00 ) ;
    
      // sequential process
  always_ff @(posedge clock_i, negedge reset_i) begin
    if (reset_i == 1'b0) begin
      Ep <= idle;
    end else begin
      Ep <= Ef;
    end
  end
  
  //Normalement ça c'est bon
  always_comb begin
    case (Ep)
        idle: if(start_i == 0) Ef = idle; else Ef = start;
        start: Ef = init;
        init: Ef = phase_init;
        phase_init: if(end_initialisation_i == 0) Ef = phase_init; else Ef = associate;
        associate: Ef = phase_associate;
        phase_associate: if(end_associate_i == 0) Ef = phase_associate; else Ef = cipher;
        cipher: Ef = cipher_valid;
        cipher_valid: if(end_cipher_i==0) Ef = cipher_valid; else Ef = increment_counter;
        increment_counter: if(cpt_i == 5'b10101) Ef = finalisation; else Ef = cipher;
        finalisation: Ef = tag;
        tag: if(end_tag_i==0) Ef = tag; else Ef = tag1;
        tag1: Ef = tag2;
        tag2: Ef = restart;
        restart: if(start_i == 0) Ef = idle; else Ef = restart;
        default: Ef = idle;
    endcase
  end
  
  //ok mais
 always_comb begin
    case (Ep)
      idle: begin
        init_o = 1'b0;
        data_valid_o = 1'b0;
        associate_data_o = 1'b0;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o =1'b0;
      end
      start: begin
        init_o = 1'b0;
        data_valid_o = 1'b0;
        associate_data_o = 1'b1;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o =1'b0;
      end
      init: begin
        init_o = 1'b1;
        data_valid_o = 1'b0;
        associate_data_o = 1'b1;
        finalisation_o = 1'b0;
        reset_counter_o =1'b1;
        control_counter_o =1'b1;
      end
      phase_init: begin
        init_o = 1'b0;
        data_valid_o = 1'b0;
        associate_data_o = 1'b1;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o =1'b0;
      end
      associate: begin
        init_o = 1'b0;
        data_valid_o = 1'b1;
        associate_data_o = 1'b1;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o =1'b0;
      end
      phase_associate: begin
        init_o = 1'b0;
        data_valid_o = 1'b0;
        associate_data_o = 1'b1;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o =1'b0;
      end
      cipher: begin
        init_o = 1'b0;
        data_valid_o = 1'b1;
        associate_data_o = 1'b0;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o = 1'b0;
      end
      cipher_valid: begin
        init_o = 1'b0;
        data_valid_o = 1'b0;
        associate_data_o = 1'b0;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o = 1'b0;
      end
      increment_counter:begin
        init_o = 1'b0;
        data_valid_o = 1'b0;
        associate_data_o = 1'b0;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o = 1'b1;
      end
      finalisation: begin
        init_o = 1'b0;
        data_valid_o = 1'b1;
        associate_data_o = 1'b0;
        finalisation_o = 1'b1;
        reset_counter_o =1'b0;
        control_counter_o = 1'b0;
      end
      tag: begin
        init_o = 1'b0;
        data_valid_o = 1'b0;
        associate_data_o = 1'b0;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o = 1'b0;
      end
      tag1: begin
        init_o = 1'b0;
        data_valid_o = 1'b0;
        associate_data_o = 1'b0;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o = 1'b0;
      end
      tag2: begin
        init_o = 1'b0;
        data_valid_o = 1'b0;
        associate_data_o = 1'b0;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o = 1'b0;
      end
      restart: begin
        init_o = 1'b0;
        data_valid_o = 1'b0;
        associate_data_o = 1'b0;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o = 1'b0;
      end
      default: begin
        init_o = 1'b0;
        data_valid_o = 1'b0;
        associate_data_o = 1'b0;
        finalisation_o = 1'b0;
        reset_counter_o =1'b0;
        control_counter_o = 1'b0;
      end
   endcase
end

endmodule 