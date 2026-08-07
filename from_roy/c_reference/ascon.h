#ifndef ASCON_H
#define ASCON_H

#include <stdint.h>
#include <stddef.h>

// ---- Ascon-Hash256 ----
// 256-bit output digest, rate = 8 bytes (64 bits), 12/12-round permutation.
#define ASCON_HASH_DIGEST_SIZE 32

typedef struct {
    uint64_t x[5];   // 320-bit permutation state
} ascon_hash_ctx_t;

void ascon_hash_init(ascon_hash_ctx_t *ctx);
void ascon_hash_update(ascon_hash_ctx_t *ctx, const uint8_t *data, size_t len);
void ascon_hash_final(ascon_hash_ctx_t *ctx, uint8_t digest[ASCON_HASH_DIGEST_SIZE]);
void ascon_hash(const uint8_t *data, size_t len, uint8_t digest[ASCON_HASH_DIGEST_SIZE]);

// ---- Ascon-AEAD128 ----
// 128-bit key, 128-bit nonce, 128-bit authentication tag.
#define ASCON_KEY_SIZE   16
#define ASCON_NONCE_SIZE 16
#define ASCON_TAG_SIZE   16

// Encrypts `pt_len` bytes of plaintext, producing `pt_len` bytes of
// ciphertext plus a 16-byte tag. Associated data (ad) is authenticated
// but not encrypted (may be zero-length).
void ascon_aead_encrypt(
    const uint8_t key[ASCON_KEY_SIZE],
    const uint8_t nonce[ASCON_NONCE_SIZE],
    const uint8_t *ad, size_t ad_len,
    const uint8_t *pt, size_t pt_len,
    uint8_t *ct,                     // output, same length as pt
    uint8_t tag[ASCON_TAG_SIZE]      // output
);

// Returns 1 if the tag is valid (authentic) and writes plaintext to `pt`,
// or 0 if authentication fails (in which case `pt` must be discarded).
int ascon_aead_decrypt(
    const uint8_t key[ASCON_KEY_SIZE],
    const uint8_t nonce[ASCON_NONCE_SIZE],
    const uint8_t *ad, size_t ad_len,
    const uint8_t *ct, size_t ct_len,
    const uint8_t tag[ASCON_TAG_SIZE],
    uint8_t *pt                      // output, same length as ct
);

#endif // ASCON_H
