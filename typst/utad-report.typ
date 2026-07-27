// ============================================================
//  utad-report.typ — report-specific extensions on top of utad.typ
//
//  Import both together:
//    #import "utad.typ": *
//    #import "utad-report.typ": *
//
//  This module adds the pieces a multi-chapter internship/placement
//  report needs that a problem-set template doesn't: appendices with
//  lettered numbering, a repeatable weekly-log block, a hanging-indent
//  reference list, and a small set of self-contained (no external
//  package) diagram helpers: a linear evolution-chain diagram and a
//  simple proportional timeline/Gantt-style bar chart.
//
//  Deliberately built with Typst core primitives only (rect, place,
//  grid, line) rather than a package like cetz, so it has no external
//  dependency and compiles anywhere Typst itself runs.
// ============================================================

#import "utad.typ": utad-navy, utad-blue, muted, hairline, callbg, headingfont, sansfont
// evolution-chain moved to the base module (utad.typ) so the compact
// assignment format can use it without pulling in the report extras. Re-
// exported here so existing `#import "utad-report.typ": evolution-chain`
// (and `: *`) keeps working.
#import "utad.typ": evolution-chain

// ============================================================
//  Appendices
// ============================================================
// IMPORTANT: Typst deliberately does not let `set`/`show` rules leak
// out of a function call — this is by design, not a limitation of this
// module. That means "start-appendix" can't be a callable function;
// switching to lettered numbering has to be two bare statements
// written directly in your document at the point appendices begin:
//
//   #counter(heading).update(0)
//   #set heading(numbering: "A.1")
//
// Level-1 headings after that point number as A, B, C, ...; sub-levels
// continue as A.1, A.2, B.1, etc. See report.typ for a working example.

// ============================================================
//  Weekly log block
// ============================================================
// One repeatable block per week: a thin rule, then a bold blue "Week N"
// label, then labelled Tasks / Tools used / Outcome lines.
// Mirrors the LaTeX report's \utadweeklog macro.
//
// The rule opens the block rather than closing it: drawn after, the first
// entry in a run had no rule above it while every later one did, and the
// last entry left a rule dangling below -- uneven. Opening with it gives
// every entry (the first included) a rule above and leaves none trailing.
#let weeklog(week, tasks, tools, outcome) = block(
  width: 100%, above: 1em, below: 0.4em, breakable: true,
)[
  #line(length: 100%, stroke: 0.5pt + rgb("#c9d3e2"))
  #v(7pt)
  #text(fill: utad-blue, weight: 500, size: 12.5pt)[Week #week]
  #v(5pt)
  #text(weight: 700, fill: muted)[Tasks: ] #tasks

  #text(weight: 700, fill: muted)[Tools used: ] #tools

  #text(weight: 700, fill: muted)[Outcome: ] #outcome
]

// ============================================================
//  Reference list
// ============================================================
// Numbered, hanging-indent-style list. Pass an array of content items;
// they're numbered [1], [2], ... automatically.
#let reference-list(items) = table(
  columns: (1.6em, 1fr),
  stroke: none,
  inset: (x: 0pt, y: 5pt),
  ..items.enumerate().map(((i, item)) => (
    text(weight: 700)[[#(i + 1)]], item,
  )).flatten()
)

// ============================================================
//  Simple proportional timeline / Gantt-style bar chart
// ============================================================
// total-days: the width of the whole chart, in day-units (e.g. 31 for
// a month). rows: array of (label, start-day, end-day, style), where
// style is "done" (solid navy), "planned" (light grey, dashed-look via
// lighter fill), or "milestone" (a single-day diamond marker in blue).
// chart-width: physical width of the chart on the page.
//
// links: optional finish-to-start dependency arrows, an array of (from, to)
// 0-based ROW-INDEX pairs -- e.g. links: ((0, 5), (5, 6)) draws an arrow
// from the end of row 0 to the start of row 5, and from row 5 to row 6.
// The arrows are drawn in the accent blue (a distinct "dependency" layer
// that reads against the navy bars) with a thin white casing so they stay
// legible where they must cross a bar, routed as right-angle elbows through
// the inter-row whitespace. Omit `links` for a plain timeline.
// row-height / label-width / label-size / day-label-size let you scale the
// chart up for a slide or poster (the document defaults suit a report page).
#let timeline(
  total-days: 31,
  chart-width: 100%,
  rows: (),
  links: (),
  row-height: 0.42cm,
  label-width: 4.4cm,
  label-size: 8pt,
  day-label-size: 5pt,
) = {
  let row-h = row-height
  let bar-frac = 0.62          // bar height as a fraction of the row band
  let label-col = label-width
  let day-w = 1.0 / total-days
  let grid-stroke = 0.4pt + rgb("#d7dce4")  // subtle day gridlines (~LaTeX vgrid)
  let n = rows.len()
  let chart-h = row-h * n

  // geometry of a row's bar, in the chart's coordinate space (x as a % of
  // the chart width, y in absolute length)
  let geo(j) = {
    let (label, start, end, style) = rows.at(j)
    (
      x0: (start - 1) * day-w * 100%,
      w: calc.max(end - start + 1, 1) * day-w * 100%,
      yc: row-h * j + row-h / 2,
      style: style,
    )
  }

  // ---- dependency-arrow geometry ----
  let link-color = utad-blue
  let stub = 0.55 * day-w * 100%   // horizontal lead-out / lead-in
  // arrowhead + line thickness scale with the row height, so links stay
  // legible when the chart is enlarged for a slide (tiny on a report page,
  // chunky on a deck).
  let ah = calc.max(0.11cm, row-h * 0.17)
  let line-w = calc.max(0.8pt, row-h / 1cm * 0.9pt)
  let case-w = line-w + 1.1pt
  // right-angle elbow points from predecessor end -> successor start
  let route(a, b) = {
    let sx = if a.style == "milestone" { a.x0 } else { a.x0 + a.w }
    let sy = a.yc
    let tx = b.x0
    let ty = b.yc
    if tx >= sx + stub {
      ((sx, sy), (sx + stub, sy), (sx + stub, ty), (tx, ty))
    } else {
      // successor starts at/left of predecessor end: route around
      let my = (sy + ty) / 2
      ((sx, sy), (sx + stub, sy), (sx + stub, my),
       (tx - stub, my), (tx - stub, ty), (tx, ty))
    }
  }
  let draw-poly(pts, stroke) = {
    for k in range(pts.len() - 1) {
      place(line(start: pts.at(k), end: pts.at(k + 1), stroke: stroke))
    }
  }

  // breakable: false -- otherwise the day-number header row and the bar
  // rows below it can land on different pages if the chart falls near a
  // page boundary. Forcing the whole chart to move to the next page as one
  // unit is the correct trade-off -- it's a single diagram, not a table.
  block(width: chart-width, breakable: false, {
    // ---- Day-number header row (sits just above the bars) ----
    grid(
      columns: (label-col, 1fr),
      column-gutter: 6pt,
      [],
      box(width: 100%, height: day-label-size * 1.35, {
        // each number CENTERED over its day slot [(d-1), d], so it sits
        // midway between the two boundary gridlines -- matching the LaTeX
        // gantt's `\gantttitlelist` (numbers centred in the slot, grid at
        // the boundaries), rather than left-aligned on the boundary.
        for d in range(1, total-days + 1) {
          place(dx: (d - 1) * day-w * 100%, bottom,
            box(width: day-w * 100%,
              align(center, text(size: day-label-size, fill: muted)[#d])))
        }
      }),
    )
    v(1pt)
    // ---- Labels column + one chart box (single coordinate space) ----
    grid(
      columns: (label-col, 1fr),
      column-gutter: 6pt,
      // labels, each in a fixed row-h box so they line up with the bands
      stack(spacing: 0pt, ..rows.map(r => box(width: 100%, height: row-h,
        align(right + horizon, text(size: label-size, fill: muted)[#r.at(0)])))),
      // chart: gridlines, then bars, then dependency arrows on top
      box(width: 100%, height: chart-h, {
        for d in range(1, total-days + 1) {
          place(line(start: ((d - 1) * day-w * 100%, 0cm),
                     end: ((d - 1) * day-w * 100%, chart-h), stroke: grid-stroke))
        }
        place(line(start: (100%, 0cm), end: (100%, chart-h), stroke: grid-stroke))
        for (i, r) in rows.enumerate() {
          let g = geo(i)
          let y = row-h * i
          if g.style == "milestone" {
            place(dx: g.x0 - 0.11cm, dy: y + row-h / 2 - 0.11cm,
              rotate(45deg, rect(width: 0.22cm, height: 0.22cm, fill: utad-blue)))
          } else {
            let fill-color = if g.style == "done" { utad-navy } else { rgb("#c7cedb") }
            place(dx: g.x0, dy: y + row-h * (1 - bar-frac) / 2,
              rect(width: g.w, height: row-h * bar-frac, fill: fill-color, radius: 0pt))
          }
        }
        // dependency arrows: white casing first (legible over bars), then
        // the blue line and a right-pointing arrowhead at the successor start
        for (fi, ti) in links {
          let a = geo(fi)
          let b = geo(ti)
          let pts = route(a, b)
          draw-poly(pts, case-w + white)
          draw-poly(pts, line-w + link-color)
          let last = pts.at(pts.len() - 1)
          // stop the line a hair short so the solid arrowhead sits on the edge
          place(dx: last.at(0) - ah, dy: last.at(1) - ah * 0.62,
            polygon(fill: link-color, (0cm, 0cm), (ah, ah * 0.62), (0cm, ah * 1.24)))
        }
      }),
    )
  })
}

// ============================================================
//  Organigram / org-chart tree
// ============================================================
// A hierarchical tree (organisation chart, placement chart, taxonomy).
// Build the tree with `org-node(body, ..children, style:)`, then hand the
// root to `orgchart(...)`. Styles: "root" (navy fill, white text -- the top
// box), "node" (light navy-tint fill, navy text -- the default), and
// "highlight" (accent-blue fill, white text -- e.g. the box you sat in).
//
//   #orgchart(
//     org-node("Acme Group", style: "root",
//       org-node("Acme Software — B2B",
//         org-node("Commercial",
//           org-node("Internship Placement", style: "highlight")),
//         org-node("R&D"),
//         org-node("Engineering")),
//       org-node("Acme Retail — B2C")),
//   )
//
// Layout is computed with core primitives only (a small tidy-tree pass:
// leaves take successive slots, each parent is centred over its children),
// so there's no external package dependency. If the tree is wider than the
// text block, lower `node-width`/`sib-gap`. Connectors are drawn as the
// standard square "fork-down" org-chart elbows.
#let org-node(body, ..children, style: "node") = (
  body: body, style: style, children: children.pos(),
)

#let orgchart(
  root,
  node-width: 3cm,
  node-height: 0.95cm,
  level-gap: 0.72cm,
  sib-gap: 0.4cm,
  label-size: 8.5pt,
) = {
  // ---- layout: returns (flat, edges, center, nleaves) in leaf-unit x ----
  let layout(nd, depth, x0) = {
    let ch = nd.children
    if ch.len() == 0 {
      let c = x0 + 0.5
      (((x: c, depth: depth, node: nd),), (), c, 1)
    } else {
      let flat = ()
      let edges = ()
      let cx = x0
      let centers = ()
      for c in ch {
        let (cf, ce, cc, cl) = layout(c, depth + 1, cx)
        flat += cf
        edges += ce
        centers.push(cc)
        cx += cl
      }
      let center = (centers.first() + centers.last()) / 2
      flat = ((x: center, depth: depth, node: nd),) + flat
      for cc in centers { edges.push((fx: center, fdepth: depth, tx: cc)) }
      (flat, edges, center, cx - x0)
    }
  }
  let (flat, edges, _, nleaves) = layout(root, 0, 0)
  let maxd = calc.max(..flat.map(f => f.depth))
  let unit-x = node-width + sib-gap
  let unit-y = node-height + level-gap
  let total-w = nleaves * unit-x
  let total-h = (maxd + 1) * unit-y - level-gap

  let render-node(nd) = {
    let (bg, fg, bd) = if nd.style == "root" {
      (utad-navy, white, utad-navy)
    } else if nd.style == "highlight" {
      (utad-blue, white, utad-blue)
    } else {
      (rgb("#eef2f8"), utad-navy, utad-navy)
    }
    box(width: node-width, height: node-height, fill: bg, stroke: 1pt + bd,
      inset: 5pt, radius: 0pt,
      align(center + horizon,
        text(fill: fg, size: label-size, weight: 600, font: sansfont)[#nd.body]))
  }

  align(center, block(width: total-w, height: total-h, breakable: false, {
    // connectors behind the boxes
    let cstroke = 0.7pt + rgb("#aeb8c8")
    for e in edges {
      let fx = e.fx * unit-x
      let tx = e.tx * unit-x
      let pby = e.fdepth * unit-y + node-height
      let cty = (e.fdepth + 1) * unit-y
      let midy = pby + level-gap / 2
      place(line(start: (fx, pby), end: (fx, midy), stroke: cstroke))
      place(line(start: (fx, midy), end: (tx, midy), stroke: cstroke))
      place(line(start: (tx, midy), end: (tx, cty), stroke: cstroke))
    }
    // node boxes
    for f in flat {
      place(dx: f.x * unit-x - node-width / 2, dy: f.depth * unit-y,
        render-node(f.node))
    }
  }))
}
