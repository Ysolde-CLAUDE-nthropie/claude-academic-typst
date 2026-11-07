// claude-academic — an academic report template for Typst.
//
// Ivory paper, a single clay accent, a classical serif, and LaTeX's
// typographic conventions (numbered sections, amsthm-style theorems,
// numbered equations, booktabs tables, footnotes, bibliography).
//
// Unofficial. Inspired by Claude's visual identity; not affiliated with
// or endorsed by Anthropic. Ships only open-licensed (OFL) fonts.

// ---------------------------------------------------------------------------
// Design tokens
// ---------------------------------------------------------------------------

#let palette = (
  // Neutrals
  ink: rgb("#141413"),        // body text
  ink-soft: rgb("#3D3D3A"),   // secondary text, captions
  muted: rgb("#73726C"),      // metadata, running heads, page numbers
  rule: rgb("#D6D3C8"),       // hairlines
  paper: rgb("#FAF9F5"),      // page background (when tinted)
  ivory: rgb("#F0EEE6"),      // solid fills: abstract, callouts, code
  oat: rgb("#E6E3D8"),        // deeper fill, table stripes, chart grid
  // Accent
  clay: rgb("#D97757"),       // solid accent: marks, bars, large numerals
  clay-deep: rgb("#B9532F"),  // accent for small text (AA on paper)
  clay-tint: rgb("#F4E4DA"),  // accent-tinted fill
  // Secondary (charts only; use sparingly)
  sky: rgb("#6A9BCC"),
  olive: rgb("#788C5D"),
  kraft: rgb("#D4A27F"),
  fig: rgb("#C46686"),
  heather: rgb("#CBCADB"),
  slate: rgb("#5E5D59"),
)

// Ordered categorical palette for charts. First series is always clay.
#let chart-colors = (
  palette.clay, palette.sky, palette.olive, palette.kraft, palette.fig, palette.slate,
)

#let fonts = (
  serif: ("Source Serif 4", "Libertinus Serif"),
  display: ("Source Serif 4 Display", "Source Serif 4", "Libertinus Serif"),
  caption: ("Source Serif 4 Caption", "Source Serif 4", "Libertinus Serif"),
  sans: ("Inter", "Source Serif 4", "Libertinus Serif"),
  mono: ("JetBrains Mono", "DejaVu Sans Mono"),
  math: ("New Computer Modern Math",),
)

// Interface strings. Chosen from the document's `lang`; English otherwise.
#let _labels = (
  en: (
    report: "Technical report", abstract: "Abstract", keywords: "Keywords",
    contents: "Contents", references: "References", section: "Section",
    appendix: "Appendix", equation: "Eq.", proof: "Proof",
    theorem: "Theorem", lemma: "Lemma", proposition: "Proposition",
    corollary: "Corollary", conjecture: "Conjecture", definition: "Definition",
    assumption: "Assumption", example: "Example", remark: "Remark",
  ),
  zh: (
    report: "技术报告", abstract: "摘要", keywords: "关键词",
    contents: "目录", references: "参考文献", section: "§",
    appendix: "附录", equation: "式", proof: "证明",
    theorem: "定理", lemma: "引理", proposition: "命题",
    corollary: "推论", conjecture: "猜想", definition: "定义",
    assumption: "假设", example: "例", remark: "注",
  ),
)
#let _t(key) = context _labels.at(text.lang, default: _labels.en).at(key)

// ---------------------------------------------------------------------------
// Small building blocks
// ---------------------------------------------------------------------------

#let _appendix = state("ca-appendix", false)

// A solid clay square: the house mark, list bullet, and end-of-proof sign.
#let mark(size: 0.5em, fill: palette.clay, baseline: 0pt) = box(
  width: size, height: size, fill: fill, baseline: baseline,
)

// Small uppercase sans label ("eyebrow").
#let eyebrow(body, fill: palette.muted, size: 7pt) = text(
  font: fonts.sans, size: size, weight: 500, tracking: 0.09em, fill: fill, upper(body),
)

#let _as-array(x) = if x == none { () } else if type(x) == array { x } else { (x,) }

#let _fmt-date(date, lang) = {
  if date == auto { date = datetime.today() }
  if type(date) != datetime { return date }
  if lang == "zh" { date.display("[year] 年 [month padding:none] 月 [day padding:none] 日") }
  else { date.display("[month repr:long] [day padding:none], [year]") }
}

// Numbering shared by theorem-like environments: "2.3" inside section 2,
// "A.1" in appendices, plain "3" before the first numbered section.
#let _thm-numbering(n) = {
  let h = counter(heading).get().first()
  if h == 0 { str(n) } else if _appendix.get() { numbering("A.1", h, n) } else { numbering("1.1", h, n) }
}

// ---------------------------------------------------------------------------
// Theorem-like environments (amsthm conventions)
// ---------------------------------------------------------------------------

#let _thm-env(supplement, italic-body) = (title: none, body) => figure(
  kind: "ca-thm",
  supplement: supplement,
  numbering: _thm-numbering,
  outlined: false,
  ..(if title != none { (caption: title) }),
  if italic-body { emph(body) } else { body },
)

#let theorem = _thm-env(_t("theorem"), true)
#let lemma = _thm-env(_t("lemma"), true)
#let proposition = _thm-env(_t("proposition"), true)
#let corollary = _thm-env(_t("corollary"), true)
#let conjecture = _thm-env(_t("conjecture"), true)
#let definition = _thm-env(_t("definition"), false)
#let assumption = _thm-env(_t("assumption"), false)
#let example = _thm-env(_t("example"), false)
#let remark = _thm-env(_t("remark"), false)

#let proof(title: _t("proof"), body) = block(width: 100%, breakable: true, above: 0.9em, below: 1.3em)[
  #emph(title).#h(0.45em)#body#h(1fr)#mark(size: 0.46em)
]

// ---------------------------------------------------------------------------
// Callouts, stats, and other solid-fill components
// ---------------------------------------------------------------------------

// tone: "neutral" (ivory fill), "accent" (clay tint), "solid" (clay fill).
#let callout(title: none, tone: "neutral", body) = {
  let (fill, label) = if tone == "solid" {
    (palette.clay, palette.ink)
  } else if tone == "accent" {
    (palette.clay-tint, palette.clay-deep)
  } else {
    (palette.ivory, palette.clay-deep)
  }
  block(
    width: 100%, fill: fill, radius: 2pt, breakable: true,
    inset: (x: 14pt, top: 11pt, bottom: 12pt), above: 1.4em, below: 1.4em,
  )[
    #set par(first-line-indent: 0pt, spacing: 0.75em)
    #set text(size: 0.95em)
    #if title != none {
      block(below: 0.85em, eyebrow(title, fill: label, size: 7pt))
    }
    #body
  ]
}

// A row of headline numbers. Each item: (value: "…", label: "…").
#let stats(..items) = {
  let items = items.pos()
  block(above: 1.4em, below: 1.4em, grid(
    columns: (1fr,) * items.len(),
    column-gutter: 6pt,
    fill: palette.ivory,
    inset: (x: 12pt, top: 13pt, bottom: 11pt),
    ..items.map(item => {
      set par(first-line-indent: 0pt, justify: false, leading: 0.45em)
      text(font: fonts.display, size: 21pt, weight: 400, fill: palette.ink, item.value)
      v(5pt)
      text(font: fonts.sans, size: 7pt, fill: palette.muted, hyphenate: false, item.label)
    }),
  ))
}

// A display quotation with a clay rule.
#let pullquote(body, attribution: none) = block(
  above: 1.6em, below: 1.6em, inset: (left: 14pt, y: 2pt),
  stroke: (left: 2.2pt + palette.clay),
)[
  #set par(first-line-indent: 0pt, justify: false, leading: 0.5em)
  #text(font: fonts.display, size: 13pt, style: "italic", fill: palette.ink, body)
  #if attribution != none {
    v(0.4em)
    eyebrow(attribution, size: 6.8pt)
  }
]

// Equation without a number: #nonumber($ a = b $)
#let nonumber(eq) = math.equation(block: true, numbering: none, eq.body)

// ---------------------------------------------------------------------------
// Appendix
// ---------------------------------------------------------------------------

// Usage: `#show: appendix` — following level-1 headings become A, B, …
#let appendix(body) = {
  counter(heading).update(0)
  _appendix.update(true)
  set heading(numbering: "A.1", supplement: _t("appendix"))
  body
}

// ---------------------------------------------------------------------------
// Title matter
// ---------------------------------------------------------------------------

#let _normalize-authors(authors) = {
  let authors = _as-array(authors).map(a => if type(a) == dictionary { a } else { (name: a) })
  let affils = ()
  for a in authors {
    for x in _as-array(a.at("affiliation", default: none)) {
      if x not in affils { affils.push(x) }
    }
  }
  (authors, affils)
}

#let _author-line(authors, affils, sep: [, ]) = {
  let numbered = affils.len() > 1
  authors.map(a => {
    a.name
    if numbered {
      let ids = _as-array(a.at("affiliation", default: none)).map(x => str(affils.position(y => y == x) + 1))
      if ids.len() > 0 { super(typographic: false, ids.join(",")) }
    }
  }).join(sep)
}

#let _affil-line(affils) = {
  if affils.len() == 1 { affils.first() } else {
    affils.enumerate().map(((i, x)) => [#super(typographic: false, str(i + 1))#x]).join(h(1.1em))
  }
}

#let _emails(authors) = {
  let es = authors.filter(a => a.at("email", default: none) != none).map(a => a.email)
  if es.len() > 0 { text(font: fonts.mono, size: 7pt, fill: palette.muted, es.join("   ")) }
}

#let _abstract-modern(abstract, keywords) = block(
  width: 100%, fill: palette.ivory, radius: 2pt,
  inset: (x: 16pt, top: 13pt, bottom: 14pt), above: 2.2em, below: 2.4em,
)[
  #set par(first-line-indent: 0pt, spacing: 0.75em)
  #set text(size: 0.92em)
  #block(below: 0.9em, eyebrow(_t("abstract"), fill: palette.clay-deep))
  #abstract
  #if keywords.len() > 0 {
    v(0.4em)
    text(size: 0.94em, fill: palette.ink-soft)[_#_t("keywords"):_ #keywords.join(", ")]
  }
]

#let _abstract-classic(abstract, keywords) = block(width: 100%, above: 2em, below: 2.4em, inset: (x: 1.2cm))[
  #set par(first-line-indent: 0pt, spacing: 0.75em)
  #set text(size: 0.92em)
  #align(center, block(below: 0.9em, text(weight: 600, smallcaps(all: true, _t("abstract")))))
  #abstract
  #if keywords.len() > 0 {
    v(0.3em)
    [_#_t("keywords"):_ #keywords.join(", ")]
  }
]

#let _title-modern(title, subtitle, kind, authors, affils, date) = {
  set par(first-line-indent: 0pt, justify: false)
  block(below: 2.4em, grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    [#mark(size: 0.55em, baseline: -0.02em)#h(0.6em)#eyebrow(kind)],
    if date != none { eyebrow(date) },
  ))
  block(below: if subtitle != none { 0.9em } else { 1.6em }, text(
    font: fonts.display, size: 25pt, weight: 400, tracking: -0.012em, hyphenate: false,
    par(leading: 0.28em, title),
  ))
  if subtitle != none {
    block(below: 1.6em, text(
      font: fonts.display, size: 13pt, style: "italic", fill: palette.ink-soft, hyphenate: false,
      par(leading: 0.42em, subtitle),
    ))
  }
  if authors.len() > 0 {
    block(below: 0.6em, text(size: 10.5pt, _author-line(authors, affils)))
    if affils.len() > 0 {
      block(below: 0.45em, text(font: fonts.caption, size: 8pt, fill: palette.ink-soft, _affil-line(affils)))
    }
    _emails(authors)
  }
}

#let _title-classic(title, subtitle, kind, authors, affils, date) = {
  set par(first-line-indent: 0pt, justify: false)
  set align(center)
  v(0.6cm)
  block(below: 1.1em, text(font: fonts.display, size: 20pt, weight: 400, hyphenate: false, par(leading: 0.32em, title)))
  if subtitle != none {
    block(below: 1.2em, text(font: fonts.display, size: 12pt, style: "italic", fill: palette.ink-soft, subtitle))
  }
  if authors.len() > 0 {
    block(below: 0.6em, text(size: 11pt, _author-line(authors, affils, sep: h(1.4em))))
    if affils.len() > 0 {
      block(below: 0.45em, text(font: fonts.caption, size: 8.5pt, fill: palette.ink-soft, _affil-line(affils)))
    }
    block(below: 0.6em, _emails(authors))
  }
  if date != none { block(above: 0.9em, text(size: 10pt, date)) }
}

#let _cover(title, subtitle, kind, authors, affils, date, margin-x) = page(
  margin: 0pt, header: none, footer: none, numbering: none,
)[
  #set par(first-line-indent: 0pt, justify: false)
  #place(top + left, dx: margin-x, dy: 2.6cm)[#mark(size: 0.6em, baseline: -0.02em)#h(0.6em)#eyebrow(kind)]
  #place(top + left, dx: margin-x, dy: 7.4cm, block(width: 100% - 2 * margin-x)[
    #text(font: fonts.display, size: 36pt, weight: 400, tracking: -0.015em, hyphenate: false, par(leading: 0.24em, title))
    #if subtitle != none {
      v(1.1em)
      text(font: fonts.display, size: 15pt, style: "italic", fill: palette.ink-soft, hyphenate: false, par(leading: 0.42em, subtitle))
    }
  ])
  #place(bottom + left, block(width: 100%, height: 33%, fill: palette.clay, inset: (x: margin-x, top: 1.5cm, bottom: 2.1cm), grid(
    rows: (auto, 1fr, auto),
    {
      set text(fill: palette.ink)
      if authors.len() > 0 {
        block(below: 0.7em, text(size: 12pt, _author-line(authors, affils)))
        if affils.len() > 0 { block(below: 0.6em, text(font: fonts.caption, size: 8.5pt, _affil-line(affils))) }
      }
    },
    [],
    if date != none { eyebrow(date, fill: palette.ink, size: 7.5pt) },
  )))
]

// ---------------------------------------------------------------------------
// The template
// ---------------------------------------------------------------------------

#let report(
  title: [Untitled report],
  subtitle: none,
  short-title: none,         // running head; defaults to title
  kind: auto,                // eyebrow above the title; auto = "Technical report"
  authors: (),               // strings, or (name:, affiliation:, email:) dicts
  date: auto,                // auto = today; datetime, content, or none
  abstract: none,
  keywords: (),
  title-style: "modern",     // "modern" (left, solid abstract) | "classic" (centred, LaTeX \maketitle)
  cover: false,              // full cover page with a clay band
  toc: false,                // table of contents after the abstract
  paper: "a4",               // "a4" | "us-letter" | …
  tint: true,                // ivory page background; false = white (for print)
  font-size: 10.5pt,
  lang: "en",
  region: none,
  fallback-fonts: (),        // e.g. ("Noto Serif CJK SC",) for Chinese
  body,
) = {
  let (authors, affils) = _normalize-authors(authors)
  let date = if date == none { none } else { _fmt-date(date, lang) }
  let kind = if kind == auto { _t("report") } else { kind }
  let short-title = if short-title == none { title } else { short-title }
  let keywords = _as-array(keywords)
  let margin-x = 3.3cm
  let ff(list) = list + fallback-fonts

  set document(
    title: title,
    author: authors.map(a => a.name).filter(n => type(n) == str),
    keywords: keywords.filter(k => type(k) == str),
  )

  // --- Page --------------------------------------------------------------
  set page(
    paper: paper,
    fill: if tint { palette.paper } else { none },
    margin: (x: margin-x, top: 3.1cm, bottom: 3.2cm),
    numbering: "1",
    header-ascent: 38%,
    footer-descent: 40%,
    header: context {
      let p = here().page()
      let starts = query(<ca-main-start>)
      let first = if starts.len() > 0 { starts.first().location().page() } else { 1 }
      if p > first {
        // Running head: the first section starting on this page, else the one in effect.
        let hs = query(heading.where(level: 1))
        let on-page = hs.filter(h => h.location().page() == p)
        let before = hs.filter(h => h.location().page() < p)
        let current = if on-page.len() > 0 { on-page.first() } else if before.len() > 0 { before.last() }
        let section = if current != none {
          let hd = current
          if hd.numbering != none [#numbering(hd.numbering, ..counter(heading).at(hd.location()))#h(0.5em)]
          hd.body
        }
        set text(size: 7.5pt, fill: palette.muted)
        grid(
          columns: (1fr, auto),
          column-gutter: 2em,
          align: (left + bottom, right + bottom),
          [#mark(size: 0.5em, baseline: -0.02em)#h(0.6em)#text(font: ff(fonts.sans), tracking: 0.02em, short-title)],
          text(font: ff(fonts.caption), style: "italic", size: 8pt, section),
        )
        v(-2pt)
        line(length: 100%, stroke: 0.4pt + palette.rule)
      }
    },
    footer: context align(center, text(
      font: fonts.sans, size: 7.5pt, fill: palette.muted, counter(page).display(),
    )),
  )

  // --- Text & paragraphs -------------------------------------------------
  set text(
    font: ff(fonts.serif), size: font-size, fill: palette.ink,
    lang: lang, region: region, hyphenate: true,
  )
  set par(
    justify: true, leading: 0.72em, spacing: 0.72em,
    // LaTeX indents every paragraph but the first after a heading;
    // Chinese typesetting indents every paragraph by two characters.
    first-line-indent: if lang == "zh" { (amount: 2em, all: true) } else { (amount: 1.4em, all: false) },
  )
  show strong: set text(weight: 600)

  // --- Links, references, citations -------------------------------------
  show link: set text(fill: palette.clay-deep)
  show ref: set text(fill: palette.clay-deep)
  show cite: set text(fill: palette.clay-deep)
  // Equation references read "Eq. (3)", as with LaTeX's \eqref.
  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation and el.numbering != none {
      link(el.location(), [#el.supplement~#numbering(el.numbering, ..counter(math.equation).at(el.location()))])
    } else { it }
  }

  // --- Headings ------------------------------------------------------------
  set heading(numbering: "1.1", supplement: _t("section"))
  show heading: set text(hyphenate: false)
  show heading: set par(justify: false, first-line-indent: 0pt)

  let numbered(it, number-fill) = if it.numbering == none { it.body } else {
    grid(
      columns: (auto, 1fr), column-gutter: 0.7em,
      text(fill: number-fill, counter(heading).display(it.numbering)), it.body,
    )
  }

  show heading.where(level: 1): it => {
    counter(figure.where(kind: "ca-thm")).update(0)
    set text(font: ff(fonts.display), size: 15pt, weight: 400, tracking: -0.005em)
    block(above: 26pt, below: 13pt, sticky: true, numbered(it, palette.clay))
  }
  show heading.where(level: 2): it => {
    set text(font: ff(fonts.serif), size: 11pt, weight: 600)
    block(above: 19pt, below: 9pt, sticky: true, numbered(it, palette.clay-deep))
  }
  show heading.where(level: 3): it => {
    set text(font: ff(fonts.serif), size: font-size, weight: 600, style: "italic")
    block(above: 15pt, below: 7pt, sticky: true, numbered(it, palette.muted))
  }
  show heading.where(level: 4): it => {
    set text(font: ff(fonts.serif), size: font-size, style: "italic")
    block(above: 13pt, below: 6pt, sticky: true, it.body)
  }

  // --- Lists -------------------------------------------------------------------
  set list(
    marker: (mark(size: 0.3em, baseline: -0.2em), text(fill: palette.muted)[–]),
    indent: 0.5em, body-indent: 0.7em,
  )
  set enum(indent: 0.3em, body-indent: 0.6em)
  set terms(separator: h(0.6em), hanging-indent: 1.4em)
  show terms.item: it => block(above: 0.5em)[#text(weight: 600, it.term)#h(0.6em)#it.description]

  // --- Math --------------------------------------------------------------------
  show math.equation: set text(font: fonts.math, weight: 450)
  set math.equation(numbering: "(1)", supplement: _t("equation"))
  show math.equation.where(block: true): set block(above: 1.05em, below: 1.05em)

  // --- Code --------------------------------------------------------------------
  set raw(theme: "ivory.tmTheme")
  show raw: set text(font: fonts.mono, size: font-size * 0.8)
  show raw.where(block: false): it => box(
    fill: palette.ivory, inset: (x: 0.28em), outset: (y: 0.28em), radius: 1.5pt, it,
  )
  show raw.where(block: true): it => block(
    width: 100%, fill: palette.ivory, radius: 2pt, inset: (x: 12pt, y: 10pt),
    above: 1.3em, below: 1.3em,
    { set par(justify: false, leading: 0.58em); it },
  )

  // --- Footnotes ---------------------------------------------------------------
  set footnote.entry(
    separator: line(length: 22%, stroke: 0.4pt + palette.rule),
    gap: 0.45em, indent: 0em, clearance: 1.1em,
  )
  show footnote.entry: set text(font: ff(fonts.caption), size: 7.8pt, fill: palette.ink-soft)
  show footnote.entry: set par(leading: 0.55em, first-line-indent: 0pt)
  show footnote: set text(fill: palette.clay-deep)

  // --- Figures & captions ------------------------------------------------------
  set figure(gap: 0.9em)
  show figure: set block(above: 1.8em, below: 1.8em)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: it => {
    let label = text(font: fonts.sans, size: 7pt, weight: 600, tracking: 0.07em, fill: palette.clay-deep,
      upper[#it.supplement #context it.counter.display(it.numbering)])
    let content = [#label#h(0.75em)#text(font: ff(fonts.serif), size: 8.8pt, fill: palette.ink-soft, it.body)]
    set par(first-line-indent: 0pt, leading: 0.58em)
    // LaTeX behaviour: centre one-line captions, justify longer ones.
    layout(size => if measure(content).width <= size.width {
      align(center, content)
    } else {
      set par(justify: true)
      align(left, content)
    })
  }

  // Theorem-like environments render as run-in paragraphs, not floats.
  show figure.where(kind: "ca-thm"): set block(breakable: true)
  show figure.where(kind: "ca-thm"): it => block(width: 100%, above: 1.25em, below: 1.25em)[
    #set align(left)
    #set par(first-line-indent: 0pt)
    #text(weight: 600)[#it.supplement #context it.counter.display(it.numbering)]#if it.caption != none [ (#it.caption.body)]#text(weight: 600)[.]#h(0.45em)#it.body
  ]

  // --- Tables (booktabs) -------------------------------------------------------
  // Every table gets a heavy top and bottom rule and, if it has a
  // `table.header`, a light rule beneath the header. No vertical rules.
  set table(stroke: none, inset: (x: 0.6em, y: 0.42em))
  show table: set text(size: 0.9em, number-width: "tabular")
  show table: set par(justify: false)
  show table: it => {
    if it.has("label") and it.label == <ca-booktabs> { return it }
    let fields = it.fields()
    let children = fields.remove("children")
    let heavy = table.hline(stroke: 0.8pt + palette.ink)
    let light = table.hline(stroke: 0.4pt + palette.ink)
    let header-at = children.position(c => c.func() == table.header)
    let rows = if header-at == none { children } else {
      // Set header cells in semibold, then rule beneath them.
      let hdr = children.at(header-at)
      let hdr-fields = hdr.fields()
      let cells = hdr-fields.remove("children").map(c => if c.func() == table.cell {
        let f = c.fields()
        let b = f.remove("body")
        table.cell(..f, strong(b))
      } else { c })
      children.slice(0, header-at) + (table.header(..hdr-fields, ..cells), light) + children.slice(header-at + 1)
    }
    [#table(..fields, heavy, ..rows, heavy)<ca-booktabs>]
  }

  // --- Outline -----------------------------------------------------------------
  set outline(indent: auto, depth: 2)
  set outline.entry(fill: box(width: 1fr, repeat(gap: 0.45em, text(fill: palette.muted, size: 0.8em)[.])))
  show outline.entry.where(level: 1): it => {
    set block(above: 1.0em)
    set text(weight: 600)
    link(it.element.location(), text(fill: palette.ink, it.indented(
      text(fill: palette.clay-deep, it.prefix()),
      [#it.body()#h(1fr)#it.page()],
    )))
  }

  // --- Bibliography ------------------------------------------------------------
  set bibliography(title: _t("references"))
  show bibliography: set text(size: 0.88em)
  show bibliography: set par(first-line-indent: 0pt, justify: false, spacing: 0.7em, leading: 0.55em)

  // --- Front matter ------------------------------------------------------------
  if cover {
    _cover(title, subtitle, kind, authors, affils, date, margin-x)
    counter(page).update(1)
  }

  [#metadata(none)<ca-main-start>]

  if not cover {
    if title-style == "classic" {
      _title-classic(title, subtitle, kind, authors, affils, date)
    } else {
      _title-modern(title, subtitle, kind, authors, affils, date)
    }
  }

  if abstract != none {
    if title-style == "classic" { _abstract-classic(abstract, keywords) } else { _abstract-modern(abstract, keywords) }
  }

  if toc {
    block(above: 1.6em, below: 0.6em, eyebrow(_t("contents"), fill: palette.clay-deep))
    outline(title: none)
    pagebreak(weak: true)
  }

  body
}
