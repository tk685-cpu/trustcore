#!/usr/bin/env python3
"""
plot_ppa.py - Plot Frequency vs Area and Frequency vs Power as two
              SEPARATE graphs, from manually-entered data.

Two ways to provide data:

1) Edit the DATA list below directly with your numbers, then run:
       python3 plot_ppa.py --out_prefix ppa

2) Or enter the numbers interactively when prompted:
       python3 plot_ppa.py --interactive --out_prefix ppa

This produces two files:
    <out_prefix>_area.png
    <out_prefix>_power.png
"""

import argparse
import matplotlib.pyplot as plt

# ---------------------------------------------------------------------------
# EDIT THIS: put your own (frequency_MHz, area, power_uW) numbers here.
# Leave area or power as None if you don't have that value for a given point.
# ---------------------------------------------------------------------------
DATA = [
    # (freq_MHz, area, power_uW)          # slack (ps)
    (35,  8496018, 7.09878e-01),           # 12344
    (45,  8484750, 9.15248e-01),           # 5721
    (50,  8490303, 1.02646e+00),           # 3838
    (55,  8471475, 1.14235e+00),           # 2336
    (60,  8491995, 1.24825e+00),           # 820
    (65,  8488584, 1.33629e+00),           # 283
    (70,  8491437, 1.44552e+00),           # 26
    (75,  8477370, 1.56587e+00),           # 2
    (100, 8546886, 2.08683e+00),           # 103
    (125, 8593497, 2.59713e+00),           # 6
    (150, 8625303, 3.12833e+00),           # 0
    (175, 8723484, 3.59796e+00),           # -157
    (200, 8805528, 4.19498e+00),           # -698
]


def get_interactive_data():
    print("Enter your data one frequency at a time.")
    print("Type just 'done' at the frequency prompt when finished.\n")
    data = []
    while True:
        freq_str = input("Frequency (MHz): ").strip()
        if freq_str.lower() == "done":
            break
        try:
            freq = float(freq_str)
        except ValueError:
            print("  Not a number, try again.")
            continue

        area_str = input("  Area: ").strip()
        area = float(area_str) if area_str else None

        power_str = input("  Power (uW): ").strip()
        power = float(power_str) if power_str else None

        data.append((freq, area, power))
        print()
    return data


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--interactive", action="store_true",
                     help="enter data by hand at the prompt instead of editing DATA in the script")
    ap.add_argument("--out_prefix", default="ppa",
                     help="prefix for output image filenames (produces <prefix>_area.png and <prefix>_power.png)")
    args = ap.parse_args()

    data = get_interactive_data() if args.interactive else DATA

    # keep only rows that have at least one of area/power filled in
    data = [d for d in data if d[1] is not None or d[2] is not None]
    if not data:
        raise SystemExit("No data provided. Fill in the DATA list or use --interactive.")

    data.sort(key=lambda d: d[0])
    freqs = [d[0] for d in data]
    areas = [d[1] for d in data]
    powers = [d[2] for d in data]

    print("Freq(MHz)   Area        Power(uW)")
    for f, a, p in zip(freqs, areas, powers):
        print(f"{f:>8}   {str(a):>10}   {str(p):>10}")

    # --- Graph 1: Area vs Frequency ---
    if any(a is not None for a in areas):
        areas_scaled = [a / 1e6 if a is not None else None for a in areas]
        fig1, ax1 = plt.subplots(figsize=(7, 5))
        ax1.plot(freqs, areas_scaled, marker="o", color="tab:blue")
        ax1.set_xlabel("Frequency (MHz)")
        ax1.set_ylabel("Area (x10^6)")
        ax1.set_title("Area vs Frequency")
        ax1.grid(True, linestyle="--", alpha=0.5)
        fig1.tight_layout()
        area_out = f"{args.out_prefix}_area.png"
        fig1.savefig(area_out, dpi=150)
        print(f"Saved {area_out}")
    else:
        print("No area data provided, skipping area plot.")

    # --- Graph 2: Power vs Frequency ---
    if any(p is not None for p in powers):
        fig2, ax2 = plt.subplots(figsize=(7, 5))
        ax2.plot(freqs, powers, marker="s", color="tab:red")
        ax2.set_xlabel("Frequency (MHz)")
        ax2.set_ylabel("Power (uW)")
        ax2.set_title("Power vs Frequency")
        ax2.grid(True, linestyle="--", alpha=0.5)
        fig2.tight_layout()
        power_out = f"{args.out_prefix}_power.png"
        fig2.savefig(power_out, dpi=150)
        print(f"Saved {power_out}")
    else:
        print("No power data provided, skipping power plot.")


if __name__ == "__main__":
    main()

