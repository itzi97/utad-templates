// ============================================================
//  U-tad slides — STARTER template (Typst, 16:9 presentation)
//
//  Copy this whole `typst/` folder (you need utad.typ, utad-slides.typ and
//  the logo-*.svg files alongside this file), rename it, and fill it in.
//
//  Compile:  typst compile starter-slides.typ
//  Live preview while editing:  typst watch starter-slides.typ
//
//  See slides.typ / slides.pdf for a worked deck. The slide helpers
//  (title-slide, section-slide, slide, focus-slide, slide-columns,
//  agenda-slide, stat) are documented in ../docs/GUIDE.md
//  ("Component reference" -> Slides).
// ============================================================

#import "utad-slides.typ": *
// Optional — diagrams on slides (Gantt, org-chart, evolution chain):
// #import "utad-report.typ": timeline, orgchart, org-node, evolution-chain

#let sections = ("First section", "Second section")

#title-slide(
  title: [Presentation Title],
  subtitle: [Optional subtitle],       // omit for none
  author: "Your Name",
  date: "Month YYYY",
  event: [Course · U-tad],
)

// Contents slide that highlights the current section (1-based `current`);
// repeat before each section with current: 2, current: 3, …
#agenda-slide(sections, current: 1)

#section-slide[1 · First section]

#slide(title: [A content slide])[
  - first point
  - second point
]

#slide(title: [Two columns])[
  #slide-columns(
    [
      Left column — text, bullets, math $E = m c^2$.
    ],
    note(title: [Callout])[
      All utad.typ boxes work on slides: note, important, exercise, …
    ],
  )
]

#focus-slide[One big takeaway.]

// For a slide that is ONE big diagram, image, or chart, use `fit: true` to
// scale it to fill the slide (best for absolute-sized content like an
// org-chart or an image):
//   #slide(title: [Architecture], fit: true)[ #orgchart(org-node(...)) ]
// The Gantt `timeline()` uses %-based widths — size it with `row-height`
// (and label-size / day-label-size) instead of `fit`, and the slide will
// centre it. Use `align-center: true` to horizontally centre a table/image.
//
// Helpers available: title-slide, agenda-slide(items, current:),
// section-slide, slide(title:, fit:, align-center:), focus-slide,
// slide-columns(left, right). Every utad.typ component
// (note/important/exercise/callout, utad-table, math, code) works on slides.
