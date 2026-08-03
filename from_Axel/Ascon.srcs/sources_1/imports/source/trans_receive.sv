`timescale 1ns / 1ps
//Description: register with enable
module trans_receive
  import uart_pkg::*;
(
    input  logic       clock_i,          //main clock
    input  logic       resetb_i,         //asynchronous reset active low
    input  logic [7:0] RxData_i,
    input  logic       en_i,
    output logic [7:0] data_converted_o
);
  logic [7:0] data_converted_s;

  always_ff @(posedge clock_i or negedge resetb_i) begin : seq_0
    if (resetb_i == 1'b0) data_converted_s <= '0;
    else begin
      if (en_i == 1'b1) begin
//        case (RxData_i)
//          8'h30:   data_converted_s <= 4'h0;
//          8'h31:   data_converted_s <= 4'h1;
//          8'h32:   data_converted_s <= 4'h2;
//          8'h33:   data_converted_s <= 4'h3;
//          8'h34:   data_converted_s <= 4'h4;
//          8'h35:   data_converted_s <= 4'h5;
//          8'h36:   data_converted_s <= 4'h6;
//          8'h37:   data_converted_s <= 4'h7;
//          8'h38:   data_converted_s <= 4'h8;
//          8'h39:   data_converted_s <= 4'h9;
//          8'h41:   data_converted_s <= 4'hA;
//          8'h61:   data_converted_s <= 4'hA;
//          8'h42:   data_converted_s <= 4'hB;
//          8'h62:   data_converted_s <= 4'hB;
//          8'h43:   data_converted_s <= 4'hC;
//          8'h63:   data_converted_s <= 4'hC;
//          8'h44:   data_converted_s <= 4'hD;
//          8'h64:   data_converted_s <= 4'hD;
//          8'h45:   data_converted_s <= 4'hE;
//          8'h65:   data_converted_s <= 4'hE;
//          8'h46:   data_converted_s <= 4'hF;
//          8'h66:   data_converted_s <= 4'hF;
//          default: data_converted_s <= data_converted_s;
//        endcase
        data_converted_s <= RxData_i;
      end else begin
        data_converted_s <= data_converted_s;
      end
    end
  end : seq_0
  assign data_converted_o = data_converted_s;

endmodule : trans_receive
