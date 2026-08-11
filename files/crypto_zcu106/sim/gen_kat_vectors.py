#!/usr/bin/env python3
"""Generate vitis/crypto_vectors.h from the OFFICIAL published test vectors.

Unlike gen_crypto_vectors.py, which computes expected values with golden.py,
this script takes them from the standards bodies. Nothing in this repository
decides what the right answer is.

    SHA-256    NIST CAVP, SHA256ShortMsg.rsp (byte-oriented)
               https://csrc.nist.gov/CSRC/media/Projects/
               Cryptographic-Algorithm-Validation-Program/documents/shs/
               shabytetestvectors.zip

    Ascon-128  NIST Lightweight Cryptography KAT for ascon128v12,
               LWC_AEAD_KAT_128_128.txt from the Ascon reference
               implementation
               https://github.com/ascon/ascon-c (tag v1.2)

Why this matters: golden.py and the Verilog could in principle share the same
misreading of a specification and agree with each other while both being wrong.
Vectors published by NIST cannot participate in that mistake.

VARIANT WARNING
    Use the v1.2 tag of ascon-c, not main. Ascon-AEAD128 (NIST SP 800-232) is a
    DIFFERENT algorithm from Ascon-128 v1.2 (the LWC finalist this chip
    implements): it uses nonce 1011..1F and gives tag 4F9C2782.. for empty
    input, where v1.2 uses nonce 0001..0F and gives E355159F.. . This script
    verifies the anchor vector below and refuses to run on the wrong file.

WHAT GETS SELECTED
    The hardware limits what is usable (see the structs in main.c):
      SHA-256    msg[32]  -> CAVP entries with Len <= 256 bits
      Ascon-128  pt[16]   -> KAT entries with empty AD and PT <= 16 bytes
    The KAT files hold 1089 Ascon and 65 CAVP SHA vectors; the rest exceed
    those limits and are skipped.

    The key and nonce are constant across the whole Ascon KAT file and equal
    00 01 02 .. 0F, which is exactly test_key / test_nonce, so no per-vector
    key storage is needed.
"""
import argparse
import hashlib
import os
import sys
import urllib.request
import zipfile

from golden import ascon128_encrypt

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "vitis", "crypto_vectors.h")
CACHE = os.path.join(HERE, ".kat_cache")

ASCON_URL = ("https://raw.githubusercontent.com/ascon/ascon-c/v1.2/"
             "crypto_aead/ascon128v12/LWC_AEAD_KAT_128_128.txt")
SHA_URL = ("https://csrc.nist.gov/CSRC/media/Projects/"
           "Cryptographic-Algorithm-Validation-Program/documents/shs/"
           "shabytetestvectors.zip")

# Anchor vectors. If a downloaded file disagrees with these, it is not the file
# this chip was designed against and the run is aborted.
ASCON_ANCHOR = "E355159F292911F794CB1432A0103A8A"   # empty AD, empty PT, tag
SHA_ANCHOR = "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855"

SHA_MAX = 32   # sizeof sha_vec_t.msg
ASC_MAX = 16   # sizeof asc_vec_t.pt


def fetch(url, path):
    if os.path.exists(path):
        return path
    os.makedirs(os.path.dirname(path), exist_ok=True)
    print("  downloading %s" % os.path.basename(path))
    urllib.request.urlretrieve(url, path)
    return path


def get_ascon_kat(explicit):
    if explicit:
        return explicit
    return fetch(ASCON_URL, os.path.join(CACHE, "LWC_AEAD_KAT_128_128.txt"))


def get_sha_kat(explicit):
    if explicit:
        return explicit
    zp = fetch(SHA_URL, os.path.join(CACHE, "shabytetestvectors.zip"))
    target = os.path.join(CACHE, "SHA256ShortMsg.rsp")
    if not os.path.exists(target):
        with zipfile.ZipFile(zp) as z:
            name = next(n for n in z.namelist() if n.endswith("SHA256ShortMsg.rsp"))
            with z.open(name) as src, open(target, "wb") as dst:
                dst.write(src.read())
    return target


def parse_ascon(path):
    """Yield (pt, ct, tag) for entries with empty AD and PT <= ASC_MAX."""
    rec, out = {}, []
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line:
                if rec:
                    ad = rec.get("AD", "")
                    pt = bytes.fromhex(rec.get("PT", ""))
                    if ad == "" and len(pt) <= ASC_MAX:
                        blob = bytes.fromhex(rec["CT"])
                        out.append((pt, blob[:len(pt)], blob[len(pt):len(pt) + 16]))
                    rec = {}
                continue
            if "=" in line:
                k, _, v = line.partition("=")
                rec[k.strip()] = v.strip()
    return out


def parse_sha(path):
    """Yield (msg, digest) for CAVP entries with Len <= SHA_MAX bytes."""
    rec, out = {}, []
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or line.startswith("["):
                continue
            if "=" in line:
                k, _, v = line.partition("=")
                rec[k.strip()] = v.strip()
                if k.strip() == "MD":
                    nbits = int(rec["Len"])
                    # CAVP writes "Msg = 00" for the zero-length case; the byte
                    # is a placeholder, not data.
                    msg = b"" if nbits == 0 else bytes.fromhex(rec["Msg"])
                    if len(msg) * 8 == nbits and len(msg) <= SHA_MAX:
                        out.append((msg, bytes.fromhex(rec["MD"])))
                    rec = {}
    return out


def carr(b, width):
    padded = (bytes(b) + b"\x00" * width)[:width]
    return "{" + ", ".join("0x%02X" % x for x in padded) + "}"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ascon-kat", help="local LWC_AEAD_KAT_128_128.txt (v1.2)")
    ap.add_argument("--sha-kat", help="local SHA256ShortMsg.rsp")
    ap.add_argument("-o", "--out", default=OUT)
    args = ap.parse_args()

    print("Reading official known-answer tests:")
    asc = parse_ascon(get_ascon_kat(args.ascon_kat))
    sha = parse_sha(get_sha_kat(args.sha_kat))

    if not asc or not sha:
        raise SystemExit("no usable vectors parsed -- wrong file format?")

    # -- Anchor checks: confirm these are the files this chip targets --------
    a_tag = asc[0][2].hex().upper()
    if a_tag != ASCON_ANCHOR:
        raise SystemExit(
            "Ascon KAT anchor mismatch.\n  got      %s\n  expected %s\n"
            "This is probably Ascon-AEAD128 (SP 800-232) rather than\n"
            "Ascon-128 v1.2. Use the v1.2 tag of ascon-c." % (a_tag, ASCON_ANCHOR))
    if sha[0][1].hex().upper() != SHA_ANCHOR:
        raise SystemExit("SHA CAVP anchor mismatch -- unexpected file")
    print("  anchors OK (Ascon %s..., SHA %s...)" % (a_tag[:8], SHA_ANCHOR[:8]))

    # -- Cross-check the local reference against the published values --------
    # These must agree. A disagreement means either golden.py is wrong or the
    # file was parsed wrong, and either way the output cannot be trusted.
    for pt, ct, tag in asc:
        g_ct, g_tag = ascon128_encrypt(bytes(range(16)), bytes(range(16)), b"", pt)
        if g_ct != ct or g_tag != tag:
            raise SystemExit("golden.py disagrees with the NIST KAT at pt_len=%d"
                             % len(pt))
    for msg, md in sha:
        if hashlib.sha256(msg).digest() != md:
            raise SystemExit("hashlib disagrees with CAVP at len=%d" % len(msg))
    print("  cross-check OK: golden.py and hashlib agree with all %d vectors"
          % (len(asc) + len(sha)))

    L = ["/* Auto-generated from OFFICIAL published known-answer tests.",
         " *   SHA-256    NIST CAVP SHA256ShortMsg.rsp",
         " *   Ascon-128  NIST LWC KAT, ascon128v12 (Ascon-128 v1.2)",
         " * Expected values come from the standards bodies, not from golden.py.",
         " * Regenerate with sim/gen_kat_vectors.py */",
         ""]
    L.append("#define N_SHA_VEC %d" % len(sha))
    L.append("static const sha_vec_t sha_vec[N_SHA_VEC] = {")
    L += ["    {%3d, %s, %s }," % (len(m), carr(m, SHA_MAX), carr(d, 32))
          for m, d in sha]
    L.append("};")
    L.append("")
    L.append("#define N_ASC_VEC %d" % len(asc))
    L.append("static const asc_vec_t asc_vec[N_ASC_VEC] = {")
    L += ["    {%3d, %s,            %s }," %
          (len(p), carr(p, ASC_MAX), carr((c + b"\x00" * 16)[:16] + t, 32))
          for p, c, t in asc]
    L.append("};")
    L.append("")
    L.append("static const u8 test_key[16]   = %s;" % carr(bytes(range(16)), 16))
    L.append("static const u8 test_nonce[16] = %s;" % carr(bytes(range(16)), 16))

    with open(args.out, "w") as f:
        f.write("\n".join(L) + "\n")

    print("\nwrote %s" % os.path.normpath(args.out))
    print("  %d SHA-256 + %d Ascon-128 = %d official vectors"
          % (len(sha), len(asc), len(sha) + len(asc)))


if __name__ == "__main__":
    sys.exit(main())
