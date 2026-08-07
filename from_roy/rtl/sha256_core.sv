// sha256_core.sv
//
// Streaming SHA-256 core. Accepts one 512-bit block at a time
// (no internal message buffering beyond the current block/schedule),
// matching the no-malloc / buffer-free design principle used
// throughout TrustCore-v1.
//
// Usage:
//   1. Pulse `init` for one cycle to load the standard SHA-256 IV
//      and reset internal round counters.
//   2. Present a 512-bit block on `block_in` and pulse `block_valid`
//      for one cycle.
//   3. The core takes SHA256_ROUNDS (64) + a few pipeline cycles to
//      process the block. `busy` is high throughout.
//   4. When `block_done` pulses, `state_out` holds the running digest
//      after this block. Repeat steps 2-4 for each subsequent block.
//   5. After the FINAL block (already padded per SHA-256 rules by the
//      caller/FSM), `state_out` on the final `block_done` pulse is the
//      completed 256-bit digest.

module sha256_core (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        init,          // pulse: load IV, reset state
    input  logic         block_valid,   // pulse: block_in is valid, start processing
    input  logic [511:0] block_in,      // one 512-bit message block

    output logic         busy,          // high while processing a block
    output logic         block_done,    // pulses for one cycle when digest updates
    output logic [255:0] state_out      // running / final digest, big-endian words
);

    // ---- SHA-256 constants (K[0..63]) ----
    localparam int NUM_ROUNDS = 64;

    function automatic logic [31:0] K_ROM(input int idx);
        logic [31:0] k [0:63];
        k[0]='h428a2f98; k[1]='h71374491; k[2]='hb5c0fbcf; k[3]='he9b5dba5;
        k[4]='h3956c25b; k[5]='h59f111f1; k[6]='h923f82a4; k[7]='hab1c5ed5;
        k[8]='hd807aa98; k[9]='h12835b01; k[10]='h243185be; k[11]='h550c7dc3;
        k[12]='h72be5d74; k[13]='h80deb1fe; k[14]='h9bdc06a7; k[15]='hc19bf174;
        k[16]='he49b69c1; k[17]='hefbe4786; k[18]='h0fc19dc6; k[19]='h240ca1cc;
        k[20]='h2de92c6f; k[21]='h4a7484aa; k[22]='h5cb0a9dc; k[23]='h76f988da;
        k[24]='h983e5152; k[25]='ha831c66d; k[26]='hb00327c8; k[27]='hbf597fc7;
        k[28]='hc6e00bf3; k[29]='hd5a79147; k[30]='h06ca6351; k[31]='h14292967;
        k[32]='h27b70a85; k[33]='h2e1b2138; k[34]='h4d2c6dfc; k[35]='h53380d13;
        k[36]='h650a7354; k[37]='h766a0abb; k[38]='h81c2c92e; k[39]='h92722c85;
        k[40]='ha2bfe8a1; k[41]='ha81a664b; k[42]='hc24b8b70; k[43]='hc76c51a3;
        k[44]='hd192e819; k[45]='hd6990624; k[46]='hf40e3585; k[47]='h106aa070;
        k[48]='h19a4c116; k[49]='h1e376c08; k[50]='h2748774c; k[51]='h34b0bcb5;
        k[52]='h391c0cb3; k[53]='h4ed8aa4a; k[54]='h5b9cca4f; k[55]='h682e6ff3;
        k[56]='h748f82ee; k[57]='h78a5636f; k[58]='h84c87814; k[59]='h8cc70208;
        k[60]='h90befffa; k[61]='ha4506ceb; k[62]='hbef9a3f7; k[63]='hc67178f2;
        return k[idx];
    endfunction

    localparam logic [31:0] H0_INIT [0:7] = '{
        32'h6a09e667, 32'hbb67ae85, 32'h3c6ef372, 32'ha54ff53a,
        32'h510e527f, 32'h9b05688c, 32'h1f83d9ab, 32'h5be0cd19
    };

    // ---- Internal state ----
    logic [31:0] H [0:7];          // running digest (persists across blocks)
    logic [31:0] W [0:63];         // message schedule for current block
    logic [31:0] a, b, c, d, e, f, g, h;

    logic [6:0]  round;            // 0..63 round counter
    typedef enum logic [1:0] {S_IDLE, S_SCHEDULE, S_COMPRESS, S_FINALIZE} state_t;
    state_t st_q, st_d;

    // ---- Rotate helper ----
    function automatic logic [31:0] rotr(input logic [31:0] x, input int n);
        return (x >> n) | (x << (32 - n));
    endfunction

    // ---- FSM: sequencing ----
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) st_q <= S_IDLE;
        else        st_q <= st_d;
    end

    always_comb begin
        st_d = st_q;
        unique case (st_q)
            S_IDLE:      st_d = block_valid ? S_SCHEDULE : S_IDLE;
            S_SCHEDULE:  st_d = S_COMPRESS;          // schedule expansion: 1 cycle (combinational unroll below)
            S_COMPRESS:  st_d = (round == NUM_ROUNDS-1) ? S_FINALIZE : S_COMPRESS;
            S_FINALIZE:  st_d = S_IDLE;
            default:     st_d = S_IDLE;
        endcase
    end

    assign busy = (st_q != S_IDLE);

    // ---- Message schedule expansion (combinational unroll, registered on entry) ----
    always_ff @(posedge clk) begin
        if (st_q == S_IDLE && block_valid) begin
            for (int t = 0; t < 16; t++)
                W[t] <= block_in[511 - t*32 -: 32];
        end else if (st_q == S_SCHEDULE) begin
            for (int t = 16; t < 64; t++) begin
                logic [31:0] s0, s1;
                s0 = rotr(W[t-15],7) ^ rotr(W[t-15],18) ^ (W[t-15] >> 3);
                s1 = rotr(W[t-2],17) ^ rotr(W[t-2],19)  ^ (W[t-2] >> 10);
                W[t] <= W[t-16] + s0 + W[t-7] + s1;
            end
        end
    end

    // ---- Compression rounds (one round per clock) ----
    logic finalize_q;   // registered: pulses the cycle AFTER H[] is updated

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            round <= '0;
            finalize_q <= 1'b0;
        end else if (init) begin
            for (int i = 0; i < 8; i++) H[i] <= H0_INIT[i];
            round <= '0;
            finalize_q <= 1'b0;
        end else if (st_q == S_SCHEDULE) begin
            {a,b,c,d,e,f,g,h} <= {H[0],H[1],H[2],H[3],H[4],H[5],H[6],H[7]};
            round <= '0;
            finalize_q <= 1'b0;
        end else if (st_q == S_COMPRESS) begin
            logic [31:0] S1, ch, temp1, S0, maj, temp2;
            S1    = rotr(e,6) ^ rotr(e,11) ^ rotr(e,25);
            ch    = (e & f) ^ (~e & g);
            temp1 = h + S1 + ch + K_ROM(round) + W[round];
            S0    = rotr(a,2) ^ rotr(a,13) ^ rotr(a,22);
            maj   = (a & b) ^ (a & c) ^ (b & c);
            temp2 = S0 + maj;

            h <= g; g <= f; f <= e; e <= d + temp1;
            d <= c; c <= b; b <= a; a <= temp1 + temp2;
            round <= round + 1'b1;
            finalize_q <= 1'b0;
        end else if (st_q == S_FINALIZE) begin
            H[0] <= H[0] + a; H[1] <= H[1] + b; H[2] <= H[2] + c; H[3] <= H[3] + d;
            H[4] <= H[4] + e; H[5] <= H[5] + f; H[6] <= H[6] + g; H[7] <= H[7] + h;
            finalize_q <= 1'b1;  // H[] above will be valid NEXT cycle
        end else begin
            finalize_q <= 1'b0;
        end
    end

    // block_done pulses one cycle after S_FINALIZE — exactly when the
    // updated H[] values are visible on state_out. Consumers (the
    // Security Control FSM) must sample state_out on this pulse, not
    // during S_FINALIZE itself.
    assign block_done = finalize_q;
    assign state_out  = {H[0],H[1],H[2],H[3],H[4],H[5],H[6],H[7]};

endmodule
