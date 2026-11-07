# Design notes

This file explains why the template looks the way it does, so that content decisions (what to highlight, how to chart, when to use a box) stay in keeping with it.

## The idea in one sentence

Use a classical book page (serif text, generous margins, LaTeX's quiet conventions) on warm paper, with modern flat colour used sparingly: solid fills instead of outlines, one warm accent, and plenty of space.

## Principles

1. **Warm paper, near-black ink.** The page is ivory (`#FAF9F5`) and the text is a warm near-black (`#141413`), never pure `#000` on `#FFF`. The contrast is still well above AA, but the page reads as paper rather than a screen.
2. **One accent, used for meaning.** Clay (`#D97757`) appears in section numbers, the house mark, bullets, the end-of-proof square, and whatever the author chooses to highlight. Small accent text (links, labels) uses the deeper `#B9532F` so it stays legible at 4.6:1 on paper. Every extra use of clay weakens the others.
3. **Fills, not frames.** Boxes are areas of flat colour (ivory `#F0EEE6`, clay tint, or solid clay) with a 2 pt radius and no border. Rules are reserved for tables (booktabs) and the running head.
4. **Classical text, modern labels.** Long-form text is set in a serif; small functional labels (eyebrows, figure labels, the running head, page numbers, plot text) use a neutral grotesque, uppercase and tracked for eyebrows. The contrast between the two is what makes the page feel current without losing the academic register.
5. **Large type is light.** The title, level-1 headings, and the numerals in `stats` use the Display cut at regular weight. Size carries the hierarchy, not boldness. Bold (semibold, 600) is kept for small headings, theorem labels, and table headers.
6. **LaTeX's manners.** The template keeps LaTeX's conventions: indented paragraphs with no extra space between them and no indent after headings, justified text with hyphenation, numbered sections, amsthm environments, numbered display equations in Computer Modern, table captions above and figure captions below, booktabs, superscript footnote markers with a short separator rule, and `[1]`-style references.

## Typefaces

| Role | Family | Why |
|---|---|---|
| Text | Source Serif 4 | A contemporary transitional serif with the steady colour of a book face and real italics. It is open source (OFL) and comes in optical sizes. |
| Display | Source Serif 4 Display | A finer-contrast cut for 15 pt and above, giving the title and section heads their elegance. |
| Small text | Source Serif 4 Caption | A sturdier cut for footnotes and affiliations at 8 pt. |
| Labels | Inter | A neutral grotesque that stays legible at 7 pt. |
| Code | JetBrains Mono | Clear at small sizes, with distinct `0O1lI`. |
| Math | New Computer Modern Math (Book) | The LaTeX look; the Book weight matches Source Serif's colour better than Regular. |

These are open-licensed stand-ins for the proprietary faces Anthropic uses; none of Anthropic's own fonts or marks are included. All fonts ship in `fonts/` under the SIL Open Font License.

## Sizes and spacing

| Element | Size | Notes |
|---|---|---|
| Body | 10.5 pt | Leading 0.72 em, indent 1.4 em |
| Title | 25 pt Display (36 pt on cover) | Tracking −1.2% |
| Level-1 heading | 15 pt Display | 26 pt above, 13 pt below |
| Level-2 heading | 11 pt semibold | |
| Captions | 8.8 pt serif, 7 pt sans label | |
| Footnotes | 7.8 pt Caption | |
| Eyebrows / running head | 7–7.5 pt Inter, tracked +9% (eyebrows) | |
| Code | 0.8 × body | Ivory fill, 2 pt radius |

## Charts

- Use a transparent background so the chart sits on the page colour, with a grid in `oat` on the y-axis only and no top or right spine.
- Series order is clay, sky, olive, kraft, fig, slate. Use three or four series at most; past that, use small multiples.
- To make a point, colour the focal element clay and everything else `oat` or `slate`.
- Text is Inter at 7–7.5 pt, so it matches the figure labels. Leave the chart title off if the caption says the same thing.
- Make the figure at final size (`FULL_WIDTH` 5.6 in, `HALF_WIDTH` 2.7 in) and do not scale it in Typst.

## What to avoid

- Gradients, shadows, outlines around boxes, rounded corners above 2 pt, and colours outside the palette.
- Bold for emphasis in prose, all-caps sentences, emoji, and coloured body text.
- More than one solid-clay element in view at once.
- Centred body text, or ragged-right body text (except in captions and tables).
