`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2025 05:31:25 PM
// Design Name: 
// Module Name: commandRespond
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module commandRespond(
    input logic clock_i,
    input logic resetb_i,
    
    input logic fifo_empty_i,
    output logic fifo_pop_o,
    
    input logic TxBusy_i,
    output logic Load_o
);

  typedef enum {
    idle,
    start,
    send,
    next
  } state_t;

  state_t etat_p;
  state_t etat_f;
    
  // fsm state to read FIFO if any and transmit data to TX UART module
  always_ff @(posedge clock_i, negedge resetb_i) begin : seq_0
    if (resetb_i == 1'b0) begin
      etat_p <= idle;
    end else begin
      etat_p <= etat_f;
    end
  end : seq_0

  always_comb begin : comb_0
    case (etat_p)
    idle: if (fifo_empty_i == 1'b0) begin
            etat_f = start;
          end else begin
            etat_f = idle;
          end
    start:if (TxBusy_i == 1'b0) begin
            etat_f = send;
           end else begin
            etat_f = start;
          end
   send: etat_f = next;
   next: if (fifo_empty_i == 1'b0) begin
            etat_f = start;
          end else begin
            etat_f = idle;
          end
    default: etat_f = idle;
    endcase
  end : comb_0

  always_comb begin : comb_1
    case (etat_p)
        idle: begin
                fifo_pop_o = 1'b0;
                Load_o = 1'b0;
            end
        start:begin
                fifo_pop_o = 1'b0;
                Load_o = 1'b0;
            end
        send: begin
                fifo_pop_o = 1'b0;
                Load_o = 1'b1;
            end
        next: begin
                fifo_pop_o = 1'b1;
                Load_o = 1'b0;
            end
        default: begin
                fifo_pop_o = 1'b0;
                Load_o = 1'b0;
            end
    endcase
  end : comb_1
    
endmodule
