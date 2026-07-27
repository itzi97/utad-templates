// ============================================================
//  U-tad report / exercise template for Typst
//  Import it with:  #import "utad.typ": *
//  Then:            #show: utad-doc.with(title: [...], author: "...", ...)
// ============================================================

// ---------- Brand palette (edit here to retune) ----------
#let utad-navy = rgb("#14192c")   // MAIN accent (U-tad logo ink): banners, H1/H2, tables, borders
#let utad-blue = rgb("#1b5fe0")   // OCCASIONAL accent (site blue): accent rule, H3, links, buttons
//   ^ matches utadblue in utad.sty exactly (#1B5FE0) -- both were
//     originally eyeballed from the site separately and had drifted
//     apart (#1b7bec here vs #1B5FE0 there); synced to one hex so the
//     two templates are the same brand, not just similar.
#let ink       = rgb("#16233b")   // body text
#let muted     = rgb("#5a6b83")   // headers/footers, captions
#let hairline  = rgb("#dfe5ee")
#let callbg    = rgb("#eef2f8")   // callout background
#let codebg    = rgb("#f4f6fa")   // code background

// Fonts. Matched to the LaTeX side (Poppins headings / Carlito body, via
// fontspec there) so a reader flipping between the two templates sees the
// same typeface, not just the same palette. Install both with
// `scripts/install-fonts.sh` (see the README).
//
// These are single families on purpose: Typst warns "unknown font family"
// for EVERY family in a stack that isn't installed, so a cross-platform
// fallback list (Helvetica Neue / Arial / …) prints noisy warnings on every
// compile even when Poppins/Carlito are present. `DejaVu Sans Mono` is one
// of Typst's built-in fonts, so it's always available. If you DO see
// "unknown font family: Poppins" (or Carlito), the fonts aren't installed —
// run the font script.
#let headingfont = "Poppins"
#let sansfont = "Carlito"
#let monofont = "DejaVu Sans Mono"

// Flatten content to a plain string, for `set document(title: ...)` (PDF
// metadata / viewer tab). Callers pass `title: [markup]`, which is content,
// not a string -- the old `if type(title) == str` guard therefore always
// fell through to a generic "U-tad document" fallback, so every report
// showed the same wrong title in a viewer tab and file listing. This walks
// the usual content shapes (text, sequences, wrapped bodies) and joins the
// text runs. Observed: with `title: [Image Classification with CNNs]`, pypdf
// read back "U-tad document" before and the real title after.
#let to-plain-string(it) = {
  if it == none { "" }
  else if type(it) == str { it }
  else if type(it) == content {
    if it.has("text") { it.text }
    else if it.has("children") { it.children.map(to-plain-string).join("") }
    else if it.has("body") { to-plain-string(it.body) }
    else if it.has("child") { to-plain-string(it.child) }
    else { "" }
  } else { str(it) }
}

// Squared, on-identity list markers -- the parity match to the LaTeX
// \setlist squares. Typst's default nested markers are •, then a dash (‣/-)
// at deeper levels, which is the same off-identity dash the LaTeX side had.
// Small filled squares instead: navy (dominant) at level 1, the blue accent
// at level 2, grey at level 3. Fed to `set list(marker: ...)` in each
// template's setup (utad-doc and assignment).
#let utad-sqmark(c, s) = box(baseline: 0.02em, square(size: s, fill: c, stroke: none))
#let utad-list-markers = (
  utad-sqmark(utad-navy, 0.30em),
  utad-sqmark(utad-blue, 0.26em),
  utad-sqmark(muted, 0.24em),
)

// ---------- A text U-tad wordmark (fallback when no logo image) ----------
#let utad-wordmark = align(center)[
  #box(fill: utad-navy, inset: (x: 11pt, y: 7pt), radius: 0pt,
    text(fill: white, weight: 700, size: 21pt)[U-tad])
  #v(4pt)
  #text(fill: muted, size: 7pt, weight: 600, tracking: 0.6pt)[
    UNIVERSITY OF TECHNOLOGY, ARTS AND DESIGN]
]

// ============================================================
//  Callouts
// ============================================================
#let callout(body, title: none, accent: utad-navy, bg: callbg) = block(
  width: 100%, fill: bg, radius: 0pt, inset: (x: 11pt, y: 9pt),
  stroke: (left: 3pt + accent), above: 0.75em, below: 0.75em,
)[
  // force left alignment so the box reads correctly even inside a centred
  // context (e.g. a centre-aligned slide)
  #set align(left)
  #if title != none [ #text(weight: 700, fill: accent)[#title]#v(3pt, weak: false) ]
  #body
]

// Inline-titled variants that match the report's AI boxes
#let prompt(body) = block(
  width: 100%, fill: callbg, radius: 0pt, inset: (x: 11pt, y: 9pt),
  stroke: (left: 3pt + utad-navy), above: 0.75em, below: 0.75em,
)[#text(weight: 700)[Prompt: ]#text(style: "italic")[#body]]

#let response(body) = block(
  width: 100%, fill: callbg, radius: 0pt, inset: (x: 11pt, y: 9pt),
  stroke: (left: 3pt + utad-navy), above: 0.75em, below: 0.75em,
)[#text(weight: 700)[Response: ]#body]

#let note(body, title: "Note") = callout(body, title: title, accent: utad-blue)

// The navy-accent sibling of note(): same left-border callout shape as the
// blue note/callout boxes, but keyed to the dark-navy accent instead of the
// bright blue -- navy title, navy left rule, and a LIGHT navy-tint
// background (rgb("#e6e8ef"), a lightened version of the navy ink, cooler
// and greyer than the note box's light-blue #eef2f8 so the two read as
// distinct-but-related). Used for the one or two notices per document that
// should carry the heavier navy accent rather than the everyday blue one.
// (Was a solid navy fill with reversed white text; changed to match the
// light callout family so all the status boxes share one visual language.)
#let important(body, title: "Important") = callout(
  body, title: title, accent: utad-navy, bg: rgb("#e6e8ef"),
)

// ============================================================
//  Titled exercise / problem box
// ============================================================
#let exercise(title, body) = block(
  width: 100%, above: 1.2em, below: 1em, breakable: true,
  stroke: 0.6pt + hairline, radius: 0pt, clip: true,
)[
  #stack(
    block(fill: utad-navy, inset: (x: 11pt, y: 6pt), width: 100%,
      text(fill: white, weight: 700)[#title]),
    block(inset: (x: 11pt, y: 9pt), width: 100%, body),
  )
]

// ============================================================
//  Question / Solution convention (for solution sets)
// ============================================================
// For a solutions document -- one where you restate the given problem and
// then work it -- put the verbatim problem statement in `question[...]` and
// let your worked answer flow underneath, opened with `solution`. The box
// is a LIGHT tinted panel with a navy left rule and a small "QUESTION"
// eyebrow: enough to set the given task apart from your work, without the
// heavy dark bar of `exercise()` (which would double up under a numbered
// "Exercise N" heading). Pair with a numbered level-1 heading per item.
#let question(body, label: "Question") = block(
  width: 100%, fill: rgb("#eef2f8"), radius: 0pt, inset: (x: 11pt, y: 9pt),
  stroke: (left: 3pt + utad-navy), above: 0.75em, below: 0.9em, breakable: true,
)[
  #text(weight: 700, fill: muted, size: 0.78em)[#upper(label)]
  #v(3pt, weak: true)
  #body
]

// Run-in "Solution." lead-in for the worked answer under a question box.
// Use inline for a prose answer (`#solution[The radius is ...]`) or just as
// a label before block content (code, displayed math): `#solution[]` then
// the blocks on following lines.
#let solution(body) = { text(weight: 700, fill: utad-navy)[Solution.]; if body != [] { [ ]; body } }

// ============================================================
//  Helper tables
// ============================================================
// A striped table with a navy header row.
#let utad-table(columns: auto, header: (), cell-align: left,
    inset: (x: 10pt, y: 8pt), ..rows) = table(
  columns: columns,
  // explicit cell alignment so an outer centred context (e.g. a centre-
  // aligned slide) doesn't centre the cells; pass a function for per-column
  // control, e.g. (col, row) => if col == 0 { left } else { center }
  align: cell-align,
  stroke: none,
  // cell padding — bump `inset` (esp. the y value) for roomier rows on slides
  inset: inset,
  // Zebra stripe is #eef3fc -- the exact same tint as the LaTeX side's
  // utadlight zebra row, so a table looks identical across the two
  // templates. (Was #f5f8fc here, noticeably fainter than LaTeX's stripe;
  // synced so the striping reads with the same strength in both.)
  fill: (_, y) => if y == 0 { utad-navy } else if calc.odd(y) { rgb("#eef3fc") } else { white },
  table.header(..header.map(h => text(fill: white, weight: 700)[#h])),
  ..rows.pos(),
)

// A cover metadata table (right-aligned blue labels | values), like the notes cover.
#let info-table(..pairs) = align(center, table(
  columns: 2, stroke: none, align: (right, left), inset: (x: 8pt, y: 3pt),
  ..pairs.pos().map(p => (text(fill: utad-navy, weight: 600)[#p.at(0)], [#p.at(1)])).flatten(),
))

// Cover metadata block: bold muted-grey labels (right-aligned, same grey
// as the "ACADEMIC DIVISION" eyebrow above), then values in navy
// (left-aligned) -- a clean two-column "spec sheet", no divider rule.
//
// The label column is `auto` (width of the widest label), and the label
// cell's LEFT inset is 0, so the widest label sits exactly on the page's
// left margin -- the block anchors on the same left edge as the logo and
// title above it (the cover's organizing principle) instead of floating
// inset. The value column carries the only horizontal gap (its 14pt left
// inset), so label and value are cleanly separated by whitespace alone.
// (Skips empty fields.)
#let cover-info(pairs) = table(
  columns: (auto, 1fr),
  align: (right + top, left + top),
  inset: (x, y) => (
    left: if x == 0 { 0pt } else { 14pt },
    right: 0pt,
    top: 5pt, bottom: 5pt,
  ),
  stroke: none,
  ..pairs.filter(p => p.at(1) != none).map(p => (
    text(fill: muted, weight: 700)[#p.at(0)],
    text(fill: utad-navy)[#p.at(1)],
  )).flatten()
)

// ============================================================
//  The main document template
// ============================================================
// ============================================================
//  Evolution-chain diagram
// ============================================================
// A horizontal chain of small labelled boxes connected by arrows —
// used for "version 1 -> version 2 -> ... " style progressions.
// Each item is (version-label, description, style), where style is
// one of "start" (muted grey, for a received/legacy starting point),
// "mid" (light navy-tinted, in-progress), or "final" (solid navy,
// the arrived-at/highlighted endpoint). Mirrors the LaTeX report's
// schema-evolution-chain TikZ diagrams.
#let evo-box(version, label, style: "mid") = {
  let (bg, fg, bd) = if style == "start" {
    (white, muted, muted)
  } else if style == "final" {
    (utad-navy, white, utad-navy)
  } else {
    (rgb("#eef2f8"), utad-navy, utad-navy)
  }
  box(
    width: 100%, height: 1.5cm,
    fill: bg, stroke: 1pt + bd, radius: 0pt, inset: 5pt,
    align(center + horizon)[
      #text(fill: fg, size: 10pt, weight: 700)[#version] \
      #v(1pt, weak: true)
      #text(fill: fg, size: 8.5pt)[#label]
    ],
  )
}

// Small helper: split an array into chunks of at most `n` items.
#let chunk(arr, n) = {
  let out = ()
  let i = 0
  while i < arr.len() {
    out.push(arr.slice(i, calc.min(i + n, arr.len())))
    i += n
  }
  out
}

// Boxes get `1fr` columns (so Typst divides the available width equally
// among however many items are in that row) and arrows get `auto`
// columns (small, fixed). This is the important part: never give the
// boxes a fixed absolute width, or they'll overlap/overflow instead of
// shrinking to fit. `per-row` controls how many boxes share one row
// before wrapping to the next -- keep this low enough (3-4) that each
// box stays wide enough for its label not to wrap into a cramped tower
// of single words.
#let evolution-chain(..items, per-row: 4) = {
  let parts = items.pos()
  let rows = chunk(parts, per-row)
  stack(spacing: 7pt, ..rows.map(row-items => align(center, {
    let n = row-items.len()
    let cols = ()
    for i in range(n) {
      cols.push(1fr)
      if i < n - 1 { cols.push(auto) }
    }
    grid(
      columns: cols,
      column-gutter: 3pt,
      align: horizon,
      ..row-items.enumerate().map(((i, it)) => {
        let b = evo-box(it.at(0), it.at(1), style: it.at(2, default: "mid"))
        if i == 0 { (b,) } else { (text(fill: muted, size: 13pt)[→], b) }
      }).flatten()
    )
  })))
}

#let utad-doc(
  title: [Document title],
  subtitle: none,
  subject: none,         // shown in the cover info box (not the title)
  degree: [Computer Science],
  year: none,
  teacher: none,
  author: "Your Name",
  date: none,
  variant: "full",       // logo variant: "full" | "wordmark" | "mark" | "text" | "none"
                         //   full     = mark + "U-tad" + "University of Technology,
                         //              Arts & Design" tagline (logo-full.svg) --
                         //              the default for the cover
                         //   wordmark = just the mark + "U-tad" (logo-wordmark.svg)
                         //   mark     = just the rounded-U mark (logo-mark.svg)
  logo: none,            // custom logo image path; overrides `variant` if set
  logo-width: auto,      // override the cover logo width if you like
  lang: "en",
  short-title: auto,     // running-header title; defaults to `title`
  body,
) = {
  let short = if short-title == auto { title } else { short-title }

  // Pick the cover logo — DARK ink, since it now sits standalone in the
  // white body (masthead-style), not on a navy band.
  let logo-block = if logo != none {
    image(logo, width: if logo-width == auto { 4.5cm } else { logo-width })
  } else if variant == "mark" {
    image("logo-mark.svg", width: if logo-width == auto { 1.4cm } else { logo-width })
  } else if variant == "wordmark" {
    image("logo-wordmark.svg", width: if logo-width == auto { 2.7cm } else { logo-width })
  } else if variant == "full" {
    // Full lockup: mark + wordmark + "University of Technology, Arts &
    // Design" tagline. Wider than the bare wordmark, so its default width
    // is larger to keep the mark itself a comparable size.
    image("logo-full.svg", width: if logo-width == auto { 5.2cm } else { logo-width })
  } else if variant == "text" {
    text(fill: utad-navy, weight: 700, size: 21pt)[U-tad]
  } else { none }

  set document(title: to-plain-string(title), author: author)
  set text(font: sansfont, size: 10.5pt, fill: ink, lang: lang)
  set par(justify: true, leading: 0.64em, spacing: 0.8em)
  set list(marker: utad-list-markers)   // squared, on-identity (see utad.typ)
  show link: set text(fill: utad-blue)
  set heading(numbering: "1.1")

  // --- Heading styles: light-blue number + dark title, kept with the content ---
  let hnum(it) = context {
    if it.numbering != none {
      text(fill: utad-blue)[#numbering(it.numbering, ..counter(heading).at(it.location()))]
      h(0.45em)
    }
  }
  // Heading scale + spacing matched to the LaTeX side (\Huge chapter /
  // \Large section / \large subsection = ~24 / 14 / 12pt) so the two
  // templates share one heading hierarchy. Level-1 headings also start a
  // new page (weak pagebreak, so no blank page when already at the top) --
  // the report convention the LaTeX `report` class applies, giving each
  // top-level section its own opening page. Sizes below body (10.5pt) are
  // avoided so every level stays clearly above running text.
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    block(above: 0pt, below: 26pt, sticky: true, {
      set text(fill: utad-navy, size: 24pt, weight: 700, font: headingfont)
      stack(spacing: 9pt,
        { hnum(it); it.body },
        line(length: 100%, stroke: 0.5pt + utad-navy),   // discrete dark divider
      )
    })
  }
  show heading.where(level: 2): it => block(above: 17pt, below: 10pt, sticky: true, {
    set text(fill: utad-navy, size: 14pt, weight: 700, font: headingfont)
    hnum(it); it.body
  })
  show heading.where(level: 3): it => block(above: 13pt, below: 8pt, sticky: true, {
    set text(fill: utad-navy, size: 12pt, weight: 700, font: headingfont)
    hnum(it); it.body
  })

  // --- Code ---
  // Block code carries line numbers down the left in a small grey gutter
  // (matching the LaTeX `numbers=left` listing). `raw.line` gives each
  // line its number + body; the number is right-aligned in a fixed-width
  // box so the gutter edge stays straight regardless of digit count.
  show raw.where(block: true): it => block(
    width: 100%, fill: codebg, radius: 0pt, inset: 9pt,
    stroke: 0.6pt + hairline, above: 0.8em, below: 0.8em,
  )[
    #set text(size: 8.6pt, font: monofont)
    #show raw.line: ln => {
      box(width: 1.6em, align(right, text(fill: muted)[#ln.number]))
      h(0.9em)
      ln.body
    }
    #it
  ]
  // Inline code always sits on its own light-grey chip, even when the
  // surrounding paragraph text has been set to white (e.g. inside the
  // dark-navy `important()` box) -- so it must force its own dark text
  // color rather than inherit, or it renders as invisible white-on-light-
  // grey. Confirmed by rendering `important()` with inline code in it.
  show raw.where(block: false): it => box(
    fill: rgb("#eef1f6"), inset: (x: 3pt), outset: (y: 3pt), radius: 0pt,
  )[#text(size: 0.92em, font: monofont, fill: ink)[#it]]

  // --- Figures / outline ---
  set figure(gap: 8pt)
  show figure.caption: set text(size: 9pt, fill: muted)
  set outline(depth: 3, indent: auto)
  // TOC: light-blue number + title, styled to match the LaTeX side's
  // tocloft setup -- chapter-level entries bold navy headingfont (like
  // \cftchapfont), section/subsection entries a lighter, unbolded grey
  // (like \cftsecfont / \cftsubsecfont) -- plus generous spacing between
  // top-level entries so the list reads with the same rhythm as the
  // LaTeX contents page instead of feeling cramped.
  let toc-entry(it, w, color: utad-navy) = link(it.element.location(), it.indented(
    text(fill: utad-blue, weight: w, font: headingfont)[#it.prefix()],
    text(fill: color, weight: w, font: headingfont)[#it.inner()],
  ))
  // Sub-entries right under their parent (the first child -- its heading
  // counter's last component is 1) sit close to it; later siblings get
  // more room between each other -- otherwise every level-2/3 entry gets
  // the same gap and the list either reads as "parent floating far from
  // its own children" or "every entry mashed together", never both right.
  let is-first-child(it) = {
    let nums = counter(heading).at(it.element.location())
    nums.len() > 0 and nums.last() == 1
  }
  show outline.entry.where(level: 1): it => { v(14pt, weak: true); toc-entry(it, 700, color: utad-navy) }
  show outline.entry.where(level: 2): it => {
    v(if is-first-child(it) { 5pt } else { 9pt }, weak: true)
    toc-entry(it, 400, color: muted)
  }
  show outline.entry.where(level: 3): it => {
    v(if is-first-child(it) { 4pt } else { 7pt }, weak: true)
    toc-entry(it, 400, color: muted)
  }

  // ---------------- COVER PAGE ----------------
  // Masthead layout: thin navy accent strips top and bottom (a color
  // detail, not a container) -- both utaddark, not utadblue, since a
  // bright-blue band read as a different palette from the rest of this
  // navy-dominant identity and clashed hard against the dark navy used
  // everywhere else. The logo sits standalone in the white body,
  // left-aligned, and the eyebrow/title/degree/metadata all share that
  // same left margin -- one consistent left edge anchors the page,
  // rather than centering everything.
  page(margin: 0pt, header: none, footer: none, numbering: none)[
    #place(top, rect(width: 100%, height: 0.35cm, fill: utad-navy))
    #place(bottom, rect(width: 100%, height: 0.35cm, fill: utad-navy))
    #pad(left: 2.5cm, right: 2.5cm, top: 2.5cm, bottom: 2.5cm)[
      #v(0.3cm)
      #logo-block
      // Vertical rhythm: the slack is split into two flexible gaps (1.15fr
      // above the title block, 1fr below it) instead of one fixed gap
      // above and all the slack below. That lands the title just above the
      // optical centre with balanced breathing room above and below, and
      // keeps the metadata anchored at the foot -- rather than the title
      // floating in the upper third over one big dead zone. The ratio is
      // >1 above so the title sits a touch below dead-centre (more
      // grounded); it adapts automatically as the metadata block grows
      // (e.g. the 10-field internship cover vs. a 5-field one).
      #v(1.15fr)
      // The subtitle / title / degree lines are wrapped in a scope with
      // paragraph spacing set to 0, so ONLY the explicit v() gaps below
      // apply. Without this, Typst's inter-paragraph spacing (0.8em) stacks
      // on top of each v(), pushing the three lines ~0.3-0.5cm further apart
      // than the identical 0.15cm/0.55cm gaps on the LaTeX cover -- i.e. the
      // Typst title read as too loosely spaced next to LaTeX's. Zeroing par
      // spacing here makes the two title blocks match line-for-line.
      #[
        #set par(spacing: 0pt)
        // justify: false so the left-anchored display lines are NOT
        // justified. The document sets par(justify: true) globally; without
        // overriding it here, a title (or degree) that wraps to a second
        // line has its first line stretched to full width, inflating the
        // inter-word spaces (a wide gap between the first two words).
        #set par(justify: false)
        #if subtitle != none [
          #text(size: 12pt, fill: muted, tracking: 0.5pt, font: headingfont)[#upper(subtitle)]
          #v(0.6cm)
        ]
        #text(size: 34pt, weight: 700, fill: utad-navy, font: headingfont)[#upper(title)]
        #v(0.82cm)
        #text(size: 14pt, weight: 400, fill: utad-blue, font: headingfont)[#degree]
      ]
      #v(1fr)
      #line(length: 100%, stroke: 1pt + utad-blue)
      #v(0.5cm)
      #cover-info((
        ([Subject], subject),
        ([Year], year),
        ([Teacher], teacher),
        ([Author], author),
        ([Date], date),
      ))
    ]
  ]

  // ---------------- MAIN PAGES ----------------
  set page(
    paper: "a4",
    margin: (x: 2.5cm, top: 2.5cm, bottom: 2cm),
    // Page 1 of the body is the front-matter contents page: keep it clean
    // (no running header, no footer/page number), the same treatment as the
    // cover and the LaTeX `\utadcontents`. The header/footer appear from the
    // first numbered content page (page 2) onward.
    header: context if counter(page).get().first() > 1 {
      set text(size: 8.5pt, fill: muted)
      // Right side shows the CURRENT section (last level-2 heading that starts
      // on or before this page), mirroring the LaTeX `\rightmark` header —
      // not the author. Empty on a chapter's opening pages before its first
      // section, exactly like the LaTeX side.
      let cur = counter(page).get().first()
      let secs = query(heading.where(level: 2)).filter(h =>
        counter(page).at(h.location()).first() <= cur)
      let sec = if secs.len() > 0 {
        let h = secs.last()
        [#numbering("1.1.", ..counter(heading).at(h.location())) #h.body]
      } else { [] }
      grid(columns: (1fr, 1fr), align(left)[#short], align(right)[#sec])
      v(5pt)
      line(length: 100%, stroke: 0.5pt + rgb("#c9d3e2"))
    },
    footer: context if counter(page).get().first() > 1 {
      set text(size: 8.5pt, fill: muted)
      line(length: 100%, stroke: 0.5pt + hairline)
      v(2pt)
      grid(columns: (1fr, 1fr), align: horizon,
        image("logo-mark.svg", height: 9pt),
        align(right)[#context counter(page).display()],
      )
    },
    numbering: "1",
  )
  counter(page).update(1)
  body
}

// Clean front-matter contents page: the table of contents as the first body
// page, which the template keeps free of the running header and footer/page
// number (see the page setup above) -- the same front-matter treatment as
// the cover, matching the LaTeX `\utadcontents`. Use this in the report body
// in place of a bare `#outline(...)`; content that follows starts on the
// first numbered page (page 2). Keep the TOC to a single page for the clean
// treatment to cover all of it.
#let utad-outline(title: [Contents], ..args) = {
  outline(title: title, ..args.named(), ..args.pos())
  pagebreak(weak: true)
}
