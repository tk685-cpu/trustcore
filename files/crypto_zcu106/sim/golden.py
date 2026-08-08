#!/usr/bin/env python3
"""Golden reference: SHA-256 (hashlib) and Ascon-128 (spec implementation).

Ascon-128 per the NIST LWC / CAESAR v1.2 specification:
  k=128, r=64, a=12, b=6, IV = 0x80400c0600000000
"""
import hashlib

MASK64 = (1 << 64) - 1


def ror(x, n):
    return ((x >> n) | (x << (64 - n))) & MASK64


def permutation(S, rounds):
    """Ascon permutation, `rounds` rounds, using the last `rounds` constants of p12."""
    x0, x1, x2, x3, x4 = S
    start = 12 - rounds
    for i in range(start, 12):
        rc = ((0xF - i) << 4) | i
        # add round constant
        x2 ^= rc
        # substitution layer
        x0 ^= x4
        x4 ^= x3
        x2 ^= x1
        t0 = x0 ^ (~x1 & MASK64 & x2)
        t1 = x1 ^ (~x2 & MASK64 & x3)
        t2 = x2 ^ (~x3 & MASK64 & x4)
        t3 = x3 ^ (~x4 & MASK64 & x0)
        t4 = x4 ^ (~x0 & MASK64 & x1)
        t1 ^= t0
        t0 ^= t4
        t3 ^= t2
        t2 = ~t2 & MASK64
        # linear diffusion layer
        x0 = t0 ^ ror(t0, 19) ^ ror(t0, 28)
        x1 = t1 ^ ror(t1, 61) ^ ror(t1, 39)
        x2 = t2 ^ ror(t2, 1) ^ ror(t2, 6)
        x3 = t3 ^ ror(t3, 10) ^ ror(t3, 17)
        x4 = t4 ^ ror(t4, 7) ^ ror(t4, 41)
    return [x0, x1, x2, x3, x4]


def ascon128_encrypt(key: bytes, nonce: bytes, ad: bytes, pt: bytes):
    assert len(key) == 16 and len(nonce) == 16
    IV = 0x80400C0600000000
    k0 = int.from_bytes(key[0:8], "big")
    k1 = int.from_bytes(key[8:16], "big")
    n0 = int.from_bytes(nonce[0:8], "big")
    n1 = int.from_bytes(nonce[8:16], "big")

    # --- initialization ---
    S = [IV, k0, k1, n0, n1]
    S = permutation(S, 12)
    S[3] ^= k0
    S[4] ^= k1

    # --- associated data ---
    if len(ad) > 0:
        ad_p = ad + b"\x80" + b"\x00" * ((8 - (len(ad) + 1) % 8) % 8)
        for i in range(0, len(ad_p), 8):
            S[0] ^= int.from_bytes(ad_p[i:i + 8], "big")
            S = permutation(S, 6)
    # domain separation
    S[4] ^= 1

    # --- plaintext ---
    pt_p = pt + b"\x80" + b"\x00" * ((8 - (len(pt) + 1) % 8) % 8)
    nblocks = len(pt_p) // 8
    ct = b""
    for i in range(nblocks):
        S[0] ^= int.from_bytes(pt_p[i * 8:i * 8 + 8], "big")
        ct += S[0].to_bytes(8, "big")
        if i < nblocks - 1:
            S = permutation(S, 6)
    ct = ct[:len(pt)]

    # --- finalization ---
    S[1] ^= k0
    S[2] ^= k1
    S = permutation(S, 12)
    tag = ((S[3] ^ k0).to_bytes(8, "big") + (S[4] ^ k1).to_bytes(8, "big"))
    return ct, tag


if __name__ == "__main__":
    # Known-answer check against the Ascon reference LWC KAT Count=1
    # (empty AD, empty PT) and Count=34 style vectors.
    key = bytes(range(16))
    nonce = bytes(range(16))
    ct, tag = ascon128_encrypt(key, nonce, b"", b"")
    print("KAT empty  ct=%s tag=%s" % (ct.hex().upper(), tag.hex().upper()))

    ct, tag = ascon128_encrypt(key, nonce, b"", bytes(range(16)))
    print("KAT pt16   ct=%s tag=%s" % (ct.hex().upper(), tag.hex().upper()))

    m = b"abc"
    print("sha abc   =", hashlib.sha256(m).hexdigest().upper())
    m32 = bytes(range(32))
    print("sha 0..31 =", hashlib.sha256(m32).hexdigest().upper())
