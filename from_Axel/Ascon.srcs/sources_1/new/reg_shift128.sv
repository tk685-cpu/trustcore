`timescale 1ns / 1ps

module reg_shift128(
    input logic clock_i,
    input logic reset_i,
    input logic [7:0] data_i,
    input logic ena_i,
    output logic [127:0] data_o
);

logic [127:0] reg_s;

always_ff @(posedge clock_i, negedge reset_i) begin
  if (reset_i == 1'b0) begin
      reg_s <= 128'b0;
  end else begin
    if (ena_i == 1'b1) begin
        reg_s <= {reg_s[119:0], data_i};
    end
    else begin
        reg_s <= reg_s;
    end
  end
end

assign data_o = reg_s;

endmodule