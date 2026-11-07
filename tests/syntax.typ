// Regression test: every idiom documented in SKILL.md and references/*.md must compile.
#import "../claude-academic/lib.typ": *
#show: report.with(
  title: [Syntax coverage],
  authors: (
    "Solo Author",
    (name: "Ada Whitfield", affiliation: "Institute A", email: "ada@a.example"),
    (name: "Mei Lin Sato", affiliation: ("Institute A", "University B")),
  ),
  date: datetime(year: 2026, month: 1, day: 2),
  kind: [Preprint],
)
= Markup <sec-a>
_Italic_, *bold*, `code`, a footnote#footnote[Note.], a link #link("https://typst.app")[Typst], email ada\@a.example, \$5, \#tag, non~breaking.
See @sec-a, @thm-a, @eq-a, @tab-a, @fig-a, cite @guo2017 and #cite(<guo2017>, form: "prose").
- item
- item
+ one
+ two
/ Term: description
= Math
$f_k (x)$, $x_(i j)^(n+1)$, $hat(x) tilde(x) overline(x)$, $RR EE PP cal(X) bb(R)$, $"acc"(B)$, $a <= b >= c != d approx e$, $-> |-> =>$, $a dot b times c compose d$, $PP[A | B]$, $mid(|)$, $quad thin$, $oo infinity$, $alpha Delta$.
$ arg max_x sum_(i=1)^n integral_0^1 f dif x $ <eq-a>
$ a &= b \ &= c $
$ cases(x "if" y, z "otherwise") quad mat(1, 2; 3, 4) quad frac(a, b) quad lr(( a/b )) $
#nonumber($ e^(i pi) + 1 = 0 $)
#theorem(title: [Named])[Body _upright_ part.] <thm-a>
#proof(title: [Proof of @thm-a])[Done.]
#lemma[L.] #proposition[P.] #corollary[C.] #conjecture[Cj.] #definition[D.] #assumption[A.] #example[E.] #remark[R.]
#figure(table(columns: (auto, 1fr, 1fr), align: (left, right, right), table.header(repeat: true)[Method][Acc. (%)][Time (s)], [A], [71.2], [3.4], [B], [*78.9*], [3.1]), caption: [Table.]) <tab-a>
#figure(grid(columns: 2, column-gutter: 1em, rect(width: 100%, height: 2cm, fill: palette.oat), rect(width: 100%, height: 2cm, fill: palette.clay)), caption: [Panels.], placement: auto) <fig-a>
#callout(title: [Key])[Neutral.] #callout(title: [Caveat], tone: "accent")[Accent.] #callout(title: [Sum], tone: "solid")[Solid.] #callout[No label.]
#stats((value: "1", label: "One"), (value: "2", label: "Two"))
#pullquote(attribution: [Someone])[Quote.]
#mark() #eyebrow[label] #text(fill: chart-colors.at(1))[sky]
#let data = csv(bytes("a,b\n1,2"))
#table(columns: 2, ..data.flatten())
#for x in (1, 2) [#x ] #if true [yes] else [no]
```python
print("hi")
```
#bibliography("../examples/refs.bib", style: "apa")
#show: appendix
= App <app-a>
See @app-a.
