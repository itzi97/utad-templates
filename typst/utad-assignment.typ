// ============================================================
//  U-tad COMPACT ASSIGNMENT / problem-set template (Typst)
//
//  For short deliverables -- a handful of questions, ~2-5 pages. Unlike
//  utad.typ's report template there is NO cover page and NO separate
//  contents page: page 1 opens with a compact masthead (logo, title,
//  info box, rule), and the content flows straight on. Chapters do not
//  start new pages.
//
//  Usage:
//    #import "utad-assignment.typ": *
//    #show: assignment.with(
//      title: [Problem Set 3],
//      subtitle: [Series and Fourier Transforms],   // optional
//      subject: [Mathematical Analysis],
//      teacher: [Teacher Name],
//      author: "Your Name",
//      date: "May 24, 2026",
//      contents: true,          // optional inline contents list
//    )
//
//    = Question 1
//    ...
//
//  It re-exports everything from utad.typ, so the whole brand toolkit --
//  `callout`, `note`, `important`, `exercise`, `prompt`/`response`,
//  `utad-table` -- is available in an assignment too, same look as the
//  report. (The report-only report extras live in utad-report.typ.)
// ============================================================

#import "utad.typ": *

// Compact TWO-COLUMN info box for the assignment header: the fields are
// split into two side-by-side label|value mini-tables (first half left,
// second half right), with tighter row padding than the report cover's
// single-column box -- so the same details take about half the height.
// Bold muted-grey labels, navy values; empty fields are skipped.
#let compact-info(pairs) = {
  let rows = pairs.filter(p => p.at(1) != none)
  let half = calc.ceil(rows.len() / 2)
  let mini(rs) = table(
    columns: (auto, auto),
    align: (right + top, left + top),
    inset: (x, y) => (left: if x == 0 { 0pt } else { 9pt }, right: 0pt, top: 2.5pt, bottom: 2.5pt),
    stroke: none,
    ..rs.map(p => (
      text(fill: muted, weight: 700)[#p.at(0)],
      text(fill: utad-navy)[#p.at(1)],
    )).flatten()
  )
  grid(
    columns: (auto, auto),
    column-gutter: 1.4cm,
    mini(rows.slice(0, half)),
    mini(rows.slice(half)),
  )
}

#let assignment(
  title: [Assignment],
  subtitle: none,          // optional topic / subtitle line under the title
  subject: none,
  degree: none,
  year: none,
  teacher: none,
  author: "Your Name",
  date: none,
  logo-variant: "full",    // "full" | "wordmark" | "mark" | "none"
  contents: false,         // show a compact inline contents list after the header
  lang: "en",
  body,
) = {
  // ---- logo ----
  let logo-block = if logo-variant == "mark" {
    image("logo-mark.svg", width: 1.3cm)
  } else if logo-variant == "wordmark" {
    image("logo-wordmark.svg", width: 2.5cm)
  } else if logo-variant == "full" {
    image("logo-full.svg", width: 4.6cm)
  } else { none }

  set document(
    title: if type(title) == str { title } else { "U-tad assignment" },
    author: author,
  )
  set text(font: sansfont, size: 10.5pt, fill: ink, lang: lang)
  set par(justify: true, leading: 0.64em, spacing: 0.8em)
  show link: set text(fill: utad-blue)
  set heading(numbering: "1.1")

  // heading number: light-blue number + gap, same as the report
  let hnum(it) = context {
    if it.numbering != none {
      text(fill: utad-blue)[#numbering(it.numbering, ..counter(heading).at(it.location()))]
      h(0.45em)
    }
  }
  // COMPACT headings: no page breaks (a 2-5 page doc flows continuously),
  // modest sizes. Level-1 keeps the house-style navy underline rule.
  show heading.where(level: 1): it => block(above: 1.2em, below: 0.7em, sticky: true, {
    set text(fill: utad-navy, size: 13.5pt, weight: 700, font: headingfont)
    stack(spacing: 5pt,
      { hnum(it); it.body },
      line(length: 100%, stroke: 0.5pt + utad-navy),
    )
  })
  show heading.where(level: 2): it => block(above: 1em, below: 0.55em, sticky: true, {
    set text(fill: utad-navy, size: 12pt, weight: 700, font: headingfont)
    hnum(it); it.body
  })
  show heading.where(level: 3): it => block(above: 0.85em, below: 0.5em, sticky: true, {
    set text(fill: utad-navy, size: 11pt, weight: 700, font: headingfont)
    hnum(it); it.body
  })

  // code -- same look as the report, line numbers in a grey gutter
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
  show raw.where(block: false): it => box(
    fill: rgb("#eef1f6"), inset: (x: 3pt), outset: (y: 3pt), radius: 0pt,
  )[#text(size: 0.92em, font: monofont, fill: ink)[#it]]

  set figure(gap: 8pt)
  show figure.caption: set text(size: 9pt, fill: muted)

  // outline styling (used only if `contents: true`) -- compact, inline
  set outline(depth: 2, indent: auto)
  let toc-entry(it, w, color: utad-navy) = link(it.element.location(), it.indented(
    text(fill: utad-blue, weight: w, font: headingfont)[#it.prefix()],
    text(fill: color, weight: w, font: headingfont)[#it.inner()],
  ))
  show outline.entry.where(level: 1): it => { v(4pt, weak: true); toc-entry(it, 600, color: utad-navy) }
  show outline.entry.where(level: 2): it => { v(2pt, weak: true); toc-entry(it, 400, color: muted) }

  // ---- page: normal margins, simple header/footer, NO cover ----
  set page(
    paper: "a4",
    margin: (x: 2.5cm, top: 2.2cm, bottom: 2cm),
    header: context {
      // running header only from page 2 on -- page 1 has the masthead
      if counter(page).get().first() > 1 {
        set text(size: 8.5pt, fill: muted)
        grid(columns: (1fr, 1fr), align(left)[#title], align(right)[#author])
        v(4pt)
        line(length: 100%, stroke: 0.5pt + rgb("#c9d3e2"))
      }
    },
    footer: {
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

  // ============ COMPACT MASTHEAD (top of page 1) ============
  // Title (left) and logo (right) share one line; a compact two-column
  // info box sits below, then the navy rule -- a tight header that leaves
  // the page for the actual content.
  block(width: 100%, breakable: false, {
    // Title and logo share one line, the logo vertically centered on the
    // title; the optional subtitle drops onto its own line below.
    grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      column-gutter: 0.8cm,
      text(size: 20pt, weight: 700, fill: utad-navy, font: headingfont)[#title],
      logo-block,
    )
    if subtitle != none {
      v(0.1cm)
      text(size: 11.5pt, weight: 500, fill: utad-blue, font: headingfont)[#subtitle]
    }
    v(0.42cm)
    compact-info((
      ([Subject], subject),
      ([Degree], degree),
      ([Year], year),
      ([Teacher], teacher),
      ([Author], author),
      ([Date], date),
    ))
    v(0.45cm)
    line(length: 100%, stroke: 1pt + utad-navy)
  })
  v(0.4cm)

  // ---- optional inline contents (never on its own page) ----
  if contents {
    block(breakable: false, {
      text(size: 12pt, weight: 700, fill: utad-navy, font: headingfont)[Contents]
      v(0.18cm)
      outline(title: none)
    })
    v(0.35cm)
    line(length: 100%, stroke: 0.5pt + hairline)
    v(0.4cm)
  }

  body
}
