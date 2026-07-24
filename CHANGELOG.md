# Changelog

All notable changes to these templates are documented here. The format is
based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the
project aims to follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

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
