#include <stdio.h>
#include "sha256.h"

int main() {
    uint8_t digest[32];
    sha256_hash((const uint8_t*)"abc", 3, digest);
    printf("SHA256(\"abc\") = ");
    for (int i = 0; i < 32; i++) printf("%02x", digest[i]);
    printf("\n");
    printf("expected       = ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015\n");

    // empty string test vector
    sha256_hash((const uint8_t*)"", 0, digest);
    printf("SHA256(\"\")    = ");
    for (int i = 0; i < 32; i++) printf("%02x", digest[i]);
    printf("\n");
    printf("expected       = e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855\n");
    return 0;
}
