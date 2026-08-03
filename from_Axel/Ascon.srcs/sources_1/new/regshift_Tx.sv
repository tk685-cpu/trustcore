`timescale 1ns / 1ps

import ascon_pack::*;

module regshift_Tx(
    input logic clock_i,
    input logic reset_i,
    input logic [63:0] data_i,
    input logic ena_i,
    input logic wea_i,
    output logic [7:0] data_o
);

logic [63:0] reg_s;

always_ff @(posedge clock_i, negedge reset_i) begin
  if (reset_i == 1'b0) begin
      reg_s <= 63'b0;
  end else begin
    if (wea_i == 1'b1) begin
        if (ena_i == 1'b1) begin
            reg_s <= data_i;
        end
    end
    else begin 
        if (ena_i == 1'b1) begin
            reg_s <= {reg_s[55:0], 8'b0};
        end
        else begin
            reg_s <= reg_s;
        end
    end
  end
end

assign data_o = reg_s[63:56];

endmodule