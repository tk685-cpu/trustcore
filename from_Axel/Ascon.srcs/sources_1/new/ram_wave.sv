`timescale 1ns / 1ps

import ascon_pack::*;

module ram_wave (
    input logic [4:0] cpt_i
);

mux_32 mux_ram_in (
    .addr(cpt_i),
    .in(),
    .out()
);

