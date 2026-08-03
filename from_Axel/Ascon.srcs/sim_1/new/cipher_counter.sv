`timescale 1 ns / 1 ps

module cipher_counter
  import ascon_pack::*;
(
    input  logic         clock_i,
    input  logic         resetb_i,
    input  logic         init_i,
    input  logic         control_i, 
    output logic [4 : 0] data_o
);

  logic [4:0] cpt_s;

  always_ff @(posedge clock_i or negedge resetb_i) begin
    if (resetb_i == 1'b1) begin
      cpt_s <= 0;
    end
    else begin
      if (control_i == 1'b1) begin
        if (init_i == 1'b1)
            cpt_s <= 0;
        else
            cpt_s <= cpt_s + 1;
      end
      else
        cpt_s <= cpt_s;
    end
  end

  assign data_o = cpt_s;

endmodule : cipher_counter