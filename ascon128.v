// =============================================================================
// ascon128.v
// Ascon-128 AEAD Encryption Core
//
// Architecture : Iterative — 1 permutation round per clock cycle
// Spec         : Ascon-128 (NIST LWC winner)
//                Key=128b, Nonce=128b, Rate=64b, p^a=12, p^b=6
// Features     : Associated Data (AD) support, encryption only
// Target       : 0.5um CMOS ASIC, 25 MHz system clock
//
// Ascon-128 Algorithm Steps:
//   1. Initialization  : S = IV||K||N  →  p12  →  x3^=K0, x4^=K1
//   2. AD Processing   : for each 64-bit AD block: x0^=AD  →  p6
//                        domain separation: x4 ^= 1
//   3. Encryption      : for each 64-bit PT block: x0^=PT, CT=x0  →  p6 (not last)
//   4. Finalization    : x1^=K0, x2^=K1  →  p12  →  tag = (x3^K0)||(x4^K1)
//
// Note: Assumes plaintext and AD lengths are multiples of 8 bytes (full blocks).
//       Padding (0x80...) must be applied by caller for partial blocks.
//
// Interface:
//   - Driven by spi_buffer_ctrl via data_ready pulse
//   - Outputs ciphertext + tag to result buffer
// =============================================================================

module ascon128 (
    input  wire        clk,
    input  wire        rst_n,

    // Control
    input  wire        start,        // 1-cycle pulse: begin encryption
    output reg         busy,         // high while processing
    output reg         done,         // 1-cycle pulse: outputs are valid

    // Inputs (held stable while busy)
    input  wire [127:0] key,         // 128-bit secret key
    input  wire [127:0] nonce,       // 128-bit nonce (must be unique per msg)
    input  wire [255:0] ad,          // associated data (up to 32 bytes)
    input  wire [7:0]   ad_len,      // AD length in bytes (0 = no AD)
    input  wire [255:0] plaintext,   // plaintext (up to 32 bytes)
    input  wire [7:0]   pt_len,      // plaintext length in bytes

    // Outputs
    output reg  [255:0] ciphertext,  // encrypted output (same length as plaintext)
    output reg  [127:0] tag          // 128-bit authentication tag
);

    // =========================================================================
    // Constants
    // =========================================================================

    // Ascon-128 initialisation vector
    // Format: key_len[7:0] || rate[7:0] || pa[7:0] || pb[7:0] || 32'h0
    //         = 128        || 64        || 12       || 6        || 0
    localparam [63:0] IV = 64'h80400c0600000000;

    // FSM state encoding
    localparam S_IDLE       = 4'd0;
    localparam S_INIT_LOAD  = 4'd1;  // Load IV||K||N into state
    localparam S_PERM       = 4'd2;  // Generic permutation (1 round/cycle)
    localparam S_INIT_POST  = 4'd3;  // XOR key after init permutation
    localparam S_AD_CHECK   = 4'd4;  // Check if more AD blocks remain
    localparam S_AD_ABSORB  = 4'd5;  // XOR AD block into x0
    localparam S_AD_DOM     = 4'd6;  // Domain separation: x4 ^= 1
    localparam S_ENC        = 4'd7;  // Absorb PT, output CT, maybe start p6
    localparam S_FIN_XOR    = 4'd8;  // x1^=K0, x2^=K1
    localparam S_FIN_TAG    = 4'd9;  // Compute tag
    localparam S_DONE       = 4'd10; // Pulse done, return to IDLE

    // =========================================================================
    // Ascon State: 5 × 64-bit words
    // =========================================================================
    reg [63:0] x0, x1, x2, x3, x4;

    // =========================================================================
    // Control registers
    // =========================================================================
    reg [3:0] state;
    reg [3:0] next_after_perm;  // state to enter after permutation completes
    reg [3:0] round_cnt;        // current round index (0–11)
    reg [2:0] block_cnt;        // current data block index (0–3)

    // =========================================================================
    // Key / Nonce word aliases
    // =========================================================================
    wire [63:0] k0 = key[127:64];
    wire [63:0] k1 = key[63:0];
    wire [63:0] n0 = nonce[127:64];
    wire [63:0] n1 = nonce[63:0];

    // =========================================================================
    // Block count helpers
    // pt_blocks / ad_blocks = ceil(len / 8)
    // =========================================================================
    wire [3:0] pt_blocks = pt_len[7:3] + (|pt_len[2:0]);  // ceil(pt_len/8)
    wire [3:0] ad_blocks = ad_len[7:3] + (|ad_len[2:0]);  // ceil(ad_len/8)

    // =========================================================================
    // 64-bit block selectors (combinational MUX on block_cnt)
    // =========================================================================
    reg [63:0] pt_block;  // current plaintext block
    reg [63:0] ad_block;  // current AD block

    always @(*) begin
        case (block_cnt[1:0])
            2'd0: pt_block = plaintext[255:192];
            2'd1: pt_block = plaintext[191:128];
            2'd2: pt_block = plaintext[127:64];
            2'd3: pt_block = plaintext[63:0];
            default: pt_block = 64'd0;
        endcase
    end

    always @(*) begin
        case (block_cnt[1:0])
            2'd0: ad_block = ad[255:192];
            2'd1: ad_block = ad[191:128];
            2'd2: ad_block = ad[127:64];
            2'd3: ad_block = ad[63:0];
            default: ad_block = 64'd0;
        endcase
    end

    // =========================================================================
    // Round constant
    // rc[i] = {(0xf - i)[3:0], i[3:0]}
    // e.g. i=0 → 0xf0, i=6 → 0x96, i=11 → 0x4b
    // =========================================================================
    wire [7:0] rc = {(4'hf - round_cnt[3:0]), round_cnt[3:0]};

    // =========================================================================
    // Combinational round function
    // Implements one Ascon permutation round:
    //   1. Add round constant to x2
    //   2. Substitution layer (chi + theta-like nonlinear step)
    //   3. Linear diffusion layer (sigma)
    //
    // ROR(x, n) for 64-bit x = {x[n-1:0], x[63:n]}
    // =========================================================================
    reg [63:0] nx0, nx1, nx2, nx3, nx4;

    always @(*) begin : round_function
        reg [63:0] s0, s1, s2, s3, s4;
        reg [63:0] t0, t1, t2, t3, t4;

        s0 = x0; s1 = x1; s2 = x2; s3 = x3; s4 = x4;

        // ── Step 1: Add round constant ──
        s2 = s2 ^ {56'h00000000000000, rc};

        // ── Step 2: Substitution layer ──
        // Pre-mixing
        s0 = s0 ^ s4;
        s4 = s4 ^ s3;
        s2 = s2 ^ s1;

        // Nonlinear (AND-NOT)
        t0 = s0 ^ (~s1 & s2);
        t1 = s1 ^ (~s2 & s3);
        t2 = s2 ^ (~s3 & s4);
        t3 = s3 ^ (~s4 & s0);
        t4 = s4 ^ (~s0 & s1);

        // Post-mixing
        t1 = t1 ^ t0;
        t0 = t0 ^ t4;
        t3 = t3 ^ t2;
        t2 = ~t2;

        // ── Step 3: Linear diffusion layer ──
        // sigma_0: x0 = t0 ^ ROR(t0,19) ^ ROR(t0,28)
        nx0 = t0 ^ {t0[18:0], t0[63:19]} ^ {t0[27:0], t0[63:28]};

        // sigma_1: x1 = t1 ^ ROR(t1,61) ^ ROR(t1,39)
        nx1 = t1 ^ {t1[60:0], t1[63:61]} ^ {t1[38:0], t1[63:39]};

        // sigma_2: x2 = t2 ^ ROR(t2,1) ^ ROR(t2,6)
        nx2 = t2 ^ {t2[0],   t2[63:1] } ^ {t2[5:0],  t2[63:6] };

        // sigma_3: x3 = t3 ^ ROR(t3,10) ^ ROR(t3,17)
        nx3 = t3 ^ {t3[9:0], t3[63:10]} ^ {t3[16:0], t3[63:17]};

        // sigma_4: x4 = t4 ^ ROR(t4,7) ^ ROR(t4,41)
        nx4 = t4 ^ {t4[6:0], t4[63:7] } ^ {t4[40:0], t4[63:41]};
    end

    // =========================================================================
    // Main FSM
    // =========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= S_IDLE;
            busy           <= 1'b0;
            done           <= 1'b0;
            round_cnt      <= 4'd0;
            block_cnt      <= 3'd0;
            next_after_perm<= S_IDLE;
            x0 <= 64'd0; x1 <= 64'd0; x2 <= 64'd0;
            x3 <= 64'd0; x4 <= 64'd0;
            ciphertext     <= 256'd0;
            tag            <= 128'd0;
        end else begin
            done <= 1'b0;  // default: done is a 1-cycle pulse

            case (state)

                // ── Wait for start pulse ──
                S_IDLE: begin
                    if (start) begin
                        busy       <= 1'b1;
                        // Clear ciphertext so a shorter operation can't expose
                        // leftover bytes from a previous, unrelated encryption
                        // (only the blocks up to pt_blocks get overwritten below)
                        ciphertext <= 256'd0;
                        state      <= S_INIT_LOAD;
                    end
                end

                // ── Load S = IV || K0 || K1 || N0 || N1 ──
                S_INIT_LOAD: begin
                    x0        <= IV;
                    x1        <= k0;
                    x2        <= k1;
                    x3        <= n0;
                    x4        <= n1;
                    round_cnt <= 4'd0;              // p12: rounds 0–11
                    next_after_perm <= S_INIT_POST;
                    state     <= S_PERM;
                end

                // ── Generic permutation state: 1 round per cycle ──
                // Uses nx0..nx4 from combinational round function above.
                // Stays here until round_cnt reaches 11 (last round).
                S_PERM: begin
                    x0 <= nx0; x1 <= nx1; x2 <= nx2;
                    x3 <= nx3; x4 <= nx4;
                    if (round_cnt == 4'd11) begin
                        state <= next_after_perm;
                    end else begin
                        round_cnt <= round_cnt + 1'b1;
                    end
                end

                // ── Post-init: XOR key into state, then check AD ──
                S_INIT_POST: begin
                    x3        <= x3 ^ k0;
                    x4        <= x4 ^ k1;
                    block_cnt <= 3'd0;
                    state     <= S_AD_CHECK;
                end

                // ── Decide if there are more AD blocks to process ──
                S_AD_CHECK: begin
                    if (block_cnt >= {1'b0, ad_blocks}) begin
                        state <= S_AD_DOM;
                    end else begin
                        state <= S_AD_ABSORB;
                    end
                end

                // ── Absorb one AD block into x0, then run p6 ──
                S_AD_ABSORB: begin
                    x0        <= x0 ^ ad_block;
                    round_cnt <= 4'd6;              // p6: rounds 6–11
                    block_cnt <= block_cnt + 1'b1;
                    next_after_perm <= S_AD_CHECK;
                    state     <= S_PERM;
                end

                // ── Domain separation after all AD ──
                S_AD_DOM: begin
                    x4        <= x4 ^ 64'h1;
                    block_cnt <= 3'd0;
                    state     <= S_ENC;
                end

                // ── Encryption: absorb PT block, output CT, maybe run p6 ──
                S_ENC: begin
                    if (block_cnt >= {1'b0, pt_blocks}) begin
                        // All plaintext blocks processed
                        state <= S_FIN_XOR;
                    end else begin
                        // Absorb plaintext block
                        x0 <= x0 ^ pt_block;

                        // Ciphertext = x0 ^ pt_block (the new x0)
                        case (block_cnt[1:0])
                            2'd0: ciphertext[255:192] <= x0 ^ pt_block;
                            2'd1: ciphertext[191:128] <= x0 ^ pt_block;
                            2'd2: ciphertext[127:64]  <= x0 ^ pt_block;
                            2'd3: ciphertext[63:0]    <= x0 ^ pt_block;
                        endcase

                        block_cnt <= block_cnt + 1'b1;

                        if (block_cnt < {1'b0, pt_blocks} - 1) begin
                            // Not the last block: apply p6 before next block
                            round_cnt <= 4'd6;
                            next_after_perm <= S_ENC;
                            state <= S_PERM;
                        end else begin
                            // Last block: skip permutation, go to finalization
                            state <= S_FIN_XOR;
                        end
                    end
                end

                // ── Finalization step 1: XOR key into x1, x2 ──
                S_FIN_XOR: begin
                    x1        <= x1 ^ k0;
                    x2        <= x2 ^ k1;
                    round_cnt <= 4'd0;              // p12: rounds 0–11
                    next_after_perm <= S_FIN_TAG;
                    state     <= S_PERM;
                end

                // ── Finalization step 2: Extract tag ──
                S_FIN_TAG: begin
                    tag   <= {x3 ^ k0, x4 ^ k1};
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
