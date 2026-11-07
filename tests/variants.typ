// Smoke test: cover page, classic title, table of contents, white paper, US letter.
#import "../claude-academic/lib.typ": *
#let variant = sys.inputs.at("variant", default: "cover")

#show: report.with(
  title: [On the Typesetting of Careful Reports],
  subtitle: [A test of every switch],
  kind: [Research note],
  authors: ("Solo Author",),
  date: [Autumn 2026],
  abstract: [A short abstract to test the abstract block in this variant.],
  keywords: ("testing",),
  cover: variant == "cover",
  toc: variant == "cover" or variant == "classic",
  title-style: if variant == "classic" { "classic" } else { "modern" },
  tint: variant != "print",
  paper: if variant == "print" { "us-letter" } else { "a4" },
)

= First section
#lorem(120)
== A subsection
#lorem(80)#footnote[A footnote.]
$ integral_0^1 x^2 dif x = 1/3 $ <eq-a>
See @eq-a and @thm-a.
#theorem[#lorem(20)] <thm-a>
#proof[#lorem(15)]
#callout(title: [Solid], tone: "solid")[#lorem(25)]
#callout[#lorem(20)]
= Second section
#lorem(200)
#table(columns: 3, [a], [b], [c], [1], [2], [3])
#example[An example with `inline code`.]
#show: appendix
= Extra
#lemma[#lorem(10)]
