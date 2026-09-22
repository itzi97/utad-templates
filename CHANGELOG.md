# Changelog

All notable changes to these templates are documented here. The format is
based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the
project aims to follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- **TFG class** (`latex-tfg/utad-tfg.cls`, v0.3.2): a LaTeX port of the
  official End-of-Degree Project Word template (`Template - inso.docx`,
  2609_INSG4_TFGR_A). Separate from `utad.sty` on purpose — the TFG is
  marked against the template, so this is Times 12 pt, black, the two
  cover logos and nothing else. Every value was read out of the .docx XML
  and the output diffed line by line against a render of the Word file:
  mean 1.4 pt over the eight identical-content pages (1.0 pt with the real
  Times New Roman via `[tnr]`), 14 pages for 14. `main.tex` is the
  template page for page; `[spanish]` switches every generated name.
  Comes with the measuring tools (`tools/`), a 67-page filler stress test
  (`test-thesis/`, both languages, 0 overfull boxes), a `make tfg` target,
  an `install.sh tfg` / `install.ps1 tfg` target and a CI job. Checked
  against a PDF exported by Word for the web as well: 1.5 pt mean, and
  Word's render agrees with LibreOffice's to 0.4 pt.

- **ER-diagram fragment** (LaTeX): `utaderd` environment with `\utadentity`
  (title-bar entity box with a padded, monospaced attribute block) and
  `\utadrelone` / `\utadrelmany` relationship macros drawing discreet
  crow's-foot cardinality glyphs. Entities anchor by their top edge so
  uneven attribute counts don't stagger the row. Extracted from the
  internship report's billing-chain figure.
- **Custom timeline column labels** (LaTeX): `utadtimeline` gained an
  optional first argument for cosmetic column labels, e.g.
  `\begin{utadtimeline}[1,2,3,6,7,8]{6}` to show only working days with
  weekends skipped. Default behaviour (1..N) unchanged.

- **PDF metadata** (both): documents now carry a real title/author. LaTeX
  wires `\utadTitle` / `\utadAuthorName` / `\utadSubject` into `pdftitle` /
  `pdfauthor` / `pdfsubject` (deferred to `\AtBeginDocument` so it reads the
  author's values) and sets `bookmarksnumbered` so the PDF sidebar matches
  the numbered contents; Typst `set document(title: …)` now receives the real
  title instead of a generic "U-tad document" fallback.
- **Fourth heading level** (both): `\subsubsection` (LaTeX) and level-4
  headings (`====`, Typst) are styled to continue the family — navy Poppins
  bold, one step down, led by a small blue square instead of a number.
  Unnumbered and out of the contents by default, so they double as a
  lightweight "named phase" for breaking up a long run.
- **LaTeX `\utadmasthead`** — a compact header for short deliverables (no
  cover page, no separate contents page): logo, title, optional subtitle,
  navy rule, and the shared info box, flowing inline at the top of page 1.
  The parity match to the Typst `assignment` template; use `\section` as the
  top level. Not a separate document class — it reuses the whole package.
- **`make check`** — a build sanity pass for both languages reporting page
  count per PDF, undefined `\ref`/`\cite` warnings, and Overfull `\hbox`
  warnings above a tunable threshold (`make check OVERFULL=5.0`).
- **Typst: build without the logo assets** via `variant: "none"` / `"text"`
  (report and assignment) or `no-logo-slides()` (a deck) — a single switch
  that avoids every logo image, cover/masthead and page-footer mark alike, so
  a fresh clone or a fork that stripped the (non-MIT) U-tad marks still
  builds. Typst has no file-existence check, so this cannot be automatic the
  way the LaTeX `\IfFileExists` guards are.
- LaTeX `\utadmetarow{Label}{Value}` — a body metadata line styled to match
  the cover's spec-sheet info box (right-aligned bold grey label, navy value,
  aligned on a fixed `\utadmetalabelwidth` label column). For document
  metadata beyond the five fixed cover fields (Company, Period, Supervisor,
  …), which belong in the body rather than on the cover.
- `Makefile` to rebuild the worked examples locally (`make`, `make typst`,
  `make latex`, `make fonts`, `make clean`).
- Logo & trademark notice: the U-tad marks are the university's property and
  are not covered by the MIT license.
- Slide theme: `agenda-slide(items, current:)` — a contents slide that
  highlights the current section — and `slide(fit: true)` to scale a diagram
  to fill the slide.
- `timeline()` gained `row-height` / `label-width` / `label-size` /
  `day-label-size`, and its dependency arrows now scale with the row height
  (so links stay legible when the chart is enlarged for a slide);
  `orgchart()` gained `label-size`.

- Slide theme: `stat(number, caption)` headline-number helper, and automatic
  section tracking — `section-slide` records the section so every content
  slide shows a subtle tag by its title.
- A second worked slide deck, `business-plan.typ`, as a full real-world
  example (Business Plan pitch).

### Changed

- **`utadtimeline` reads denser** (LaTeX): rows tightened (0.55cm →
  0.36cm), bar labels one size down (`\tiny`), and dependency-arrow elbows
  calmed (`link bulge` 2 → 0.6, `link tolerance` 4 → 1 — the old values
  made every arrow lunge far right and double back). Tuned on the
  internship report's 10-row timeline.
- **`utadorgchart` clears its fork bars** (LaTeX): default `level distance`
  raised 1.45cm → 1.8cm and level-2 sibling distance 3.3cm → 3.9cm, so
  two-line boxes no longer collide with the connector elbows; comments now
  explain the equal-height-siblings rule and the per-node
  `text width` fix for long labels.

- **List markers** (both): the second-level itemize marker (LaTeX) and the
  deeper-level list markers (Typst) were the default en dash; they are now
  small filled squares — navy at level 1, the blue accent at level 2, grey at
  level 3 — matching the template's squared-corner identity and no longer
  slipping a stray dash into a dash-free document.
- **Typst `evolution-chain` moved to the base module** (`utad.typ`) from
  `utad-report.typ`, so the compact `assignment` format can use the step
  chain without importing the report extras (weekly log, Gantt). Still
  re-exported from `utad-report.typ`, so existing imports keep working.
- LaTeX `utadchain` now lays itself out automatically: `\begin{utadchain}`
  (no argument) picks a balanced number of boxes per row that keeps each box
  above a minimum width for the current `\textwidth` (8 items → 4+4, 6 → 3+3,
  5 → 3+2), instead of requiring a hand-tuned per-row count. `\begin{utadchain}[n]`
  still forces `n`.
- Pinned the CI Typst version to 0.15.1 for reproducible builds.
- Slide section dividers now underline the title (blue rule under the text)
  instead of a floating rule above it.
- `utad-table` takes a `cell-align` argument and callouts/columns force their
  own alignment, so tables, boxes, and bullet lists stay left-aligned on a
  centre-aligned slide.
- `slide(fit: true)` centring fixed for wide-and-short diagrams; the agenda
  renders a plain overview when no `current` section is given.
- Trimmed the Typst font stacks to `Poppins` / `Carlito` (+ the built-in
  `DejaVu Sans Mono`), so a compile with the fonts installed no longer prints
  "unknown font family" warnings for absent cross-platform fallbacks.

### Fixed

- **LaTeX table-of-contents entries are now clickable links.** The package
  set `linktoc=none` to protect the tocloft palette; it now uses
  `linktoc=all` and scopes `linkcolor=.` to `\utadcontents`, so the contents
  become real links while keeping the blue-number / navy-chapter / grey-
  section colouring (and body cross-references keep the blue link accent).
- **Weekly-log divider** (both) is drawn before each block instead of after,
  so the first entry in a run has a rule above it and none dangles below the
  last — an even rhythm.
- **LaTeX evolution chain** now declares the TikZ `calc` library explicitly.
  It was relying on a transitive load (via `pgfgantt`), so the chain would
  break if that package were reordered or removed.
- Running header (both templates) showed the **author's name** repeated on
  every page instead of the current section. The right-hand running head now
  tracks the current section: LaTeX uses `\nouppercase{\rightmark}` (the
  `\nouppercase` undoes the `report` class's inherited all-caps `\sectionmark`,
  so headers read in title case, e.g. `4.1. Commercial Data Schema Design`,
  and are empty on a chapter-opening page); Typst queries the current level-2
  heading and prints `4.1. Section title` to match. The author's name is
  still used on the cover.
- `utad-table` now accepts an `inset` argument (it was previously ignored),
  and the default cell padding is roomier.

## [0.1.0] — 2026-07-21

First public release. Two typesetting systems, one visual identity.

### Added

- **LaTeX report package** (`utad.sty`) — `\usepackage{utad}`, fields set with
  `\renewcommand`, `\utadtitlepage` + `\utadcontents`. XeLaTeX/LuaLaTeX.
- **Typst report template** (`utad.typ` + `utad-report.typ`) — `#show:
  utad-doc.with(...)`, cover + clean front-matter contents page.
- **Typst compact assignment template** (`utad-assignment.typ`) — `#show:
  assignment.with(...)` for short deliverables: masthead, no cover/contents
  page, optional inline contents, and a two-column info box.
- **Typst slide theme** (`utad-slides.typ`) — a self-contained 16:9
  presentation deck matching the report identity: `title-slide`,
  `section-slide`, `slide`, `focus-slide`, and `slide-columns`. Callout boxes
  and the report diagrams (timeline, org-chart, evolution chain) work on
  slides. No external package (no Touying/Polylux).
- **Shared identity**: full-logo cover lockup, navy-dominant palette with a
  single blue accent, squared corners, unified metadata info box.
- **Callout boxes** in both systems: note, callout, important, exercise,
  question / solution, prompt / response.
- **Solution-set convention**: box the given problem in `question`, open the
  worked answer with `solution` — worked `spark-solution` example.
- **Diagrams**: evolution / step chains, a proportional Gantt timeline (subtle
  day gridlines, day numbers centred over each slot) with finish-to-start
  **dependency arrows** (accent-blue, white-cased so they stay legible over
  bars), and **organigrams** (`orgchart` / `utadorgchart`).
- **Other components**: code blocks with line numbers + syntax highlighting,
  striped tables, a weekly-log block, and a hanging-indent reference list.
- **Packaging**: `install.sh` / `install.ps1` (Typst `@local/utad` package +
  LaTeX home-`texmf` install), `typst.toml` + `lib.typ` package manifest,
  copy-to-start starter files, and font-install scripts for Poppins + Carlito.
- **CI**: GitHub Actions workflow that installs fonts and compiles every
  worked example on push.

[Unreleased]: https://github.com/itzi97/utad-templates/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/itzi97/utad-templates/releases/tag/v0.1.0
