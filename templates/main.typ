// Starter document for claude-academic. Replace the placeholders, keep the structure.
#import "claude-academic/lib.typ": *

#show: report.with(
  title: [Title in Sentence Case],
  subtitle: none,                       // optional one-line subtitle
  short-title: none,                    // optional shorter running head
  kind: [Technical report],             // eyebrow: Research note, White paper, Preprint, …
  authors: (
    (name: "First Author", affiliation: "Organisation", email: "first@example.org"),
  ),
  date: auto,                           // auto = today
  abstract: [
    One paragraph, 120–200 words: the question, the approach, the main result with a number, and why it matters.
  ],
  keywords: ("keyword one", "keyword two"),
  // title-style: "classic",            // centred LaTeX-style title block
  // cover: true,                       // full cover page with a clay band
  // toc: true,                         // table of contents
  // tint: false,                       // white paper for printing
  // paper: "us-letter",
)

= Introduction <sec-intro>

State the problem and why it matters. Cite prior work @example2024 and point ahead to @sec-method.

= Method <sec-method>

#definition(title: [Term])[Define the central object.]

$ y = f(x) + epsilon $ <eq-model>

= Results <sec-results>

#figure(
  table(
    columns: (1fr, auto, auto),
    align: (left, right, right),
    table.header[Setting][Metric A][Metric B],
    [Baseline], [0.00], [0.00],
    [Ours], [*0.00*], [*0.00*],
  ),
  caption: [What the table shows, and which direction is better.],
) <tab-results>

#callout(title: [Key finding])[One or two sentences the reader should remember.]

= Conclusion

Summarise the answer to the question posed in @sec-intro.

#bibliography("refs.bib")
