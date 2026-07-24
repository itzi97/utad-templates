// ============================================================
//  Worked example — U-tad slide theme (utad-slides.typ)
//  A short defense deck. Compile: typst compile slides.typ slides.pdf
// ============================================================

#import "utad-slides.typ": *
#import "utad-report.typ": timeline, orgchart, org-node   // diagrams on slides

#let sections = ("Problem & approach", "Results")

#title-slide(
  title: [SparkSQL 2 — Project Defense],
  subtitle: [Outlier detection & categorical encoding],
  author: "Your Name",
  date: "June 2026",
  event: [Big Data · U-tad],
)

#agenda-slide(sections, current: 1)

#section-slide[1 · Problem & approach]

#slide(title: [The task])[
  #slide-columns(
    [
      Flag anomalous rows in the wine-quality dataset:
      - per-variable outliers via the *IQR rule*
      - keep rows anomalous in $>= 3$ dimensions
    ],
    note(title: [IQR rule])[
      A value is an outlier if it falls below
      $Q_1 - 1.5 dot "IQR"$ or above $Q_3 + 1.5 dot "IQR"$,
      with $"IQR" = Q_3 - Q_1$.
    ],
  )
]

#slide(title: [Pipeline at a glance], fit: true)[
  #orgchart(
    org-node("winesdf", style: "root",
      org-node("outlier flags",
        org-node("num_outliers", style: "highlight")),
      org-node("idx_style"),
      org-node("enc_style")),
  )
]

#agenda-slide(sections, current: 2)

#section-slide[2 · Results]

#slide(title: [Outcome], align-center: true)[
  // lead with the headline number, table as supporting detail
  #text(size: 62pt, weight: 700, fill: utad-blue, font: headingfont)[≈ 5%]
  #v(0.1cm)
  #text(size: 19pt, fill: muted)[of rows dropped as multi-dimensional outliers]
  #v(0.95cm)
  #text(size: 22pt)[#utad-table(
    columns: 3,
    inset: (x: 14pt, y: 13pt),
    header: ([Stage], [Rows kept], [Note]),
    [Raw], [6 497], [full dataset],
    [After IQR filter], [6 180], [num_outliers < 3],
    [Encoded], [6 180], [one-hot style],
  )]
]

#focus-slide[Enforced at the pipeline, not patched afterwards.]

// The Gantt uses %-based widths internally, so size it with `row-height`
// (not `fit`); `align-center` + a chart-width < 100% centres the whole chart
// (label gutter + bars) instead of stretching it edge-to-edge.
#slide(title: [Timeline], align-center: true)[
  #timeline(total-days: 14, chart-width: 96%, rows: (
    ("Data profiling", 1, 3, "done"),
    ("IQR outliers", 3, 7, "done"),
    ("Encoding", 7, 10, "done"),
    ("Write-up", 10, 14, "planned"),
  ), links: ((1, 2),),
    row-height: 1.65cm, label-width: 3.3cm, label-size: 16pt, day-label-size: 12pt)
]
