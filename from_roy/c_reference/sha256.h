#ifndef SHA256_H
#define SHA256_H

#include <stdint.h>
#include <stddef.h>

#define SHA256_BLOCK_SIZE 64   // 512 bits, one input block
#define SHA256_DIGEST_SIZE 32  // 256 bits, output digest

typedef struct {
    uint32_t state[8];      // current hash state (H0..H7)
    uint64_t bitlen;        // total message length in bits
    uint8_t  buffer[64];    // partial block buffer
    uint32_t buffer_len;    // bytes currently in buffer
} sha256_ctx_t;

// Streaming API — mirrors the hardware's block-by-block processing.
void sha256_init(sha256_ctx_t *ctx);
void sha256_update(sha256_ctx_t *ctx, const uint8_t *data, size_t len);
void sha256_final(sha256_ctx_t *ctx, uint8_t digest[SHA256_DIGEST_SIZE]);

// Convenience one-shot wrapper.
void sha256_hash(const uint8_t *data, size_t len, uint8_t digest[SHA256_DIGEST_SIZE]);

#endif // SHA256_H
