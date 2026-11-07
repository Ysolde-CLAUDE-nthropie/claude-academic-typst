"""Regenerate the matplotlib figure used in examples/report.typ.

    python examples/figures/make_figures.py
"""
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent.parent / "scripts"))

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

import plot_style

plot_style.use()

# Synthetic data, for layout only.
shift = np.linspace(0, 1, 40)
ece_raw = 9.8 + 7.4 * shift**1.3
ece_scaled = 2.1 + 9.7 * shift**1.6
gap = 0.3 + 9.6 * shift**1.6

fig, axes = plt.subplots(1, 2, figsize=(plot_style.FULL_WIDTH, 2.3))

ax = axes[0]
ax.plot(shift, ece_raw, label="Raw")
ax.plot(shift, ece_scaled, label="Temperature-scaled")
ax.plot(shift, gap, color=plot_style.COLORS["ink_soft"], linestyle=(0, (2, 1.6)), linewidth=1, label="Shift gap")
ax.set_title("Calibration error vs. shift severity")
ax.set_xlabel("Shift severity")
ax.set_ylabel("ECE (pp)")
ax.set_ylim(0, 18)
ax.legend(loc="upper left")

ax = axes[1]
conditions = ["In dist.", "Paraphr.", "Domain", "Adversarial"]
values = [2.1, 3.0, 6.4, 11.8]
colors = [plot_style.COLORS["oat"]] * 3 + [plot_style.COLORS["clay"]]
ax.bar(conditions, values, width=0.62, color=colors)
for i, v in enumerate(values):
    ax.text(i, v + 0.35, f"{v:.1f}", ha="center", va="bottom", fontsize=7, color=plot_style.COLORS["ink_soft"])
ax.set_title("Scaled ECE by condition")
ax.set_ylim(0, 14)

fig.tight_layout(w_pad=2.5)
fig.savefig(HERE / "shift.svg")
print("wrote", HERE / "shift.svg")
