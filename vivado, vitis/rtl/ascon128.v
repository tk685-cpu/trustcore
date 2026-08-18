// =============================================================================
// ascon128.v
// Ascon-128 AEAD Encryption Core
//
// Architecture : Iterative -- 1 permutation round per clock cycle
// Spec         : Ascon-128 v1.2 (NIST LWC winner)
//                Key=128b, Nonce=128b, Rate=64b, p^a=12, p^b=6
// Features     : Associated Data support, encryption only, internal padding
// Target       : 0.5um CMOS ASIC, 25 MHz system clock (also FPGA validated)
//
// Ascon-128 Algorithm Steps:
//   1. Initialization  : S = IV||K||N  ->  p12  ->  x3^=K0, x4^=K1
//   2. AD Processing   : pad AD, then for each 64-bit block: x0^=AD -> p6
//                        domain separation: x4 ^= 1
//   3. Encryption      : pad PT, then for each 64-bit block:
//                          x0 ^= PT, CT = x0, p6 (skipped after last block)
//   4. Finalization    : x1^=K0, x2^=K1  ->  p12  ->  tag = (x3^K0)||(x4^K1)
//
// PADDING (this is done INSIDE the core, the caller supplies raw bytes):
//   Per spec the data is padded with a single 0x80 byte followed by zeros
//   until the length is a multiple of the 8-byte rate. Critically, a FULL
//   padding block is appended even when the length is already a multiple of
//   8. Plaintext therefore always produces at least one block, even when
//   pt_len is 0. Associated data produces zero blocks when ad_len is 0.
//
//   Omitting the padding block produces correct ciphertext but a WRONG tag,
//   because the padding block is still absorbed into the state before
//   finalization. This was the defect in the previous revision.
//
// Ciphertext truncation:
//   The ciphertext emitted for the final block is masked down to the number
//   of real plaintext bytes it carries, so padding never leaks into the
//   output. Bytes beyond pt_len read back as zero.
//
// Input limits:
//   pt_len and ad_len are clamped to 32 bytes internally. Values above that
//   cannot be represented on the 256-bit input ports.
//
// Interface:
//   - Driven by crypto_fsm via a 1-cycle start pulse
//   - Outputs ciphertext + tag, with a 1-cycle done pulse
// =============================================================================

module ascon128 (
    input  wire         clk,
    input  wire         rst_n,

    // Control
    input  wire         start,        // 1-cycle pulse: begin encryption
    output reg          busy,         // high while processing
    output reg          done,         // 1-cycle pulse: outputs are valid

    // Inputs (held stable while busy)
    input  wire [127:0] key,          // 128-bit secret key
    input  wire [127:0] nonce,        // 128-bit nonce (must be unique per msg)
    input  wire [255:0] ad,           // associated data, left-aligned (MSB first)
    input  wire [7:0]   ad_len,       // AD length in bytes (0 = no AD)
    input  wire [255:0] plaintext,    // plaintext, left-aligned (MSB first)
    input  wire [7:0]   pt_len,       // plaintext length in bytes (0..32)

    // Outputs
    output reg  [255:0] ciphertext,   // ciphertext, left-aligned, zero above pt_len
    output reg  [127:0] tag           // 128-bit authentication tag
);

    // =========================================================================
    // Constants
    // =========================================================================

    // Ascon-128 initialisation vector
    // Format: k[7:0] || r[7:0] || a[7:0] || b[7:0] || 32'h0
    //         = 128  || 64     || 12     || 6      || 0
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
    // Ascon State: 5 x 64-bit words
    // =========================================================================
    reg [63:0] x0, x1, x2, x3, x4;

    // =========================================================================
    // Control registers
    // =========================================================================
    reg [3:0] state;
    reg [3:0] next_after_perm;  // state to enter after permutation completes
    reg [3:0] round_cnt;        // current round index (0-11)
    reg [2:0] block_cnt;        // current data block index (0-5)

    // =========================================================================
    // Key / Nonce word aliases
    // =========================================================================
    wire [63:0] k0 = key[127:64];
    wire [63:0] k1 = key[63:0];
    wire [63:0] n0 = nonce[127:64];
    wire [63:0] n1 = nonce[63:0];

    // =========================================================================
    // Length handling
    //
    // Lengths above 32 cannot be represented on the 256-bit data ports, so we
    // clamp rather than letting the block counters run off the end.
    //
    //   *_full   = number of complete 8-byte blocks
    //   *_rem    = leftover bytes that share a block with the 0x80 pad byte
    //   *_blocks = total blocks to absorb, INCLUDING the padding block
    //
    // Plaintext always has at least one block (the pad block). Associated
    // data has none at all when ad_len is zero.
    // =========================================================================
    wire [5:0] pt_len_c = (pt_len > 8'd32) ? 6'd32 : pt_len[5:0];
    wire [5:0] ad_len_c = (ad_len > 8'd32) ? 6'd32 : ad_len[5:0];

    wire [2:0] pt_full   = pt_len_c[5:3];              // 0..4
    wire [2:0] pt_rem    = pt_len_c[2:0];              // 0..7
    wire [3:0] pt_blocks = {1'b0, pt_full} + 4'd1;     // 1..5

    wire [2:0] ad_full   = ad_len_c[5:3];
    wire [2:0] ad_rem    = ad_len_c[2:0];
    wire [3:0] ad_blocks = (ad_len_c == 6'd0) ? 4'd0 : ({1'b0, ad_full} + 4'd1);

    // =========================================================================
    // Raw 64-bit block selectors (combinational MUX on block_cnt)
    // Block index 4 is always past the end of the 256-bit port, so it reads 0
    // and only ever carries pad.
    // =========================================================================
    reg [63:0] pt_raw;
    reg [63:0] ad_raw;

    always @(*) begin
        case (block_cnt)
            3'd0:    pt_raw = plaintext[255:192];
            3'd1:    pt_raw = plaintext[191:128];
            3'd2:    pt_raw = plaintext[127:64];
            3'd3:    pt_raw = plaintext[63:0];
            default: pt_raw = 64'd0;
        endcase
    end

    always @(*) begin
        case (block_cnt)
            3'd0:    ad_raw = ad[255:192];
            3'd1:    ad_raw = ad[191:128];
            3'd2:    ad_raw = ad[127:64];
            3'd3:    ad_raw = ad[63:0];
            default: ad_raw = 64'd0;
        endcase
    end

    // =========================================================================
    // Padding helpers
    //
    // keep_mask : ones over the bytes of the final block that are real data
    // pad_byte  : the single 0x80 byte placed immediately after that data
    //
    // Written as explicit case statements rather than variable shifts so they
    // synthesize to a small constant mux on both FPGA and ASIC flows.
    // =========================================================================
    function [63:0] keep_mask;
        input [2:0] rem;
        begin
            case (rem)
                3'd0: keep_mask = 64'h0000000000000000;
                3'd1: keep_mask = 64'hFF00000000000000;
                3'd2: keep_mask = 64'hFFFF000000000000;
                3'd3: keep_mask = 64'hFFFFFF0000000000;
                3'd4: keep_mask = 64'hFFFFFFFF00000000;
                3'd5: keep_mask = 64'hFFFFFFFFFF000000;
                3'd6: keep_mask = 64'hFFFFFFFFFFFF0000;
                3'd7: keep_mask = 64'hFFFFFFFFFFFFFF00;
            endcase
        end
    endfunction

    function [63:0] pad_byte;
        input [2:0] rem;
        begin
            case (rem)
                3'd0: pad_byte = 64'h8000000000000000;
                3'd1: pad_byte = 64'h0080000000000000;
                3'd2: pad_byte = 64'h0000800000000000;
                3'd3: pad_byte = 64'h0000008000000000;
                3'd4: pad_byte = 64'h0000000080000000;
                3'd5: pad_byte = 64'h0000000000800000;
                3'd6: pad_byte = 64'h0000000000008000;
                3'd7: pad_byte = 64'h0000000000000080;
            endcase
        end
    endfunction

    // Is the block currently indexed by block_cnt the padded final block?
    wire pt_is_last = (block_cnt == pt_full);
    wire ad_is_last = (block_cnt == ad_full);

    // The 64-bit words actually absorbed into the state
    wire [63:0] pt_block = pt_is_last
                         ? ((pt_raw & keep_mask(pt_rem)) | pad_byte(pt_rem))
                         : pt_raw;

    wire [63:0] ad_block = ad_is_last
                         ? ((ad_raw & keep_mask(ad_rem)) | pad_byte(ad_rem))
                         : ad_raw;

    // Ciphertext word for this block, with pad bytes masked out of the output
    wire [63:0] ct_word  = x0 ^ pt_block;
    wire [63:0] ct_out   = pt_is_last ? (ct_word & keep_mask(pt_rem)) : ct_word;

    // =========================================================================
    // Round constant
    // rc[i] = {(0xf - i)[3:0], i[3:0]}
    // e.g. i=0 -> 0xf0, i=6 -> 0x96, i=11 -> 0x4b
    // p6 reuses the LAST six constants of p12, so it starts at round_cnt = 6.
    // =========================================================================
    wire [7:0] rc = {(4'hf - round_cnt), round_cnt};

    // =========================================================================
    // Combinational round function
    // Implements one Ascon permutation round:
    //   1. Add round constant to x2
    //   2. Substitution layer (5-bit S-box in bitsliced form)
    //   3. Linear diffusion layer (sigma)
    //
    // ROR(x, n) for 64-bit x = {x[n-1:0], x[63:n]}
    // =========================================================================
    reg [63:0] nx0, nx1, nx2, nx3, nx4;

    always @(*) begin : round_function
        reg [63:0] s0, s1, s2, s3, s4;
        reg [63:0] t0, t1, t2, t3, t4;

        s0 = x0; s1 = x1; s2 = x2; s3 = x3; s4 = x4;

        // -- Step 1: Add round constant --
        s2 = s2 ^ {56'd0, rc};

        // -- Step 2: Substitution layer --
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

        // Post-mixing (order matters: t1^=t0 must see the old t0)
        t1 = t1 ^ t0;
        t0 = t0 ^ t4;
        t3 = t3 ^ t2;
        t2 = ~t2;

        // -- Step 3: Linear diffusion layer --
        // sigma_0: x0 = t0 ^ ROR(t0,19) ^ ROR(t0,28)
        nx0 = t0 ^ {t0[18:0], t0[63:19]} ^ {t0[27:0], t0[63:28]};

        // sigma_1: x1 = t1 ^ ROR(t1,61) ^ ROR(t1,39)
        nx1 = t1 ^ {t1[60:0], t1[63:61]} ^ {t1[38:0], t1[63:39]};

        // sigma_2: x2 = t2 ^ ROR(t2,1) ^ ROR(t2,6)
        nx2 = t2 ^ {t2[0],    t2[63:1] } ^ {t2[5:0],  t2[63:6] };

        // sigma_3: x3 = t3 ^ ROR(t3,10) ^ ROR(t3,17)
        nx3 = t3 ^ {t3[9:0],  t3[63:10]} ^ {t3[16:0], t3[63:17]};

        // sigma_4: x4 = t4 ^ ROR(t4,7) ^ ROR(t4,41)
        nx4 = t4 ^ {t4[6:0],  t4[63:7] } ^ {t4[40:0], t4[63:41]};
    end

    // =========================================================================
    // Main FSM
    // =========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state           <= S_IDLE;
            busy            <= 1'b0;
            done            <= 1'b0;
            round_cnt       <= 4'd0;
            block_cnt       <= 3'd0;
            next_after_perm <= S_IDLE;
            x0 <= 64'd0; x1 <= 64'd0; x2 <= 64'd0;
            x3 <= 64'd0; x4 <= 64'd0;
            ciphertext      <= 256'd0;
            tag             <= 128'd0;
        end else begin
            done <= 1'b0;  // default: done is a 1-cycle pulse

            case (state)

                // -- Wait for start pulse --
                S_IDLE: begin
                    if (start) begin
                        busy       <= 1'b1;
                        // Clear ciphertext so a shorter operation can never
                        // expose leftover bytes from a previous encryption.
                        ciphertext <= 256'd0;
                        state      <= S_INIT_LOAD;
                    end
                end

                // -- Load S = IV || K0 || K1 || N0 || N1 --
                S_INIT_LOAD: begin
                    x0              <= IV;
                    x1              <= k0;
                    x2              <= k1;
                    x3              <= n0;
                    x4              <= n1;
                    round_cnt       <= 4'd0;         // p12: rounds 0-11
                    next_after_perm <= S_INIT_POST;
                    state           <= S_PERM;
                end

                // -- Generic permutation state: 1 round per cycle --
                S_PERM: begin
                    x0 <= nx0; x1 <= nx1; x2 <= nx2;
                    x3 <= nx3; x4 <= nx4;
                    if (round_cnt == 4'd11) begin
                        state <= next_after_perm;
                    end else begin
                        round_cnt <= round_cnt + 1'b1;
                    end
                end

                // -- Post-init: XOR key into state, then check AD --
                S_INIT_POST: begin
                    x3        <= x3 ^ k0;
                    x4        <= x4 ^ k1;
                    block_cnt <= 3'd0;
                    state     <= S_AD_CHECK;
                end

                // -- Decide if there are more AD blocks to process --
                S_AD_CHECK: begin
                    if ({1'b0, block_cnt} >= ad_blocks)
                        state <= S_AD_DOM;
                    else
                        state <= S_AD_ABSORB;
                end

                // -- Absorb one (padded) AD block into x0, then run p6 --
                S_AD_ABSORB: begin
                    x0              <= x0 ^ ad_block;
                    round_cnt       <= 4'd6;         // p6: rounds 6-11
                    block_cnt       <= block_cnt + 1'b1;
                    next_after_perm <= S_AD_CHECK;
                    state           <= S_PERM;
                end

                // -- Domain separation after all AD --
                S_AD_DOM: begin
                    x4        <= x4 ^ 64'h1;
                    block_cnt <= 3'd0;
                    state     <= S_ENC;
                end

                // -- Encryption: absorb PT block, emit CT, maybe run p6 --
                // pt_blocks is always >= 1, so this always runs at least once.
                S_ENC: begin
                    if ({1'b0, block_cnt} >= pt_blocks) begin
                        // Defensive: unreachable for pt_blocks >= 1
                        state <= S_FIN_XOR;
                    end else begin
                        // Absorb the padded plaintext block
                        x0 <= ct_word;

                        // Ciphertext = new x0, masked to real data bytes.
                        // Block index 4 is pure padding and has no output slot.
                        case (block_cnt)
                            3'd0: ciphertext[255:192] <= ct_out;
                            3'd1: ciphertext[191:128] <= ct_out;
                            3'd2: ciphertext[127:64]  <= ct_out;
                            3'd3: ciphertext[63:0]    <= ct_out;
                            default: ;   // block 4: nothing to emit
                        endcase

                        block_cnt <= block_cnt + 1'b1;

                        if (({1'b0, block_cnt} + 4'd1) < pt_blocks) begin
                            // Not the last block: apply p6 before the next one
                            round_cnt       <= 4'd6;
                            next_after_perm <= S_ENC;
                            state           <= S_PERM;
                        end else begin
                            // Last block: no permutation, go straight to final
                            state <= S_FIN_XOR;
                        end
                    end
                end

                // -- Finalization step 1: XOR key into x1, x2 --
                S_FIN_XOR: begin
                    x1              <= x1 ^ k0;
                    x2              <= x2 ^ k1;
                    round_cnt       <= 4'd0;         // p12: rounds 0-11
                    next_after_perm <= S_FIN_TAG;
                    state           <= S_PERM;
                end

                // -- Finalization step 2: Extract tag --
                S_FIN_TAG: begin
                    tag   <= {x3 ^ k0, x4 ^ k1};
                    state <= S_DONE;
                end

                // -- Signal completion --
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
