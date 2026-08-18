#!/usr/bin/env python3
"""Generate all testbench vector include files from the golden reference.

Run this before the simulations; run_sim.sh does it automatically.
Outputs, alongside this script:
    sha_vectors.vh    unit test for sha256.v
    ascon_vectors.vh  unit test for ascon128.v
    chip_vectors.vh   end-to-end test through the SPI pins
    axi_vectors.vh    end-to-end test through the AXI4-Lite bus
"""
import hashlib
import os

from golden import ascon128_encrypt

HERE = os.path.dirname(os.path.abspath(__file__))

KEY = bytes(range(16))
NONCE = bytes(range(16))


def pad_hex(b, n=32):
    """Left-align b in an n-byte field and return it as uppercase hex."""
    return ((b + b"\x00" * n)[:n]).hex().upper()


def write(name, lines):
    path = os.path.join(HERE, name)
    with open(path, "w") as f:
        f.write("\n".join(lines) + "\n")
    print("  %-20s %d vectors" % (name, len(lines)))


# ---------------------------------------------------------------------------
# sha_vectors.vh
# ---------------------------------------------------------------------------
def gen_sha():
    L = []
    for n in range(0, 33):
        m = bytes((i * 7 + 3) & 0xFF for i in range(n))
        L.append("run(256'h%s, 8'd%d, 256'h%s);"
                 % (pad_hex(m), n, hashlib.sha256(m).hexdigest().upper()))
    for s in [b"abc", b"hello world", b"The quick brown fox jumps over"]:
        L.append("run(256'h%s, 8'd%d, 256'h%s);"
                 % (pad_hex(s), len(s), hashlib.sha256(s).hexdigest().upper()))
    write("sha_vectors.vh", L)


# ---------------------------------------------------------------------------
# ascon_vectors.vh
# ---------------------------------------------------------------------------
def gen_ascon():
    L = []
    cases = [(n, 0) for n in range(0, 33)]
    cases += [(16, 8), (16, 5), (8, 16), (0, 3)]
    for plen, alen in cases:
        pt = bytes((i * 7 + 3) & 0xFF for i in range(plen))
        ad = bytes((i * 11 + 1) & 0xFF for i in range(alen))
        ct, tag = ascon128_encrypt(KEY, NONCE, ad, pt)
        L.append("run(256'h%s, 8'd%d, 256'h%s, 8'd%d, 256'h%s, 128'h%s);"
                 % (pad_hex(pt), plen, pad_hex(ad), alen,
                    pad_hex(ct), tag.hex().upper()))
    write("ascon_vectors.vh", L)


# ---------------------------------------------------------------------------
# chip_vectors.vh
# ---------------------------------------------------------------------------
def gen_chip():
    L = []
    for n in [0, 1, 2, 3, 7, 8, 15, 16, 17, 23, 24, 31, 32]:
        m = bytes((i * 13 + 5) & 0xFF for i in range(n))
        L.append("do_sha(256'h%s, 8'd%d, 256'h%s);"
                 % (pad_hex(m), n, hashlib.sha256(m).hexdigest().upper()))
    for s in [b"abc", b"hello world"]:
        L.append("do_sha(256'h%s, 8'd%d, 256'h%s);"
                 % (pad_hex(s), len(s), hashlib.sha256(s).hexdigest().upper()))

    for n in [0, 1, 4, 7, 8, 9, 15, 16]:
        pt = bytes((i * 7 + 3) & 0xFF for i in range(n))
        ct, tag = ascon128_encrypt(KEY, NONCE, b"", pt)
        res = (ct + b"\x00" * 16)[:16] + tag
        L.append("do_ascon(128'h%s, 128'h%s, 256'h%s, 8'd%d, 256'h%s);"
                 % (KEY.hex().upper(), NONCE.hex().upper(),
                    pad_hex(pt), n, res.hex().upper()))

    k2 = bytes.fromhex("0F1E2D3C4B5A69788796A5B4C3D2E1F0")
    n2 = bytes.fromhex("FEDCBA98765432100123456789ABCDEF")
    pt = b"SecretMsg"
    ct, tag = ascon128_encrypt(k2, n2, b"", pt)
    res = (ct + b"\x00" * 16)[:16] + tag
    L.append("do_ascon(128'h%s, 128'h%s, 256'h%s, 8'd%d, 256'h%s);"
             % (k2.hex().upper(), n2.hex().upper(),
                pad_hex(pt), len(pt), res.hex().upper()))

    # negative tests, then a good vector to prove the chip recovers
    L.append("do_bad_cmd(8'h55, 8'd4);")     # unrecognised command
    L.append("do_bad_cmd(8'h01, 8'd40);")    # SHA length above 32
    L.append("do_bad_cmd(8'h02, 8'd20);")    # Ascon length above 16
    L.append("do_abort;")
    L.append("do_sha(256'h%s, 8'd3, 256'h%s);"
             % (pad_hex(b"abc"), hashlib.sha256(b"abc").hexdigest().upper()))
    write("chip_vectors.vh", L)


# ---------------------------------------------------------------------------
# axi_vectors.vh  (smaller set: AXI register polling makes each vector slow)
# ---------------------------------------------------------------------------
def gen_axi():
    L = []
    for n in [0, 3, 8, 17, 32]:
        m = bytes((i * 13 + 5) & 0xFF for i in range(n))
        L.append("do_sha(256'h%s, 8'd%d, 256'h%s);"
                 % (pad_hex(m), n, hashlib.sha256(m).hexdigest().upper()))
    for n in [0, 7, 8, 16]:
        pt = bytes((i * 7 + 3) & 0xFF for i in range(n))
        ct, tag = ascon128_encrypt(KEY, NONCE, b"", pt)
        res = (ct + b"\x00" * 16)[:16] + tag
        L.append("do_ascon(128'h%s, 128'h%s, 256'h%s, 8'd%d, 256'h%s);"
                 % (KEY.hex().upper(), NONCE.hex().upper(),
                    pad_hex(pt), n, res.hex().upper()))
    write("axi_vectors.vh", L)


if __name__ == "__main__":
    print("Generating testbench vectors:")
    gen_sha()
    gen_ascon()
    gen_chip()
    gen_axi()

    # Sanity check the golden reference against the published NIST LWC KAT
    ct, tag = ascon128_encrypt(KEY, NONCE, b"", b"")
    expect = "E355159F292911F794CB1432A0103A8A"
    got = tag.hex().upper()
    status = "OK" if got == expect else "MISMATCH"
    print("\nAscon-128 NIST LWC KAT (empty AD, empty PT): %s  [%s]"
          % (got, status))
    if status != "OK":
        raise SystemExit("golden reference failed its own known-answer test")
