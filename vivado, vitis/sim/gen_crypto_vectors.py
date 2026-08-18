#!/usr/bin/env python3
"""Generate vitis/crypto_vectors.h, the vector table used by the Vitis app.

Expected values come from golden.py (Ascon-128) and hashlib (SHA-256), the same
reference the simulation vectors use. Nothing here asks the hardware what the
answer is.

Two modes:

    ./gen_crypto_vectors.py
        Reproduces the original hand-picked set byte for byte: patterned
        messages at the interesting lengths, plus the published SHA-256 KATs
        for "abc" and "hello world". 11 SHA + 7 Ascon.

    ./gen_crypto_vectors.py --random [--seed N] [--n-sha N] [--n-ascon N]
        Random lengths and random message bytes. The boundary lengths that
        historically broke this design are always included regardless (see
        MUST_SHA / MUST_ASC below), then the rest are filled randomly.

        The seed is recorded in the generated header. Reruns with the same seed
        produce identical vectors, so a board failure stays reproducible: note
        the seed from the header, regenerate, and you get the same 50 tests.

Struct layout is fixed by main.c:
    typedef struct { u8 len; u8 msg[32]; u8 digest[32]; } sha_vec_t;
    typedef struct { u8 len; u8 pt[16];  u8 result[32]; } asc_vec_t;

so SHA messages cap at 32 bytes and Ascon plaintexts at 16. Ascon `result` is
the 16-byte ciphertext field (zero padded) followed by the 16-byte tag.
"""
import argparse
import hashlib
import os
import random

from golden import ascon128_encrypt

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "vitis", "crypto_vectors.h")

KEY = bytes(range(16))
NONCE = bytes(range(16))

SHA_MAX = 32   # sizeof msg[]
ASC_MAX = 16   # sizeof pt[]

# Lengths that must always be tested. Every one of these is where a real bug
# lived: 0 hung the receive loop, 8 and 16 are the Ascon rate boundary where
# the padding block was skipped, 32 is where the 5-bit byte_idx wrapped.
MUST_SHA = [0, 8, 16, 32]
MUST_ASC = [0, 8, 16]


def carr(b, width):
    """Format bytes as a C initialiser, zero padded to `width` entries."""
    padded = (bytes(b) + b"\x00" * width)[:width]
    return "{" + ", ".join("0x%02X" % x for x in padded) + "}"


def sha_line(msg):
    d = hashlib.sha256(bytes(msg)).digest()
    return "    {%3d, %s, %s }," % (len(msg), carr(msg, SHA_MAX), carr(d, 32))


def asc_line(pt):
    ct, tag = ascon128_encrypt(KEY, NONCE, b"", bytes(pt))
    res = (ct + b"\x00" * ASC_MAX)[:ASC_MAX] + tag
    return "    {%3d, %s,            %s }," % (
        len(pt), carr(pt, ASC_MAX), carr(res, 32))


def fixed_sets():
    """The original hand-picked vectors, reproduced exactly."""
    sha = [bytes((i * 13 + 5) & 0xFF for i in range(n))
           for n in [0, 1, 3, 8, 15, 16, 17, 31, 32]]
    sha.append(b"abc")            # published SHA-256 KAT
    sha.append(b"hello world")    # published SHA-256 KAT
    asc = [bytes((i * 7 + 3) & 0xFF for i in range(n))
           for n in [0, 1, 7, 8, 9, 15, 16]]
    return sha, asc


def random_sets(rng, n_sha, n_asc):
    """Boundary lengths first, then random lengths with random contents."""
    sha_lens = MUST_SHA + [rng.randrange(0, SHA_MAX + 1)
                           for _ in range(max(0, n_sha - len(MUST_SHA)))]
    asc_lens = MUST_ASC + [rng.randrange(0, ASC_MAX + 1)
                           for _ in range(max(0, n_asc - len(MUST_ASC)))]
    sha = [bytes(rng.randrange(256) for _ in range(n)) for n in sha_lens]
    asc = [bytes(rng.randrange(256) for _ in range(n)) for n in asc_lens]
    # Keep the published known-answer tests in the random set too: they are the
    # only vectors that check this design against the outside world rather than
    # against golden.py.
    sha.append(b"abc")
    return sha, asc


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--random", action="store_true",
                    help="random lengths and contents instead of the fixed set")
    ap.add_argument("--seed", type=int, default=None,
                    help="PRNG seed for --random (default: pick one and record it)")
    ap.add_argument("--n-sha", type=int, default=25,
                    help="number of SHA-256 vectors in --random mode")
    ap.add_argument("--n-ascon", type=int, default=25,
                    help="number of Ascon-128 vectors in --random mode")
    ap.add_argument("-o", "--out", default=OUT, help="output path")
    args = ap.parse_args()

    if args.random:
        seed = args.seed if args.seed is not None else random.randrange(2**31)
        rng = random.Random(seed)
        sha, asc = random_sets(rng, args.n_sha, args.n_ascon)
        provenance = ("Randomly generated, seed=%d. Rerun with --random --seed %d\n"
                      "   to reproduce this exact set." % (seed, seed))
    else:
        sha, asc = fixed_sets()
        provenance = "Fixed hand-picked vectors. Regenerate if the protocol changes."

    L = ["/* Auto-generated golden vectors. %s */" % provenance, ""]
    L.append("#define N_SHA_VEC %d" % len(sha))
    L.append("static const sha_vec_t sha_vec[N_SHA_VEC] = {")
    L += [sha_line(m) for m in sha]
    L.append("};")
    L.append("")
    L.append("#define N_ASC_VEC %d" % len(asc))
    L.append("static const asc_vec_t asc_vec[N_ASC_VEC] = {")
    L += [asc_line(p) for p in asc]
    L.append("};")
    L.append("")
    L.append("static const u8 test_key[16]   = %s;" % carr(KEY, 16))
    L.append("static const u8 test_nonce[16] = %s;" % carr(NONCE, 16))

    with open(args.out, "w") as f:
        f.write("\n".join(L) + "\n")

    print("wrote %s" % os.path.normpath(args.out))
    print("  %d SHA-256 vectors, %d Ascon-128 vectors (%d total)"
          % (len(sha), len(asc), len(sha) + len(asc)))

    # The reference must pass its own known-answer test before its output is
    # trusted as "golden". Same check gen_vectors.py makes.
    _, tag = ascon128_encrypt(KEY, NONCE, b"", b"")
    expect = "E355159F292911F794CB1432A0103A8A"
    got = tag.hex().upper()
    print("  Ascon-128 NIST LWC KAT: %s [%s]"
          % (got, "OK" if got == expect else "MISMATCH"))
    if got != expect:
        raise SystemExit("golden reference failed its own known-answer test")


if __name__ == "__main__":
    main()
