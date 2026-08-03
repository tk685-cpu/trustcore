module mux_32 (
    input  logic [4:0] addr,
    input  logic [63:0][31:0] in,
    output logic [63:0] out
);

assign out = in[addr];

endmodule