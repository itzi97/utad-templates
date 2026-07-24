// ============================================================
//  U-tad SLIDE theme (Typst, 16:9) — brand-matched presentations
//
//  A self-contained slide deck theme in the same visual identity as the
//  report and assignment templates: navy-dominant palette, blue accent,
//  Poppins headings / Carlito body, the full-logo title slide, navy section
//  dividers, and content slides with a title rule + logo footer. It re-uses
//  everything from utad.typ, so the callout boxes (`note`, `important`,
//  `exercise`, …) and `utad-table` work on slides too, and the diagram
//  helpers from utad-report.typ (`timeline`, `orgchart`, `evolution-chain`)
//  can be dropped onto a slide by also importing that module.
//
//  Deliberately built with Typst core primitives only — NO external package
//  (no Touying/Polylux) — so it compiles offline, exactly like the rest of
//  this kit. Keep the logo `.svg` files in the same folder.
//
//  Usage:
//    #import "utad-slides.typ": *
//
//    #title-slide(
//      title: [Presentation Title],
//      subtitle: [Optional subtitle],
//      author: "Your Name",
//      date: "May 2026",
//      event: [Course · U-tad],
//    )
//
//    #section-slide[1 · Motivation]
//
//    #slide(title: [A content slide])[
//      - point one
//      - point two
//    ]
//
//    #focus-slide[One big idea.]
// ============================================================

#import "utad.typ": *

// Tracks the current section (set by `section-slide`) so every content slide
// can show a subtle section tag by its title.
#let _utad-section = state("utad-section", none)

// A big hero number + caption, tightly spaced (the number's line box is
// trimmed to the glyph so the caption sits close). For a stat/headline slide.
#let stat(number, caption) = {
  block(spacing: 0pt, text(size: 60pt, weight: 700, fill: utad-blue,
    font: headingfont, top-edge: "cap-height", bottom-edge: "baseline")[#number])
  v(0.5cm)
  text(size: 19pt, fill: muted)[#caption]
}

// 16:9, generous margins tuned for on-screen reading
#let _slide-margin = (x: 1.7cm, top: 1.4cm, bottom: 1.2cm)

// ---------- Title slide ----------
// White body with thin navy strips top & bottom (matching the report cover),
// the full logo lockup, a large navy title, an optional blue subtitle, and a
// muted metadata block at the foot.
#let title-slide(
  title: [Presentation Title],
  subtitle: none,
  author: none,
  date: none,
  event: none,
  logo-variant: "full",
) = {
  let logo = if logo-variant == "mark" { image("logo-mark.svg", height: 1cm) }
    else if logo-variant == "wordmark" { image("logo-wordmark.svg", width: 3.2cm) }
    else { image("logo-full.svg", width: 6cm) }
  page(
    paper: "presentation-16-9", margin: 0pt, header: none, footer: none, fill: white,
    {
      place(top, rect(width: 100%, height: 0.45cm, fill: utad-navy))
      place(bottom, rect(width: 100%, height: 0.45cm, fill: utad-navy))
      pad(x: 2.2cm, top: 1.9cm, bottom: 1.7cm, {
        logo
        v(1fr)
        text(font: headingfont, size: 38pt, weight: 700, fill: utad-navy)[#title]
        if subtitle != none {
          v(0.25cm)
          text(font: headingfont, size: 20pt, weight: 500, fill: utad-blue)[#subtitle]
        }
        v(1fr)
        set text(font: sansfont, size: 15pt, fill: muted)
        if event != none { text(fill: utad-navy, weight: 600)[#event]; linebreak() }
        if author != none { text(fill: ink)[#author] }
        if author != none and date != none [ #h(0.5em)·#h(0.5em) ]
        if date != none [#date]
      })
    },
  )
}

// ---------- Section divider ----------
// Full navy background; the large white section title sits on a blue accent
// underline the width of the text (a box shrinks to the text, so the rule
// matches its width). Also records the section so the following content
// slides can show it as a tag next to their title; pass `tag:` for a shorter
// version to show there (defaults to the full section title).
#let section-slide(body, tag: auto) = {
  _utad-section.update(if tag == auto { body } else { tag })
  page(
    paper: "presentation-16-9", margin: (x: 2.2cm, y: 1.8cm),
    header: none, footer: none, fill: utad-navy,
    align(horizon,
      box(stack(spacing: 0.32cm,
        text(font: headingfont, size: 40pt, weight: 700, fill: white)[#body],
        line(length: 100%, stroke: 3pt + utad-blue),
      )),
    ),
  )
}

// Scale any content to FILL the current region (up to the given ratios),
// keeping aspect ratio and centring it. Used by `slide(fit: true)` to blow a
// diagram/image up so it fills the slide body. `top-pad` reserves a little
// breathing room under the title; the content is then centred in the region
// BELOW that pad (a real box with a defined height, so centring is reliable
// even for a wide-and-short diagram).
#let fit-region(body, width-ratio: 0.98, height-ratio: 0.92, top-pad: 12pt) = layout(size => {
  let m = measure(body)
  if m.width == 0pt or m.height == 0pt { return align(center + horizon, body) }
  let region-h = size.height - top-pad
  let s = calc.min(
    size.width * width-ratio / m.width,
    region-h * height-ratio / m.height,
  )
  pad(top: top-pad, box(width: 100%, height: region-h,
    align(center + horizon, scale(x: s * 100%, y: s * 100%, reflow: true, body))))
})

// ---------- Content slide ----------
// Optional navy title with an underline rule, a logo-mark + page-number
// footer, and the body set in the house body font. The body sits in a region
// that fills the space below the title, so content is vertically balanced
// (not stuck to the top). Options:
//   align-center: true  — horizontally centre the body (text, tables, images)
//   fit: true           — scale the body to FILL the region (for one big
//                         diagram/image/chart per slide)
#let slide(title: none, align-center: false, fit: false, body) = page(
  paper: "presentation-16-9", margin: _slide-margin,
  header: none,
  // Footer spans the full body width (page margins already inset it), so the
  // logo-mark sits at the left edge and the page number at the right edge.
  footer: {
    set text(size: 13pt, fill: muted)
    grid(columns: (1fr, 1fr), align: (left + horizon, right + horizon),
      image("logo-mark.svg", height: 16pt),
      context [#counter(page).display()])
  },
  // Capture the real page-body height so the grid's 1fr row (and the fit /
  // vertical-centring inside it) has a defined region to fill. A bare
  // block(height: 100%) does not reliably fill the page body in flow.
  layout(size => block(width: 100%, height: size.height, {
    set text(font: sansfont, size: 20pt, fill: ink)
    set par(leading: 0.65em)
    show list: set block(spacing: 0.6em)
    grid(
      // No fixed gutter: a fixed gap would only appear on top and make the
      // body look low. `fit` content gets its own top gap; centred content
      // centres cleanly between the title rule and the footer.
      rows: (auto, 1fr), row-gutter: 0pt,
      // ---- title row (auto height): title left, section tag right ----
      if title != none {
        stack(spacing: 3pt,
          grid(columns: (1fr, auto), column-gutter: 12pt,
            align: (left + bottom, right + bottom),
            text(font: headingfont, size: 27pt, weight: 700, fill: utad-navy)[#title],
            context {
              let s = _utad-section.get()
              if s != none {
                text(font: headingfont, size: 13pt, fill: muted)[#s]
              }
            },
          ),
          line(length: 100%, stroke: 1pt + utad-navy),
        )
      } else { [] },
      // ---- body row (fills remaining height) ----
      if fit {
        fit-region(body)
      } else {
        align((if align-center { center } else { left }) + horizon, body)
      },
    )
  })),
)

// ---------- Focus slide ----------
// A single large statement centred on a navy field — for a key takeaway.
#let focus-slide(body) = page(
  paper: "presentation-16-9", margin: 1.8cm, header: none, footer: none, fill: utad-navy,
  align(center + horizon,
    text(font: headingfont, size: 32pt, weight: 700, fill: white)[#body]),
)

// ---------- Agenda / contents slide ----------
// A numbered section list with the CURRENT section highlighted. Call it once
// at the start and again before each section, passing the 1-based index of
// the section you're entering (the others dim to grey):
//   #let sections = ("Problem & approach", "Results", "Conclusions")
//   #agenda-slide(sections, current: 1)   // ... then current: 2, current: 3
#let agenda-slide(items, current: none, title: [Contents]) = page(
  paper: "presentation-16-9", margin: (x: 2.2cm, top: 1.6cm, bottom: 1.4cm),
  header: none, footer: none, fill: white,
  {
    text(font: headingfont, size: 22pt, weight: 700, fill: utad-navy)[#title]
    line(length: 100%, stroke: 1pt + utad-navy)
    v(1fr)
    for (i, it) in items.enumerate() {
      let active = current == i + 1              // the section we're entering
      let dimmed = current != none and not active  // others, when a current is set
      block(above: 0.34cm, below: 0.34cm,
        grid(columns: (0.45cm, 1.15cm, 1fr), column-gutter: 0pt,
          align: (left + horizon, left + horizon, left + horizon),
          // blue tick marks the current item
          if active { rect(width: 5pt, height: 0.9cm, fill: utad-blue, radius: 0pt) } else { [] },
          text(font: headingfont, size: 27pt, weight: 700,
            fill: if active { utad-blue } else if dimmed { rgb("#c3ccd9") } else { utad-navy })[#(i + 1)],
          text(font: headingfont, size: 27pt, weight: if active { 700 } else { 400 },
            fill: if dimmed { muted } else { utad-navy })[#it],
        ))
    }
    v(1.1fr)
  },
)

// ---------- Two-column helper ----------
// Convenience for a left/right split inside a content slide. The columns are
// vertically centred relative to each other by default (so a short column and
// a tall one look balanced rather than clinging to a shared top edge); pass
// `valign: top` if you'd rather they share the top edge.
// Columns are LEFT-aligned horizontally (so a bullet list reads left even on a
// centre-aligned slide) and centred vertically relative to each other.
#let slide-columns(left, right, ratio: (1fr, 1fr), gutter: 1cm, valign: horizon) = grid(
  columns: ratio, column-gutter: gutter, align: start + valign,
  left, right,
)
