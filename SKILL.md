---
name: claude-academic-typst
description: Typeset polished academic-style PDF reports (papers, technical reports, research notes, white papers, literature reviews, thesis chapters) with Typst in a Claude-inspired house style. The look is warm ivory paper, one clay accent, classical serif type, and solid colour fills instead of borders, combined with LaTeX conventions such as numbered sections, amsthm-style theorems, numbered equations, booktabs tables, footnotes, and a BibTeX bibliography. Use whenever the user wants a print-quality PDF document or report, asks for "LaTeX-quality" output without LaTeX, or asks for this visual style. Bundles fonts, a template, a matplotlib style, and build scripts, so output is the same on every machine.
---

# claude-academic-typst

A Typst template and workflow for academic PDF reports that look the same on every machine. The style is fixed on purpose. Your job is the content, the structure, and checking the rendered pages, not redesigning the template.

`SKILL` below means the directory that contains this file.

## Quick start

```bash
bash $SKILL/scripts/new.sh report              # creates report/main.typ, report/refs.bib, report/claude-academic/
# … write report/main.typ …
bash $SKILL/scripts/build.sh report/main.typ --png
#   → report/main.pdf and report/main-page-1.png, -2.png, …
```

`build.sh` installs a pinned Typst if none ≥ 0.13 is present and always passes `--font-path $SKILL/fonts`. **Always build through `build.sh`** (or pass `--font-path $SKILL/fonts` yourself). Without the bundled fonts the PDF falls back to other typefaces and the style is lost. Any `unknown font family` warning means this has happened.

## Workflow

1. **Scaffold** with `new.sh`. It copies the template into the project, so the project builds on its own.
2. **Fill the metadata** in `#show: report.with(...)`: title, authors, date, abstract, keywords. Decide `cover`, `toc`, and `title-style` now (see the table below).
3. **Write the body** in Typst markup using the components below. If you think in LaTeX, read `references/latex-to-typst.md` first. Math and escaping differ in ways that fail silently.
4. **Make figures.** For data plots, use matplotlib with `scripts/plot_style.py` and save as SVG. For simple diagrams, Typst shapes work. Tables are plain `table(...)` inside `figure(...)`; the booktabs styling is automatic.
5. **Build with `--png` and look at every page image.** Check the list under "Before you deliver". Fix the source and rebuild until it is clean.
6. **Deliver the PDF.** Mention any assumption you made, for example invented placeholder numbers.

## Document skeleton

```typst
#import "claude-academic/lib.typ": *

#show: report.with(
  title: [Calibrated Confidence under Distribution Shift],
  subtitle: [An optional one-line subtitle],
  short-title: [Calibration under shift],      // running head; optional
  kind: [Technical report],                    // eyebrow label; optional
  authors: (
    (name: "Ada Whitfield", affiliation: "Institute for Careful Machines", email: "ada@icm.example"),
    (name: "Mei Lin Sato", affiliation: ("Northbridge University", "Institute for Careful Machines")),
  ),
  date: auto,                                  // today; or datetime(...), or [Spring 2027], or none
  abstract: [One paragraph, 120–200 words.],
  keywords: ("calibration", "distribution shift"),
)

= Introduction <sec-intro>
Text with a citation @guo2017 and a cross-reference to @sec-method.

= Method <sec-method>
...

#bibliography("refs.bib")

#show: appendix          // optional: later level-1 headings become A, B, …
= Proofs <sec-proofs>
```

### `report` options

| Option | Default | Use |
|---|---|---|
| `title-style` | `"modern"` | `"classic"` gives a centred LaTeX `\maketitle` look with a plain abstract. Use it for papers that should feel conventional. |
| `cover` | `false` | Adds a full cover page (ivory with a clay band). Use it for reports of 8+ pages or for documents handed to people outside the field. |
| `toc` | `false` | Adds a table of contents after the abstract, then a page break. Use it for 10+ pages. |
| `tint` | `true` | Ivory page background. Set `false` for documents that will be printed. |
| `paper` | `"a4"` | `"us-letter"` for US audiences. |
| `lang` | `"en"` | `"zh"` switches interface labels to Chinese (摘要, 定理, 参考文献…) and uses two-character paragraph indents. |
| `fallback-fonts` | `()` | Fonts appended to every family, for scripts the bundled fonts lack. For Chinese use `("Noto Serif CJK SC",)` or whatever `typst fonts` lists. |
| `font-size` | `10.5pt` | Leave it alone unless the user asks. |

## Components

All of these come from `#import "claude-academic/lib.typ": *`. Full signatures are in `references/components.md`.

| Need | Write |
|---|---|
| Section / subsection / subsubsection | `= Title <sec-x>` / `== Title` / `=== Title` (keep to three levels) |
| Unnumbered section | `#heading(numbering: none)[Acknowledgments]` |
| Numbered equation | `$ E = m c^2 $ <eq-x>` (spaces inside `$ … $` make it display) |
| Unnumbered display equation | `#nonumber($ a = b $)` |
| Theorem-like | `#theorem(title: [Name])[…] <thm-x>`, plus `lemma`, `proposition`, `corollary`, `conjecture`, `definition`, `assumption`, `example`, `remark` (one shared counter, numbered per section) |
| Proof | `#proof[…]` ends with a clay square |
| Figure | `#figure(image("fig.svg", width: 100%), caption: […]) <fig-x>` |
| Table (booktabs) | `#figure(table(columns: 3, table.header[A][B][C], …), caption: […]) <tab-x>` |
| Highlighted box | `#callout(title: [Key finding])[…]`, with `tone: "neutral"` (default), `"accent"`, or `"solid"` |
| Headline numbers | `#stats((value: "9.8%", label: "Raw ECE"), (value: "2.1%", label: "Scaled ECE"))` |
| Display quote | `#pullquote(attribution: [Source])[…]` |
| Footnote | `#footnote[…]` |
| Citation | `@key` or `#cite(<key>, form: "prose")`, with `#bibliography("refs.bib")` at the end |
| Code | fenced ` ```python … ``` ` (themed automatically); inline `` `x` `` |
| Appendix | `#show: appendix` after the bibliography |
| Colours for custom drawing | `palette.clay`, `palette.ink`, `palette.ivory`, … and `chart-colors` |

## Style rules

The template handles typography. These rules cover the decisions it cannot make for you.

**Restraint with the accent.** Clay marks what matters, so keep it rare:
- Use at most one `callout` per page and one `stats` row per document. Use `tone: "solid"` at most once, if ever.
- In charts, lead with clay for the main series. If one bar is the point, make it clay and the rest `palette.oat`.
- Never colour running text. Do not add `#text(fill: …)`, highlights, or emoji.

**Do not restyle.** Do not add `set text(font: …)`, `set page(…)`, `set par(…)`, or new colours. Do not wrap things in boxes with borders. If something looks wrong, fix the content (shorter caption, smaller figure, different break), not the template.

**Academic voice and structure.**
- Use sentence case for headings ("Related work", not "Related Work"). Keep headings short and avoid ending them with punctuation.
- Write prose first. Use lists only for genuinely parallel items, and avoid stacking several lists in a row.
- The abstract is one paragraph of 120–200 words: the question, the approach, the main result with a number, and why it matters.
- For emphasis inside prose, use `_italic_`, not `*bold*`.
- Every figure and table is referenced in the text before it appears (`@fig-x`) and has a caption in full sentences. The caption's first sentence says what is shown; the rest says what to notice.
- Label anything you refer to: `<sec-…>`, `<fig-…>`, `<tab-…>`, `<eq-…>`, `<thm-…>`. Never type "Figure 3" by hand.

**Tables.** Right-align numbers (`align: (left, right, right)`), put units in the header, keep a consistent number of decimals, and bold only the best value in a column. Use no vertical rules and no cell fills.

**Figures.** Size matplotlib figures in inches at their final width (`plot_style.FULL_WIDTH` = 5.6 in, `HALF_WIDTH` = 2.7 in) and include them at `width: 100%` (or `48%` in a two-column `grid`), so plot text matches the caption size. Save as SVG. Do not add titles that repeat the caption.

**Honesty.**
- Cite only sources you are sure exist, with correct authors, title, venue, and year. If unsure, leave the citation out or ask.
- Never fabricate data for a real report. If the user asked for a template or mock-up, say so in a footnote, as `examples/report.typ` does.

## Before you deliver

Open the PNG of every page and check:

- [ ] The build printed no `warning:` lines, especially `unknown font family`.
- [ ] No heading is stranded at the bottom of a page, and no page is mostly empty because of a figure that would not fit. Fix it by shortening, resizing, or moving the figure.
- [ ] No overfull lines: long URLs, code lines, or table cells running into the margin. Wrap code at about 80 characters.
- [ ] Every `@ref` resolved. Typst errors on unknown labels, so a clean build is the proof.
- [ ] Figures are legible: plot text is about 7 pt and no smaller, and nothing is clipped.
- [ ] The running head (`short-title`) fits on one line.
- [ ] The metadata is right: author names, date, and the `kind` label.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `unknown font family: source serif 4` | Build via `build.sh`, or add `--font-path $SKILL/fonts`. |
| `file not found (searched at …)` | Paths are relative to the `.typ` file and must stay inside the project root. Pass `--root` to `build.sh` for a wider root. |
| `unknown variable: …` / `expected function` | Check `references/latex-to-typst.md`. The usual causes are `f(x)` directly after a sub- or superscript, an unescaped `@`, `$`, `#`, or `<` in text, or a space between `)` and `[` in a call. |
| A paragraph unexpectedly indented, or not indented | LaTeX rules: paragraphs after headings, figures, and lists are not indented, and others are. That is intended. |
| CJK text renders in a random font | Set `lang: "zh"` and `fallback-fonts: ("Noto Serif CJK SC",)`, using a family name that `typst fonts` lists. |
| Typst too old | `bash $SKILL/scripts/install-typst.sh` installs a pinned release into `~/.local/bin`. |

## Files

- `claude-academic/lib.typ`: the template (`report`, components, `palette`, `fonts`).
- `claude-academic/ivory.tmTheme`: the syntax theme for code blocks.
- `templates/main.typ`, `templates/refs.bib`: the starter copied by `new.sh`.
- `examples/report.typ`: a full showcase of every component; read it for idioms.
- `scripts/build.sh`, `new.sh`, `install-typst.sh`, `install-package.sh`, `test.sh`, `plot_style.py`.
- `assets/claude-academic.mplstyle`: the matplotlib style used by `plot_style.py`.
- `fonts/`: Source Serif 4, Inter, and JetBrains Mono, all under the SIL OFL. Math uses Typst's built-in New Computer Modern Math.
- `references/components.md`: full API. `references/design.md`: design tokens and rationale. `references/latex-to-typst.md`: syntax primer.
