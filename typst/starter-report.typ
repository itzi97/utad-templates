// ============================================================
//  U-tad report — STARTER template (Typst, long format)
//
//  To start a new document: copy this whole `typst/` folder (you need
//  utad.typ, utad-report.typ and the logo-*.svg files alongside this
//  file), rename this file, fill in the fields, and write your content.
//
//  Compile:  typst compile starter-report.typ
//
//  See example.typ / example.pdf for every feature in use, and
//  ../docs/GUIDE.md ("Component reference") for every helper documented
//  with its Typst and LaTeX form side by side.
// ============================================================

#import "utad.typ": *
#import "utad-report.typ": *

#show: utad-doc.with(
  title: [Report Title],
  subtitle: [Academic Division],        // small eyebrow over the title
  degree: [Software Engineering w/ AI & Data Science],
  subject: [Subject],                   // appears in the cover info box
  year: [4],
  teacher: [Teacher Name],
  author: "Your Name",
  date: "Month YYYY",
  short-title: [Short Title],           // shown in the page header
  variant: "full",                      // logo: "full" | "wordmark" | "mark"
)

#utad-outline()                          // clean front-matter contents page

= First Chapter
== A section
Write your content here.

// ---- Available helpers (worked usage: example.typ; full reference with
//      Typst + LaTeX forms and examples: ../docs/GUIDE.md) -------------
//   note[...]  /  callout(..., title: ...)  /  important[...]
//   exercise([Title])[...]  /  prompt[...]  /  response[...]
//   utad-table(columns: 2, header: (...), ...rows)
//   evolution-chain(("v1","Label","start"), ...)
//   timeline(total-days: 31, rows: (...), links: ((0,1),))
//   orgchart(org-node("Top", org-node("Child", style: "highlight")))
//   weeklog(week, tasks, tools, outcome)   reference-list((...))
//   code blocks are ```lang fenced``` with automatic line numbers
//
// ---- Appendices: switch to lettered numbering (bare statements) ------
// #counter(heading).update(0)
// #set heading(numbering: "A.1")
// = Weekly Log Summary
