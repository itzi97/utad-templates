// ============================================================
//  Worked example — Business Plan pitch deck (utad-slides.typ)
//  Subject: Business Creation & Management (requires an oral defense).
//  A fictional company, "PlaySignal", with illustrative figures.
//  Compile: typst compile business-plan.typ business-plan.pdf
// ============================================================

#import "utad-slides.typ": *
#import "utad-report.typ": timeline, orgchart, org-node

#let sections = (
  "The opportunity", "Our solution", "Market & model",
  "Financials", "Roadmap & team",
)

// ---------------------------------------------------------------
#title-slide(
  title: [PlaySignal],
  subtitle: [Player-retention analytics for indie game studios],
  author: "Your Name",
  date: "May 2026",
  event: [Business Creation & Management · Business Plan · U-tad],
)

// One agenda up front as the roadmap; from here, the section dividers mark
// transitions and every content slide shows its section tag by the title.
#agenda-slide(sections)

#section-slide[1 · The opportunity]

#slide(title: [Players leave, and studios don't know why], align-center: true)[
  #stat([≈ 25%], [median day-1 retention — 3 of every 4 new players never return])
  #v(0.95cm)
  #text(size: 20pt)[Every lost player is wasted acquisition spend — and rising.]
]

#slide(title: [The gap])[
  #slide-columns(
    [
      Retention is now the difference between a studio surviving or not:
      - user-acquisition costs keep climbing
      - a small lift in retention compounds across the whole funnel
      - but *understanding* churn needs data science
    ],
    important(title: [Who's left out])[
      Large publishers have in-house data teams. The *90%+ of studios that
      are small or indie* can't afford one — so they fly blind.
    ],
  )
]

#section-slide[2 · Our solution]

#slide(title: [What PlaySignal does])[
  #slide-columns(
    [
      A plug-and-play retention layer for your game:
      - connect in an afternoon (lightweight event SDK)
      - predict which players are about to churn — *before* they do
      - trigger the right retention action (offer, nudge, reward)
      - dashboard the whole funnel — no data scientist required
    ],
    note(title: [In one line])[
      Enterprise-grade player-retention analytics, priced for indies.
    ],
  )
]

#slide(title: [How it works], fit: true)[
  #orgchart(
    org-node("In-game events", style: "root",
      org-node("Churn prediction", style: "highlight"),
      org-node("Player segments"),
      org-node("Retention actions"),
      org-node("Studio dashboard")),
    node-height: 1.9cm,
  )
]

#section-slide[3 · Market & model]

#slide(title: [A large, growing market], align-center: true)[
  #stat([€90 B], [global mobile-games market — retention tooling grows with it])
  #v(0.85cm)
  #text(size: 22pt)[#utad-table(
    columns: (auto, auto, auto),
    cell-align: (col, row) => if col == 0 { left } else { center },
    inset: (x: 14pt, y: 13pt),
    header: ([Segment], [Size], [Note]),
    [TAM — global mobile games], [€90 B], [total market],
    [SAM — indie & mid-size studios], [€1.2 B], [analytics spend],
    [SOM — 3-year target], [€18 M], [≈ 1.5% of SAM],
  )]
]

#slide(title: [Why studios pick us], align-center: true)[
  #text(size: 24pt)[#utad-table(
    columns: (auto, auto, auto, auto),
    cell-align: (col, row) => if col == 0 { left } else { center },
    inset: (x: 16pt, y: 14pt),
    header: ([], [PlaySignal], [Big suites], [In-house]),
    [Setup time], [hours], [weeks], [months],
    [Needs a data scientist], [No], [Sometimes], [Yes],
    [Churn prediction built-in], [Yes], [Add-on], [Build it],
    [Price for indies], [€149/mo], [€1 k+/mo], [dev time],
  )]
]

#slide(title: [Simple, tiered pricing], align-center: true)[
  #stat([€149/mo], [to start — free to try, scales with the studio])
  #v(0.85cm)
  #text(size: 22pt)[#utad-table(
    columns: (auto, auto, auto),
    cell-align: (col, row) => if col == 1 { center } else { left },
    inset: (x: 14pt, y: 13pt),
    header: ([Plan], [Price], [For]),
    [Free], [€0], [< 5 k monthly players, 1 game],
    [Pro], [€149/mo], [growing studios],
    [Studio], [€499/mo], [multiple titles + automated actions],
  )]
]

#section-slide[4 · Financials]

#slide(title: [Three-year projection], align-center: true)[
  #text(size: 23pt)[#utad-table(
    columns: (auto, auto, auto, auto),
    cell-align: (col, row) => if col == 0 { left } else { center },
    inset: (x: 16pt, y: 14pt),
    header: ([], [Year 1], [Year 2], [Year 3]),
    [Paying studios], [40], [180], [500],
    [Revenue], [€120 k], [€560 k], [€1.6 M],
    [Costs], [€260 k], [€520 k], [€1.1 M],
    [Net result], [−€140 k], [+€40 k], [+€500 k],
  )]
  #v(0.7cm)
  #important(title: [Break-even])[
    Reached in *month 20*, at ~120 paying studios — before the Studio tier
    and automated actions ramp.
  ]
]

#slide(title: [The ask], align-center: true)[
  #stat([€300 k], [seed round — 18 months of runway to launch and reach break-even])
  #v(0.9cm)
  #slide-columns(
    [
      *Use of funds*
      - 55% engineering & the ML model
      - 30% growth and studio onboarding
      - 15% operations & runway
    ],
    note(title: [Milestone])[
      Funds take us from MVP to a paying base past break-even, de-risking a
      Series-A conversation.
    ],
  )
]

#section-slide[5 · Roadmap & team]

#slide(title: [Roadmap — first 12 months])[
  #timeline(total-days: 12, chart-width: 96%, rows: (
    ("MVP & pilot studio", 1, 4, "done"),
    ("Private beta", 4, 7, "done"),
    ("Public launch", 7, 9, "done"),
    ("Studio tier + actions", 9, 12, "planned"),
    ("Seed round", 3, 5, "milestone"),
  ), links: ((0, 1), (1, 2)),
    row-height: 1.7cm, label-width: 4.6cm, label-size: 16pt, day-label-size: 13pt)
]

#slide(title: [The team], fit: true)[
  #orgchart(
    org-node("Founding team", style: "root",
      org-node("Product & CEO"),
      org-node("Engineering / CTO"),
      org-node("Data & ML", style: "highlight"),
      org-node("Advisor — games industry")),
    node-height: 1.9cm,
  )
]

#focus-slide[Give every indie studio a data team.]
