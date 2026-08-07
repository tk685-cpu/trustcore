// ascon_core.sv
//
// Ascon permutation core, shared by Ascon-Hash256 and Ascon-AEAD128
// (both are built from the same 320-bit-state permutation, per the
// Ascon spec — this is what keeps the hardware footprint small,
// consistent with the ~360 flip-flop estimate discussed for TrustCore-v1).
//
// This module implements ONLY the permutation primitive (p^12 / p^6)
// plus a thin absorb/squeeze control layer for Ascon-Hash256. A full
// Ascon-AEAD128 datapath (key/nonce loading, associated-data phase,
// plaintext/ciphertext phase, tag finalization) follows the same
// permutation core but needs its own control FSM — flagged as a
// follow-up module (ascon_aead_core.sv) rather than expanded here,
// to keep this first RTL pass reviewable.
//
// *** VERIFICATION NOTICE ***
// Round constants and rotation amounts below must be checked bit-for-bit
// against ascon.c (the golden model) and official KAT vectors before
// sign-off. See the verification notice in ascon.c for why this matters.

module ascon_permutation (
    input  logic         clk,
    input  logic         rst_n,

    input  logic         start,        // pulse: begin permutation on x_in
    input  logic [1:0]   round_sel,    // 0 = 12 rounds (p^a), 1 = 6 rounds (p^b)
    input  logic [319:0] x_in,         // {x0,x1,x2,x3,x4}, 64 bits each

    output logic         busy,
    output logic         done,         // pulses one cycle when x_out is valid
    output logic [319:0] x_out
);

    // ---- Round constants (last-N-of-12 selection per round_sel) ----
    function automatic logic [63:0] RC(input int idx);
        logic [63:0] rc [0:11];
        rc[0] =64'h00000000000000f0; rc[1] =64'h00000000000000e1;
        rc[2] =64'h00000000000000d2; rc[3] =64'h00000000000000c3;
        rc[4] =64'h00000000000000b4; rc[5] =64'h00000000000000a5;
        rc[6] =64'h0000000000000096; rc[7] =64'h0000000000000087;
        rc[8] =64'h0000000000000078; rc[9] =64'h0000000000000069;
        rc[10]=64'h000000000000005a; rc[11]=64'h000000000000004b;
        return rc[idx];
    endfunction

    function automatic logic [63:0] rotr64(input logic [63:0] x, input int n);
        return (x >> n) | (x << (64 - n));
    endfunction

    // ---- State ----
    logic [63:0] x0, x1, x2, x3, x4;
    logic [3:0]  round_idx;      // 0..11, absolute round index into RC()
    logic [3:0]  rounds_total;   // 12 or 6
    logic [3:0]  rounds_done;

    typedef enum logic [1:0] {P_IDLE, P_ROUND, P_DONE} pstate_t;
    pstate_t pst_q, pst_d;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) pst_q <= P_IDLE;
        else        pst_q <= pst_d;
    end

    always_comb begin
        pst_d = pst_q;
        unique case (pst_q)
            P_IDLE:  pst_d = start ? P_ROUND : P_IDLE;
            P_ROUND: pst_d = (rounds_done == rounds_total) ? P_DONE : P_ROUND;
            P_DONE:  pst_d = P_IDLE;
            default: pst_d = P_IDLE;
        endcase
    end

    assign busy = (pst_q != P_IDLE);
    assign done = (pst_q == P_DONE);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rounds_done  <= '0;
            rounds_total <= '0;
            round_idx    <= '0;
        end else if (pst_q == P_IDLE && start) begin
            {x0,x1,x2,x3,x4} <= x_in;
            rounds_total <= (round_sel == 2'd1) ? 4'd6 : 4'd12;
            round_idx    <= (round_sel == 2'd1) ? 4'd6 : 4'd0;  // p^6 starts at RC[6]
            rounds_done  <= '0;
        end else if (pst_q == P_ROUND) begin
            logic [63:0] t0, t1, t2, t3, t4;
            logic [63:0] w0, w1, w2, w3, w4;

            // --- Add round constant ---
            w2 = x2 ^ RC(round_idx);
            w0 = x0; w1 = x1; w3 = x3; w4 = x4;

            // --- Substitution layer (bit-sliced 5-bit S-box) ---
            w0 = w0 ^ w4;
            w4 = w4 ^ w3;
            w2 = w2 ^ w1;
            t0 = ~w0; t1 = ~w1; t2 = ~w2; t3 = ~w3; t4 = ~w4;
            t0 = t0 & w1; t1 = t1 & w2; t2 = t2 & w3; t3 = t3 & w4; t4 = t4 & w0;
            w0 = w0 ^ t1; w1 = w1 ^ t2; w2 = w2 ^ t3; w3 = w3 ^ t4; w4 = w4 ^ t0;
            w1 = w1 ^ w0;
            w0 = w0 ^ w4;
            w3 = w3 ^ w2;
            w2 = ~w2;

            // --- Linear diffusion layer ---
            x0 <= w0 ^ rotr64(w0,19) ^ rotr64(w0,28);
            x1 <= w1 ^ rotr64(w1,61) ^ rotr64(w1,39);
            x2 <= w2 ^ rotr64(w2,1)  ^ rotr64(w2,6);
            x3 <= w3 ^ rotr64(w3,10) ^ rotr64(w3,17);
            x4 <= w4 ^ rotr64(w4,7)  ^ rotr64(w4,41);

            round_idx   <= round_idx + 1'b1;
            rounds_done <= rounds_done + 1'b1;
        end
    end

    assign x_out = {x0,x1,x2,x3,x4};

endmodule


// ---------------------------------------------------------------------
// ascon_hash_core.sv (kept in the same file for the PoC first pass)
//
// Thin wrapper around ascon_permutation implementing Ascon-Hash256's
// absorb (rate = 64 bits) / squeeze (4 x 64-bit output words) schedule.
// ---------------------------------------------------------------------

module ascon_hash_core (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        init,           // pulse: load IV, run first p^12
    input  logic        absorb_valid,   // pulse: block_in is a full 8-byte block
    input  logic [63:0] block_in,

    input  logic        finalize,       // pulse: block_in holds the final
                                         // (already 0x80-padded) partial block
    output logic        busy,
    output logic        block_done,     // pulses when state is ready for next absorb
    output logic [255:0] digest_out,    // valid after 4 squeeze steps post-finalize
    output logic        digest_done
);

    localparam logic [63:0] ASCON_HASH256_IV = 64'h0000080100cc0002;

    logic [319:0] perm_in, perm_out;
    logic         perm_start, perm_busy, perm_done;
    logic [1:0]   perm_round_sel;

    ascon_permutation u_perm (
        .clk(clk), .rst_n(rst_n),
        .start(perm_start), .round_sel(perm_round_sel),
        .x_in(perm_in), .busy(perm_busy), .done(perm_done), .x_out(perm_out)
    );

    logic [63:0] x0_q, x1_q, x2_q, x3_q, x4_q;
    typedef enum logic [2:0] {
        H_IDLE, H_INIT_PERM, H_ABSORB_XOR, H_ABSORB_PERM,
        H_FINAL_XOR, H_FINAL_PERM, H_SQUEEZE
    } hstate_t;
    hstate_t hst_q, hst_d;
    logic [1:0] squeeze_cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) hst_q <= H_IDLE;
        else        hst_q <= hst_d;
    end

    always_comb begin
        hst_d = hst_q;
        unique case (hst_q)
            H_IDLE:        hst_d = init ? H_INIT_PERM
                                   : absorb_valid ? H_ABSORB_XOR
                                   : finalize ? H_FINAL_XOR : H_IDLE;
            H_INIT_PERM:   hst_d = perm_done ? H_IDLE : H_INIT_PERM;
            H_ABSORB_XOR:  hst_d = H_ABSORB_PERM;
            H_ABSORB_PERM: hst_d = perm_done ? H_IDLE : H_ABSORB_PERM;
            H_FINAL_XOR:   hst_d = H_FINAL_PERM;
            H_FINAL_PERM:  hst_d = perm_done ? H_SQUEEZE : H_FINAL_PERM;
            H_SQUEEZE:     hst_d = (squeeze_cnt == 2'd3) ? H_IDLE : H_SQUEEZE;
            default:       hst_d = H_IDLE;
        endcase
    end

    assign busy = (hst_q != H_IDLE);
    assign perm_round_sel = 2'd0; // Ascon-Hash256 uses p^12 throughout (a=b=12)

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {x0_q,x1_q,x2_q,x3_q,x4_q} <= '0;
            squeeze_cnt <= '0;
            perm_start  <= 1'b0;
        end else begin
            perm_start <= 1'b0; // default: single-cycle pulse

            unique case (hst_q)
                H_IDLE: begin
                    if (init) begin
                        x0_q <= ASCON_HASH256_IV; x1_q <= '0; x2_q <= '0; x3_q <= '0; x4_q <= '0;
                    end
                end
                H_ABSORB_XOR: x0_q <= x0_q ^ block_in;
                H_FINAL_XOR:  x0_q <= x0_q ^ block_in; // block_in pre-padded by caller
                H_SQUEEZE:    squeeze_cnt <= squeeze_cnt + 1'b1;
                default: ;
            endcase

            // Kick off the permutation whenever we enter a *_PERM state
            if ((hst_q == H_IDLE && init) ||
                (hst_q == H_ABSORB_XOR) || (hst_q == H_FINAL_XOR)) begin
                perm_start <= 1'b1;
            end
            if (hst_q == H_SQUEEZE && squeeze_cnt != 2'd3) begin
                perm_start <= 1'b1; // additional p^12 between squeeze words
            end

            if (perm_done) begin
                {x0_q,x1_q,x2_q,x3_q,x4_q} <= perm_out;
            end
        end
    end

    assign perm_in = {x0_q,x1_q,x2_q,x3_q,x4_q};
    assign block_done  = (hst_q == H_ABSORB_PERM) && perm_done;
    assign digest_done  = (hst_q == H_SQUEEZE) && (squeeze_cnt == 2'd3);
    assign digest_out   = {x0_q, x1_q, x2_q, x3_q}; // squeezed 4 x 64-bit words

endmodule
