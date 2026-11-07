# Component reference

Everything below is exported by `claude-academic/lib.typ`:

```typst
#import "claude-academic/lib.typ": *
```

## `report`: the document template

```typst
#show: report.with(
  title: [Untitled report],    // content
  subtitle: none,              // content | none
  short-title: none,           // running head; defaults to title
  kind: auto,                  // eyebrow label; auto = "Technical report" (localised)
  authors: (),                 // see below
  date: auto,                  // auto (today) | datetime | content | none
  abstract: none,              // content | none
  keywords: (),                // array of strings
  title-style: "modern",       // "modern" | "classic"
  cover: false,                // full cover page
  toc: false,                  // table of contents after the abstract (then page break)
  paper: "a4",                 // any Typst paper name, e.g. "us-letter"
  tint: true,                  // ivory background; false = white for print
  font-size: 10.5pt,
  lang: "en",                  // "en" | "zh" (labels); any lang for hyphenation
  region: none,
  fallback-fonts: (),          // appended to every font family list
)
```

**Authors.** Each entry is either a string or a dictionary:

```typst
authors: (
  "Solo Author",
  (name: "Ada Whitfield", affiliation: "Institute A", email: "ada@a.example"),
  (name: "Mei Lin Sato", affiliation: ("Institute A", "University B")),
)
```

Affiliations are de-duplicated and numbered in order of first appearance. Superscript numbers appear only when there is more than one distinct affiliation. Emails are listed in monospace under the affiliations.

**Page layout.** Margins are 3.3 cm left and right, 3.1 cm top, and 3.2 cm bottom, which gives a text width of 14.4 cm on A4 (about 75 characters per line). The running head (short title on the left, current section on the right) appears from the second page. The page number is centred in the footer.

## Headings

| Level | Look | Notes |
|---|---|---|
| `=` | 15 pt display serif, clay number | Resets the theorem counter |
| `==` | 11 pt semibold, deep-clay number | |
| `===` | Text-size semibold italic, muted number | |
| `====` | Text-size italic, unnumbered | Use rarely |

The heading supplement is "Section", so `@sec-x` renders as "Section 2". After `#show: appendix` it becomes "Appendix" and numbering switches to A, A.1, and so on.

## Theorem-like environments

```typst
#theorem(title: [Optional name])[Body.] <thm-label>
#lemma[…]  #proposition[…]  #corollary[…]  #conjecture[…]   // italic body
#definition[…]  #assumption[…]  #example[…]  #remark[…]      // upright body
#proof[…]                                                     // or #proof(title: [Proof of @thm-label])[…]
```

- All of them share one counter, numbered within level-1 sections: Definition 3.1, Theorem 3.2, Remark 3.3. In appendices the numbers are A.1, A.2, and so on. Before the first numbered section they are plain 1, 2, ….
- They render as run-in paragraphs (amsthm `plain` and `definition` styles), never as floats, and may break across pages.
- `@thm-label` renders as "Theorem 3.2".
- Inside an italic body, `_x_` switches back to upright, as `\emph` does in LaTeX.

## Equations

- `$x$` is inline. `$ x $`, with spaces inside, is display.
- Every display equation is numbered (1), (2), …. Use `#nonumber($ … $)` for an unnumbered one.
- `@eq-label` renders as "Eq. (3)".
- Math is set in New Computer Modern Math (Book weight), so it looks like LaTeX.

## Figures and tables

```typst
#figure(image("figures/plot.svg", width: 100%), caption: [What it shows. What to notice.]) <fig-x>

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (left, right, right),
    table.header[Method][Accuracy (%)][Time (s)],
    [Baseline], [71.2], [3.4],
    [Ours], [*78.9*], [3.1],
  ),
  caption: [Results on the test split. Higher accuracy is better.],
) <tab-x>
```

- Every `table` gets booktabs rules automatically: a heavy rule on top and bottom, and a light rule under `table.header` if there is one. Header cells are set semibold. There are no vertical rules.
- Tables break across pages. Use `table.header(repeat: true, …)` to repeat the header on each page.
- Table captions go above the table and figure captions below, as in LaTeX. A caption that fits on one line is centred; a longer one is justified.
- Side-by-side panels: `#figure(grid(columns: 2, column-gutter: 1em, image("a.svg"), image("b.svg")), caption: […])`.

## `callout`

```typst
#callout(title: [Key finding])[…]                    // ivory fill, deep-clay label
#callout(title: [Caveat], tone: "accent")[…]          // clay-tint fill
#callout(title: [Summary], tone: "solid")[…]          // solid clay fill, ink text (use once, if at all)
#callout[…]                                           // no label
```

## `stats`

```typst
#stats(
  (value: "9.8%", label: "Raw ECE"),
  (value: "2.1%", label: "Scaled ECE"),
  (value: "1.41", label: "Fitted temperature"),
)
```

This renders equal-width ivory tiles with large display numerals. Use two to four items, and keep labels to about 20 characters so they stay on one line.

## `pullquote`

```typst
#pullquote(attribution: [Name, Source])[The sentence worth repeating.]
```

## `appendix`

```typst
#bibliography("refs.bib")
#show: appendix
= Proofs <app-proofs>    // "Appendix A"
```

## Small helpers

- `mark(size: 0.5em, fill: palette.clay)`: the solid square used as house mark, bullet, and end-of-proof sign.
- `eyebrow(body, fill: palette.muted, size: 7pt)`: a small uppercase tracked sans label.
- `nonumber(eq)`: an unnumbered display equation.

## Tokens

```typst
palette.ink        #141413   body text
palette.ink-soft   #3D3D3A   captions, secondary text
palette.muted      #73726C   metadata, axis labels
palette.rule       #D6D3C8   hairlines
palette.paper      #FAF9F5   page background
palette.ivory      #F0EEE6   fills (abstract, callouts, code, tiles)
palette.oat        #E6E3D8   deeper fill, de-emphasised bars, grid lines
palette.clay       #D97757   accent fill and large marks
palette.clay-deep  #B9532F   accent for small text (links, labels)
palette.clay-tint  #F4E4DA   accent-tinted fill
palette.sky / olive / kraft / fig / heather / slate   secondary chart colours

chart-colors = (clay, sky, olive, kraft, fig, slate)

fonts.serif    Source Serif 4           body
fonts.display  Source Serif 4 Display   title, level-1 headings, stats
fonts.caption  Source Serif 4 Caption   footnotes, affiliations
fonts.sans     Inter                    labels, running head, page numbers, plots
fonts.mono     JetBrains Mono           code
fonts.math     New Computer Modern Math (built into Typst)
```

## Drawing directly in Typst

For small diagrams, use `place`, `rect`, `line`, `circle`, and `curve` inside a fixed-size `box`, with `palette` colours and `fonts.sans` at 5.5–7 pt for labels. `examples/report.typ` (the `reliability` function) shows a complete bar chart drawn this way. For real data, matplotlib with `scripts/plot_style.py` is quicker and more robust.
