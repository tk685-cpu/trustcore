`timescale 1ns / 1ps

module reg64 (
    input  logic         clock_i,
    input  logic         resetb_i,   // reset actif bas
    input  logic [63:0] data_i,
    input  logic         en_i,
    input  logic         init_i,
    output logic [63:0] data_o
);

always_ff @(posedge clock_i or negedge resetb_i) begin
    if (!resetb_i) begin
        data_o <= 63'b0;
    end
    else if (init_i) begin
        data_o <= 63'b0;
    end
    else if (en_i) begin
        data_o <= data_i;
    end
end

endmodule