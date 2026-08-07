#include <stdio.h>
#include <string.h>
#include "ascon.h"

int main() {
    // Self-consistency test: encrypt then decrypt, check round-trip and tag validity.
    uint8_t key[16]   = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f};
    uint8_t nonce[16] = {0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1a,0x1b,0x1c,0x1d,0x1e,0x1f};
    uint8_t pt[20] = "TrustCore-v1 PoC!!!"; // 19 chars + implicit null not included, len=19
    size_t pt_len = 19;
    uint8_t ct[19];
    uint8_t tag[16];
    uint8_t recovered[19];

    ascon_aead_encrypt(key, nonce, NULL, 0, pt, pt_len, ct, tag);

    printf("plaintext : %.*s\n", (int)pt_len, pt);
    printf("ciphertext: ");
    for (size_t i = 0; i < pt_len; i++) printf("%02x", ct[i]);
    printf("\n");
    printf("tag       : ");
    for (int i = 0; i < 16; i++) printf("%02x", tag[i]);
    printf("\n");

    int ok = ascon_aead_decrypt(key, nonce, NULL, 0, ct, pt_len, tag, recovered);
    printf("decrypt auth result: %s\n", ok ? "VALID" : "INVALID");
    printf("recovered : %.*s\n", (int)pt_len, recovered);
    printf("round-trip match: %s\n", (memcmp(pt, recovered, pt_len) == 0) ? "YES" : "NO");

    // Tamper test: flip a bit in ciphertext, confirm auth fails
    ct[0] ^= 0x01;
    int ok2 = ascon_aead_decrypt(key, nonce, NULL, 0, ct, pt_len, tag, recovered);
    printf("tampered ciphertext auth result: %s (expect INVALID)\n", ok2 ? "VALID" : "INVALID");

    // Ascon-Hash256 basic smoke test (no official vector cross-check here)
    uint8_t digest[32];
    ascon_hash((const uint8_t*)"abc", 3, digest);
    printf("Ascon-Hash256(\"abc\") = ");
    for (int i = 0; i < 32; i++) printf("%02x", digest[i]);
    printf("\n");

    return 0;
}
