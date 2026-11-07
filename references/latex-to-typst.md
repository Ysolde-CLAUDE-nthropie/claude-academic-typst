# LaTeX → Typst primer

This covers just enough to write correct Typst if you know LaTeX. Most first-build errors come from the items marked ⚠.

## Markup

| LaTeX | Typst |
|---|---|
| `\section{Intro}\label{sec:intro}` | `= Intro <sec-intro>` |
| `\subsection{…}` | `== …` |
| `\emph{x}` / `\textit{x}` | `_x_` |
| `\textbf{x}` | `*x*` ⚠ single asterisks, not `**x**` |
| `\texttt{x}` | `` `x` `` |
| `\footnote{…}` | `#footnote[…]` |
| `\ref{fig:x}`, `\cref{…}`, `\eqref{…}` | `@fig-x` (adds "Figure", "Section", "Eq. (1)" automatically) |
| `\cite{key}` / `\citet{key}` | `@key` / `#cite(<key>, form: "prose")` |
| `\url{…}` / `\href{u}{t}` | `#link("https://…")` / `#link("https://…")[t]` |
| `~` (non-breaking space) | `~` (same) |
| `--` / `---` | `--` / `---` (same) |
| ``` ``quotes'' ``` | `"quotes"` (smart quotes are automatic) |
| `\\` (line break) | `\` at end of line (rarely needed) |
| `itemize` / `enumerate` | lines starting with `-` / `+` |
| `description` | `/ Term: description` |
| `\newpage` | `#pagebreak()` |
| `%` comment | `//` comment |
| `\begin{verbatim}` | fenced ```` ``` ```` block, optionally with a language |

⚠ **Characters that need escaping in text:** `\#`, `\$`, `\@` (for example in `name\@example.com`), `\*`, `\_`, `\<`, `\\`. Inside strings (`"…"`), as in the `authors:` dictionary, none of these need escaping.

⚠ **Function calls:** `#name(args)[content]` has no space between `)` and `[`. With a space, the content block becomes separate text.

## Math

Inline `$x$`, display `$ x $` (the spaces make it display). Label a display equation by putting `<eq-x>` right after the closing `$`.

| LaTeX | Typst |
|---|---|
| `\frac{a}{b}` | `a/b` or `frac(a, b)` |
| `\alpha, \Delta, \infty` | `alpha, Delta, infinity` (or `oo`) |
| `x_{ij}`, `x^{n+1}` | `x_(i j)`, `x^(n+1)` ⚠ parentheses, not braces |
| `\hat{x}`, `\tilde{x}`, `\bar{x}` | `hat(x)`, `tilde(x)`, `overline(x)` |
| `\mathbb{R}`, `\mathbb{E}`, `\mathbb{P}` | `RR`, `EE`, `PP` (or `bb(R)`) |
| `\mathcal{X}` | `cal(X)` |
| `\mathrm{acc}`, `\text{ for all }` | `"acc"`, `" for all "` (strings are upright text) |
| `\operatorname*{arg\,max}_x` | `arg max_x` |
| `\sum_{i=1}^n` | `sum_(i=1)^n` |
| `\int_0^1 f\,dx` | `integral_0^1 f dif x` |
| `\left( … \right)` | automatic; `lr(( … ))` to force |
| `\leq, \geq, \neq, \approx` | `<=, >=, !=, approx` |
| `\to, \mapsto, \Rightarrow` | `->, |->, =>` |
| `\cdot, \times, \circ` | `dot, times, compose` (or `circle.small`) |
| `\mid` (conditional bar) | `|` with spaces, or `mid(|)` |
| `\quad`, `\,` | `quad`, `thin` |
| `\begin{aligned} a &= b \\ &= c \end{aligned}` | `$ a &= b \ &= c $` |
| `\begin{cases}` | `cases(x "if" y, z "otherwise")` |
| `\begin{pmatrix}` | `mat(1, 2; 3, 4)` |

⚠ **`f_k(x)` means `f` with subscript `k(x)`.** Write `f_k (x)` with a space before the parenthesis.

⚠ **Multi-letter names:** `ab` in math is a variable called `ab` (an error if undefined). Write `a b` for a product, and `"ECE"` for an upright multi-letter word.

## Figures and tables

```typst
#figure(image("plot.svg", width: 100%), caption: [Caption.]) <fig-x>

#figure(
  table(
    columns: 3,
    align: (left, right, right),
    table.header[Model][Acc.][Time],
    [A], [0.91], [12],
  ),
  caption: [Caption.],
) <tab-x>
```

There are no floats by default: figures appear where they are written. If a figure leaves a big gap, move it to after the next paragraph, shrink it, or add `placement: auto` to the `figure` call to let Typst float it to the top or bottom of a page.

## Bibliography

`#bibliography("refs.bib")` takes a normal BibTeX file (Hayagriva YAML also works). Citations are `@key`, and grouped citations like `@a @b` render as `[1], [2]`. The default style is IEEE-like numeric. Use `#bibliography("refs.bib", style: "apa")` for author–year, and pair it with `#cite(<key>, form: "prose")` for "Author (Year)".

## Scripting basics

- `#let name = value` defines a variable. `#let f(x) = …` defines a function.
- `[ … ]` is content (markup). `{ … }` is code. `#` switches from markup into code.
- `#for x in xs [ … ]`, `#if cond [ … ] else [ … ]`.
- Read data with `#let data = csv("data.csv")` or `json("data.json")`. To build a table from it: `table(columns: 3, ..data.flatten())`.
