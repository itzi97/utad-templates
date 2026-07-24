// ============================================================
//  U-tad compact assignment — STARTER template (Typst, short format)
//
//  For short deliverables (a handful of questions, ~2–5 pages): no cover
//  page and no separate contents page — a compact masthead, then content.
//
//  To start a new document: copy this whole `typst/` folder (you need
//  utad.typ, utad-assignment.typ and the logo-*.svg files alongside this
//  file), rename this file, fill in the fields, and write your content.
//
//  Compile:  typst compile starter-assignment.typ
//
//  See assignment.typ / assignment.pdf for a worked problem set, and
//  spark-solution.typ for the boxed question / solution style. Every
//  helper is documented in ../docs/GUIDE.md ("Component reference").
// ============================================================

#import "utad-assignment.typ": *

#show: assignment.with(
  title: [Assignment Title],
  subtitle: [Optional topic line],      // omit for none
  subject: [Subject],
  degree: [Software Engineering w/ AI & Data Science],
  year: [4],
  teacher: [Teacher Name],
  author: "Your Name",
  date: "Month YYYY",
  contents: true,                       // inline contents list under the header
)

= Question 1
Write your answer here.

= Question 2
Second question.

// ---- Solution-set style (restate the given problem, then answer) -----
//   = Exercise 1
//   #question[ Paste the given problem statement here. ]
//   #solution[] Then your worked answer — explanation, note boxes, code.
//
// Everything from utad.typ is available: note/callout/important/exercise,
// utad-table, math, code blocks with line numbers, etc.
