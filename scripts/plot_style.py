"""Matplotlib style for claude-academic figures.

    import sys; sys.path.insert(0, "<skill-dir>/scripts")
    import plot_style
    plot_style.use()                      # registers bundled fonts, applies the style
    fig, ax = plt.subplots()              # 5.6 x 2.9 in: full text width
    ...
    fig.savefig("figure.svg")             # then: image("figure.svg", width: 100%)

Use `plot_style.COLORS` for named colours and `plot_style.CYCLE` for series order.
"""
from pathlib import Path

import matplotlib as mpl
from matplotlib import font_manager

ROOT = Path(__file__).resolve().parent.parent

COLORS = {
    "ink": "#141413",
    "ink_soft": "#3D3D3A",
    "muted": "#73726C",
    "rule": "#D6D3C8",
    "paper": "#FAF9F5",
    "ivory": "#F0EEE6",
    "oat": "#E6E3D8",
    "clay": "#D97757",
    "clay_deep": "#B9532F",
    "clay_tint": "#F4E4DA",
    "sky": "#6A9BCC",
    "olive": "#788C5D",
    "kraft": "#D4A27F",
    "fig": "#C46686",
    "slate": "#5E5D59",
}

# Series order. Lead with clay; keep to three or four series where possible.
CYCLE = [COLORS[k] for k in ("clay", "sky", "olive", "kraft", "fig", "slate")]

FULL_WIDTH = 5.6  # inches: full text width of an A4 claude-academic page
HALF_WIDTH = 2.7  # inches: one of two side-by-side panels


def use():
    """Register the bundled fonts and apply the claude-academic style."""
    for font in sorted((ROOT / "fonts").glob("*.ttf")):
        font_manager.fontManager.addfont(str(font))
    mpl.style.use(str(ROOT / "assets" / "claude-academic.mplstyle"))
