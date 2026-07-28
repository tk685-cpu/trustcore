// =============================================================================
// sha256.v
// SHA-256 Hash Core
//
// Architecture : Iterative — 1 compression round per clock cycle
// Spec         : FIPS 180-4 SHA-256
// Features     : Internal padding (single 512-bit block), msg up to 55 bytes
// Target       : 0.5um CMOS ASIC, 25 MHz system clock
//
// SHA-256 Algorithm Steps:
//   1. Padding    : msg || 0x80 || zeros || 64-bit length → 512-bit block
//   2. Schedule   : W[0..15] loaded from block directly (1 word/cycle)
//   3. Compress   : 64 rounds using W[0] each round, slide window left
//   4. Output     : digest = H0_INIT+a || ... || H7_INIT+h
//
// W window convention during COMPRESS:
//   W[0]  = W[t]       (current round word, fed into T1)
//   W[1]  = W[t+1]     (used for σ0 in schedule)
//   W[9]  = W[t+7]... actually W[t+9] wait let me redo
//   Each cycle: slide left (W[0] drops, W[1..15] → W[0..14]), W[15] = W_new
//
// Interface:
//   - Driven by spi_buffer_ctrl via data_ready pulse
//   - Outputs 256-bit digest
// =============================================================================

module sha256 (
    input  wire        clk,
    input  wire        rst_n,

    // Control
    input  wire        start,       // 1-cycle pulse: begin hashing
    output reg         busy,        // high while processing
    output reg         done,        // 1-cycle pulse: digest is valid

    // Input (held stable while busy)
    input  wire [255:0] message,    // message data (up to 32 bytes, left-aligned)
    input  wire [7:0]   msg_len,    // message length in bytes (max 55)

    // Output
    output reg  [255:0] digest      // 256-bit SHA-256 hash
);

    // =========================================================================
    // SHA-256 Initial Hash Values (H0..H7)
    // =========================================================================
    localparam [31:0] H0_INIT = 32'h6a09e667;
    localparam [31:0] H1_INIT = 32'hbb67ae85;
    localparam [31:0] H2_INIT = 32'h3c6ef372;
    localparam [31:0] H3_INIT = 32'ha54ff53a;
    localparam [31:0] H4_INIT = 32'h510e527f;
    localparam [31:0] H5_INIT = 32'h9b05688c;
    localparam [31:0] H6_INIT = 32'h1f83d9ab;
    localparam [31:0] H7_INIT = 32'h5be0cd19;

    // =========================================================================
    // SHA-256 Round Constants K[0..63]
    // Implemented as a synthesizable combinational lookup (function + case),
    // NOT an initial block -- initial blocks are simulation-only and are
    // dropped during synthesis, which would leave K tied to all zeros on
    // the real chip while still "working" in simulation.
    // =========================================================================
    function [31:0] k_val;
        input [6:0] idx;
        begin
            case (idx)
                7'd0 : k_val = 32'h428a2f98;  7'd1 : k_val = 32'h71374491;
                7'd2 : k_val = 32'hb5c0fbcf;  7'd3 : k_val = 32'he9b5dba5;
                7'd4 : k_val = 32'h3956c25b;  7'd5 : k_val = 32'h59f111f1;
                7'd6 : k_val = 32'h923f82a4;  7'd7 : k_val = 32'hab1c5ed5;
                7'd8 : k_val = 32'hd807aa98;  7'd9 : k_val = 32'h12835b01;
                7'd10: k_val = 32'h243185be;  7'd11: k_val = 32'h550c7dc3;
                7'd12: k_val = 32'h72be5d74;  7'd13: k_val = 32'h80deb1fe;
                7'd14: k_val = 32'h9bdc06a7;  7'd15: k_val = 32'hc19bf174;
                7'd16: k_val = 32'he49b69c1;  7'd17: k_val = 32'hefbe4786;
                7'd18: k_val = 32'h0fc19dc6;  7'd19: k_val = 32'h240ca1cc;
                7'd20: k_val = 32'h2de92c6f;  7'd21: k_val = 32'h4a7484aa;
                7'd22: k_val = 32'h5cb0a9dc;  7'd23: k_val = 32'h76f988da;
                7'd24: k_val = 32'h983e5152;  7'd25: k_val = 32'ha831c66d;
                7'd26: k_val = 32'hb00327c8;  7'd27: k_val = 32'hbf597fc7;
                7'd28: k_val = 32'hc6e00bf3;  7'd29: k_val = 32'hd5a79147;
                7'd30: k_val = 32'h06ca6351;  7'd31: k_val = 32'h14292967;
                7'd32: k_val = 32'h27b70a85;  7'd33: k_val = 32'h2e1b2138;
                7'd34: k_val = 32'h4d2c6dfc;  7'd35: k_val = 32'h53380d13;
                7'd36: k_val = 32'h650a7354;  7'd37: k_val = 32'h766a0abb;
                7'd38: k_val = 32'h81c2c92e;  7'd39: k_val = 32'h92722c85;
                7'd40: k_val = 32'ha2bfe8a1;  7'd41: k_val = 32'ha81a664b;
                7'd42: k_val = 32'hc24b8b70;  7'd43: k_val = 32'hc76c51a3;
                7'd44: k_val = 32'hd192e819;  7'd45: k_val = 32'hd6990624;
                7'd46: k_val = 32'hf40e3585;  7'd47: k_val = 32'h106aa070;
                7'd48: k_val = 32'h19a4c116;  7'd49: k_val = 32'h1e376c08;
                7'd50: k_val = 32'h2748774c;  7'd51: k_val = 32'h34b0bcb5;
                7'd52: k_val = 32'h391c0cb3;  7'd53: k_val = 32'h4ed8aa4a;
                7'd54: k_val = 32'h5b9cca4f;  7'd55: k_val = 32'h682e6ff3;
                7'd56: k_val = 32'h748f82ee;  7'd57: k_val = 32'h78a5636f;
                7'd58: k_val = 32'h84c87814;  7'd59: k_val = 32'h8cc70208;
                7'd60: k_val = 32'h90befffa;  7'd61: k_val = 32'ha4506ceb;
                7'd62: k_val = 32'hbef9a3f7;  7'd63: k_val = 32'hc67178f2;
                default: k_val = 32'h0;
            endcase
        end
    endfunction

    // =========================================================================
    // FSM States
    // =========================================================================
    localparam S_IDLE     = 3'd0;
    localparam S_PAD      = 3'd1;
    localparam S_SCHED    = 3'd2;  // load W[0..15] from block (16 cycles)
    localparam S_COMPRESS = 3'd3;  // 64 rounds
    localparam S_FINAL    = 3'd4;
    localparam S_DONE     = 3'd5;

    reg [2:0] state;
    reg [6:0] round;   // 0..15 for SCHED, 0..63 for COMPRESS

    // =========================================================================
    // Padded 512-bit block
    // =========================================================================
    reg [511:0] block;

    // =========================================================================
    // Message schedule window W[0..15]
    // During COMPRESS:
    //   W[0]  = W[t]       current round word → used in T1
    //   W[1]  = W[t+1]     → used in σ0 for W_new
    //   W[9]  = W[t+9]     → used in W_new addition
    //   W[14] = W[t+14]    → used in σ1 for W_new
    //   W[15] = W[t+15]    → becomes W_new storage slot
    //
    // Each cycle: slide left (W[0] drops, W[0..14]←W[1..15]), W[15] = W_new
    // =========================================================================
    reg [31:0] W [0:15];

    // =========================================================================
    // Working variables and hash state
    // =========================================================================
    reg [31:0] a, b, c, d, e, f, g, h;

    // =========================================================================
    // Combinational schedule functions
    // σ0(x) = ROR(x,7) ^ ROR(x,18) ^ SHR(x,3)   applied to W[1] = W[t+1]
    // σ1(x) = ROR(x,17) ^ ROR(x,19) ^ SHR(x,10)  applied to W[14] = W[t+14]
    // W_new = W[t+16] = σ1(W[t+14]) + W[t+9] + σ0(W[t+1]) + W[t]
    //       = σ1(W[14]) + W[9] + σ0(W[1]) + W[0]
    // =========================================================================
    wire [31:0] sigma0_w = {W[1][6:0],  W[1][31:7]}    // ROR(W[1], 7)
                         ^ {W[1][17:0], W[1][31:18]}    // ROR(W[1], 18)
                         ^ {3'b000,     W[1][31:3]};    // SHR(W[1], 3)

    wire [31:0] sigma1_w = {W[14][16:0], W[14][31:17]} // ROR(W[14], 17)
                         ^ {W[14][18:0], W[14][31:19]} // ROR(W[14], 19)
                         ^ {10'b0,       W[14][31:10]};// SHR(W[14], 10)

    wire [31:0] W_new = sigma1_w + W[9] + sigma0_w + W[0];

    // =========================================================================
    // Combinational compression functions
    // Ch(e,f,g)  = (e & f) ^ (~e & g)
    // Maj(a,b,c) = (a & b) ^ (a & c) ^ (b & c)
    // Σ0(a) = ROR(a,2) ^ ROR(a,13) ^ ROR(a,22)
    // Σ1(e) = ROR(e,6) ^ ROR(e,11) ^ ROR(e,25)
    // T1 = h + Σ1(e) + Ch(e,f,g) + K[round] + W[0]   ← W[0] is current word
    // T2 = Σ0(a) + Maj(a,b,c)
    // =========================================================================
    wire [31:0] Ch  = (e & f) ^ (~e & g);
    wire [31:0] Maj = (a & b) ^ (a & c) ^ (b & c);

    wire [31:0] SIG0 = {a[1:0],  a[31:2]}    // ROR(a, 2)
                     ^ {a[12:0], a[31:13]}    // ROR(a, 13)
                     ^ {a[21:0], a[31:22]};   // ROR(a, 22)

    wire [31:0] SIG1 = {e[5:0],  e[31:6]}    // ROR(e, 6)
                     ^ {e[10:0], e[31:11]}    // ROR(e, 11)
                     ^ {e[24:0], e[31:25]};   // ROR(e, 25)

    // T1 uses W[0] — the current round's message schedule word
    wire [31:0] T1 = h + SIG1 + Ch + k_val(round) + W[0];
    wire [31:0] T2 = SIG0 + Maj;

    // =========================================================================
    // Main FSM
    // =========================================================================
    integer idx;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state  <= S_IDLE;
            busy   <= 1'b0;
            done   <= 1'b0;
            round  <= 7'd0;
            block  <= 512'd0;
            digest <= 256'd0;
            a <= 32'd0; b <= 32'd0; c <= 32'd0; d <= 32'd0;
            e <= 32'd0; f <= 32'd0; g <= 32'd0; h <= 32'd0;
            // Initialise W to 0 so no X values propagate
            W[ 0] <= 32'd0; W[ 1] <= 32'd0; W[ 2] <= 32'd0; W[ 3] <= 32'd0;
            W[ 4] <= 32'd0; W[ 5] <= 32'd0; W[ 6] <= 32'd0; W[ 7] <= 32'd0;
            W[ 8] <= 32'd0; W[ 9] <= 32'd0; W[10] <= 32'd0; W[11] <= 32'd0;
            W[12] <= 32'd0; W[13] <= 32'd0; W[14] <= 32'd0; W[15] <= 32'd0;
        end else begin
            done <= 1'b0;

            case (state)

                // ── Wait for start ──
                S_IDLE: begin
                    if (start) begin
                        busy  <= 1'b1;
                        state <= S_PAD;
                    end
                end

                // ── Build padded 512-bit block ──
                // message occupies top msg_len bytes of block (left-aligned)
                // then 0x80, then zeros, then 64-bit length at bottom
                S_PAD: begin
                    // Clear block, then write message, padding byte, and length
                    block <= 512'd0;

                    // Top 256 bits: message (already left-aligned in input port)
                    block[511:256] <= message;

                    // 0x80 padding byte immediately after message
                    case (msg_len)
                        8'd0:  block[511:504] <= 8'h80;
                        8'd1:  block[503:496] <= 8'h80;
                        8'd2:  block[495:488] <= 8'h80;
                        8'd3:  block[487:480] <= 8'h80;
                        8'd4:  block[479:472] <= 8'h80;
                        8'd5:  block[471:464] <= 8'h80;
                        8'd6:  block[463:456] <= 8'h80;
                        8'd7:  block[455:448] <= 8'h80;
                        8'd8:  block[447:440] <= 8'h80;
                        8'd9:  block[439:432] <= 8'h80;
                        8'd10: block[431:424] <= 8'h80;
                        8'd11: block[423:416] <= 8'h80;
                        8'd12: block[415:408] <= 8'h80;
                        8'd13: block[407:400] <= 8'h80;
                        8'd14: block[399:392] <= 8'h80;
                        8'd15: block[391:384] <= 8'h80;
                        8'd16: block[383:376] <= 8'h80;
                        8'd17: block[375:368] <= 8'h80;
                        8'd18: block[367:360] <= 8'h80;
                        8'd19: block[359:352] <= 8'h80;
                        8'd20: block[351:344] <= 8'h80;
                        8'd21: block[343:336] <= 8'h80;
                        8'd22: block[335:328] <= 8'h80;
                        8'd23: block[327:320] <= 8'h80;
                        8'd24: block[319:312] <= 8'h80;
                        8'd25: block[311:304] <= 8'h80;
                        8'd26: block[303:296] <= 8'h80;
                        8'd27: block[295:288] <= 8'h80;
                        8'd28: block[287:280] <= 8'h80;
                        8'd29: block[279:272] <= 8'h80;
                        8'd30: block[271:264] <= 8'h80;
                        8'd31: block[263:256] <= 8'h80;
                        8'd32: block[255:248] <= 8'h80;
                        default: block[255:248] <= 8'h80;
                    endcase

                    // 64-bit message length in bits at the very end of block
                    block[63:0] <= {56'd0, msg_len} << 3;

                    // Initialise working variables to initial hash values
                    a <= H0_INIT; b <= H1_INIT; c <= H2_INIT; d <= H3_INIT;
                    e <= H4_INIT; f <= H5_INIT; g <= H6_INIT; h <= H7_INIT;

                    round <= 7'd0;
                    state <= S_SCHED;
                end

                // ── Load W[0..15] directly from block (16 cycles) ──
                // W[0] = block word 0 = block[511:480]
                // W[1] = block word 1 = block[479:448]  etc.
                // After this: W[0]=M[0], W[1]=M[1], ..., W[15]=M[15]
                // When COMPRESS starts, W[0] is the word for round 0. ✓
                S_SCHED: begin
                    case (round[3:0])
                        4'd0:  W[0]  <= block[511:480];
                        4'd1:  W[1]  <= block[479:448];
                        4'd2:  W[2]  <= block[447:416];
                        4'd3:  W[3]  <= block[415:384];
                        4'd4:  W[4]  <= block[383:352];
                        4'd5:  W[5]  <= block[351:320];
                        4'd6:  W[6]  <= block[319:288];
                        4'd7:  W[7]  <= block[287:256];
                        4'd8:  W[8]  <= block[255:224];
                        4'd9:  W[9]  <= block[223:192];
                        4'd10: W[10] <= block[191:160];
                        4'd11: W[11] <= block[159:128];
                        4'd12: W[12] <= block[127:96];
                        4'd13: W[13] <= block[95:64];
                        4'd14: W[14] <= block[63:32];
                        4'd15: W[15] <= block[31:0];
                        default: ;
                    endcase

                    if (round == 7'd15) begin
                        round <= 7'd0;   // reset counter for 64-round COMPRESS
                        state <= S_COMPRESS;
                    end else begin
                        round <= round + 1'b1;
                    end
                end

                // ── 64 rounds of SHA-256 compression ──
                // T1 uses W[0] — the current round's message word
                // After each round: slide window left, W[15] = W_new
                S_COMPRESS: begin
                    // Update working variables
                    h <= g;
                    g <= f;
                    f <= e;
                    e <= d + T1;
                    d <= c;
                    c <= b;
                    b <= a;
                    a <= T1 + T2;

                    // Slide W window left: W[0] drops off, new word enters W[15]
                    for (idx = 0; idx < 15; idx = idx + 1)
                        W[idx] <= W[idx+1];
                    W[15] <= W_new;

                    if (round == 7'd63) begin
                        state <= S_FINAL;
                    end else begin
                        round <= round + 1'b1;
                    end
                end

                // ── Add compressed chunk to initial hash values ──
                S_FINAL: begin
                    digest <= {H0_INIT + a,
                               H1_INIT + b,
                               H2_INIT + c,
                               H3_INIT + d,
                               H4_INIT + e,
                               H5_INIT + f,
                               H6_INIT + g,
                               H7_INIT + h};
                    state <= S_DONE;
                end

                // ── Signal completion ──
                S_DONE: begin
                    done  <= 1'b1;
                    busy  <= 1'b0;
                    state <= S_IDLE;
                end

                default: state <= S_IDLE;

            endcase
        end
    end

endmodule