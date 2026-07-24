# Development log & design notes

This file collects the development history of the U-tad templates: the dated
design-audit and polish passes, the record of issues found and fixed (so they
aren't reintroduced), and the reasoning behind specific design decisions. It
is maintainer-facing — to *use* the templates, see [`GUIDE.md`](GUIDE.md) and
the repo `README.md`.

---

## Known issues already found and fixed — don't reintroduce these

From the original build:
- TeX macros cap at 9 positional arguments — the title page uses a
  set-variables-then-call pattern (`\renewcommand` + `\utadtitlepage`)
  instead of a giant argument list.
- A "planned" Gantt bar style must be written inline in `\ganttbar[...]`,
  not through a wrapper macro (pgfkeys parses it wrong once the style
  expression has been pre-expanded through a macro).
- Typst: `set`/`show` rules don't leak out of function calls — appendix
  numbering is two bare statements at the call site, not a callable
  function.
- Diagram boxes (evolution-chain, timeline bars) use flexible (`1fr`) grid
  columns / computed widths, never a fixed absolute width, or they
  overlap/overflow once there are more than ~4 items.

From this pass (all confirmed by actually compiling and visually checking
the output, not just reading the source):
- **LaTeX table header rows**: `\tblheadrow` only sets the row background
  (`\rowcolor`); the header text color/weight/font has to be applied per
  cell with `\tblhead{...}`, because each tabular cell is its own implicit
  group — a formatting command issued before the first `&` does not carry
  into later cells. Usage: `\tblheadrow \tblhead{Category} & \tblhead{Tools} \\`.
- **LaTeX chapter pages losing the branded header/footer**: `\chapter`
  silently uses the `plain` page style (a `report`-class default), which
  strips the running title, footer rule, and styled page number from the
  first page of every chapter. Fixed with
  `\assignpagestyle{\chapter}{fancy}` (from `titlesec`, already loaded).
- **LaTeX "Contents" title unstyled**: `\tableofcontents` sets its title via
  `\chapter*`, which never passes through `\titleformat{\chapter}` (that
  only hooks numbered chapters). Fixed with tocloft's `\cfttoctitlefont`.
- **LaTeX title-page metadata table misaligning silently**: if the value
  column is given a `>{\raggedright}` (or any `>{...}`) prefix on top of the
  label column's `>{\raggedleft}`, with `!{...}`/`@{...}` vrule material
  between them, then as soon as any one row's cell wraps to more than one
  line, every row after it shifts by one line — labels end up next to the
  wrong value, with no error or warning. Reproduced in an isolated minimal
  file, so it's an `array` package interaction, not a typo. Fix: leave the
  value column as plain `p{width}` (justified, not ragged-right), and don't
  add per-row spacing via `\\[dim]`, `\noalign{\vskip...}`, or
  `\arraystretch` in this specific table shape.
- **Typst missing/unused logo variants**: `utad-doc`'s `variant: "full"`
  pointed at a `logo-full-white.svg` that was never part of this asset set.
  `"wordmark"` (the mark + wordmark lockup) is now the default, and `"full"`
  is kept as an accepted alias for it rather than erroring on a missing
  file. A working `"text"` variant (plain white "U-tad" text) was also
  added — the `utad-wordmark` helper that was meant to back it was designed
  for a light background and unused.
- **Accent-blue drift between the two templates**: `utad.sty` used
  `#1B5FE0` (documented as sourced from the real site), `utad.typ` had
  independently drifted to `#1b7bec`. Synced to `#1B5FE0` in both.
- **Squared corners**: LaTeX already had none (TikZ rectangles are square by
  default). Typst had several `radius: 3pt/4pt/6pt/2pt` corners left over
  on callouts, the exercise box, code blocks, inline code, and the fallback
  wordmark badge — all set to `radius: 0pt` to match the "no rounded
  corners anywhere" rule end to end.
- **Cover redesigned to a left-aligned masthead**: the cover was originally
  centered top-to-bottom (a navy header band with a centered logo, centered
  title/subtitle, a centered metadata block). Rebuilt to match the
  originally-submitted report's cover instead: thin navy accent strips top
  and bottom, the logo standalone and left-aligned in the white body, an
  eyebrow line, a capitalized title, a blue degree line, and a left-aligned
  metadata block — one shared left margin end to end. Also fixed: the top
  accent strip had drifted to a bright `utadblue`/`utad-blue`, which read as
  a different palette from the rest of the navy-dominant identity and
  clashed against it; both strips are `utaddark`/`utad-navy` now, matching
  the actual logo ink, with blue kept for what it already was elsewhere —
  small accents only (the degree line, the rule above the metadata block).
- **LaTeX title-page metadata table baseline mismatch**: after re-aligning
  the metadata block left instead of centering it, the label column
  (`\footnotesize`) and value column (normal size) had visibly different
  baselines within the same row even though both paired correctly. Fixed by
  matching the label column to `\normalsize` with a `\strut`, and widening it
  slightly so "Company / Placement" doesn't wrap.
- **LaTeX timeline overflowing the page margin**: `utadtimeline`'s default
  `x unit=0.4cm` combined with a longer bar label (e.g. "Game Metadata Schema
  (v1--v5)") pushed the chart past the text width — confirmed by an overfull
  `\hbox` warning and a bar visibly running off the page edge, not just a
  benign warning. Reduced the default `x unit` to `0.3cm`, which keeps a
  31-day chart with realistic label lengths inside a standard `2.5cm`-margin
  page. Typst's `timeline()` doesn't have this failure mode — its `1fr` grid
  column for the chart shrinks to fit automatically regardless of label
  length — so no change was needed there.

## Latest pass — cross-template polish (fonts, TOC, headers, cover alignment)

This round of feedback was about making the two templates feel like the
*same* document again after the cover redesign, rather than two documents
that happen to share a palette — both example documents now also include a
worked math example (a short closed-form derivation with a universally
quantified check, in `4.1.4 Formal Consistency Model`), confirmed rendering
correctly in both (compiled with `amsmath`/`amssymb` on the LaTeX side,
Typst's native math mode on the other).

- **Fonts unified**: Typst's `sansfont`/new `headingfont` are now
  `Carlito`/`Poppins` — the same two families `utad.sty` already used via
  `fontspec` — applied to headings, the cover (subtitle/title/degree), and
  the TOC/outline entries. Previously Typst fell back to Helvetica
  Neue/Arial, so the two covers used visibly different typefaces for the
  same title; confirmed both fonts are actually installed and rendering (not
  silently falling back) by checking `fc-list` and inspecting the compiled
  PDF.
- **Cover metadata alignment reversed**: both covers' Subject/Year/
  Teacher/Author/Date (Typst) and Student/Company/Department/etc. (LaTeX)
  blocks now right-align the labels and left-align the values, so each pair
  reads as a tight label-value unit instead of two independently
  left-aligned columns that read like unrelated lists. On the LaTeX side
  this meant flipping the label column from `\raggedright` to
  `\raggedleft` — still only ONE `>{...}`-prefixed column, per the
  array-package bug noted above — and widening it slightly (4.2cm to
  5.3cm) so "Company / Placement" stops wrapping to two lines, which was
  otherwise throwing off the row's visual alignment against its value.
- **Typst outline restyled to match LaTeX's tocloft look**: chapter-level
  (`=`) entries are now bold navy `headingfont`, matching `\cftchapfont`;
  section/subsection entries are an unbolded muted grey, matching
  `\cftsecfont`/`\cftsubsecfont` (previously everything was navy, with no
  color distinction by level). Added weak vertical space before each
  top-level entry so the list has the same breathing room between chapters
  that the LaTeX contents page already had.
- **LaTeX running header/footer replaced to match Typst's**: previously a
  bold `utadblue` rule with the running title on the left and the *current
  section name* on the right, and a plain centered page number in the
  footer. Now: a thin light-grey hairline rule (matching Typst's exact hex,
  `#C9D3E2`/`#DFE5EE`) under a running-title-left / author-name-right
  header, and a second hairline above a small logo mark (left) + page
  number (right) footer — the same layout Typst already had. New macro:
  `\setutadauthor{...}` (parallel to the existing `\setutadrunningtitle`),
  set once before `\begin{document}`.
- **LaTeX chapter headings gained an underline**: Typst's level-1 heading
  (`=`, the same document level as `\chapter` here — both are used for
  Executive Summary/Introduction/etc.) has a thin navy rule underneath it;
  `\chapter` didn't. Added via `\titleformat{\chapter}`'s `[after]` argument
  — `\section`/`\subsection` (matching Typst's `==`/`===`, neither of which
  has a rule) were deliberately left alone, so the two templates stay
  matched heading-level-for-heading-level rather than both getting a rule
  everywhere.
- **Typst cover title pushed down to match LaTeX's position**: the vertical
  rhythm above the title (padding/gaps before the logo, and between
  logo/subtitle/title/degree) now mirrors LaTeX's `\utadtitlepage` spacing
  values almost exactly (was inconsistent and put the title noticeably
  higher on the page than the LaTeX version) — confirmed by rendering both
  covers to PNG at the same DPI and comparing the title's vertical position
  directly, not just reading the spacing values.

### Should "degree" live in the title block or the metadata box?

Kept it where it already was: its own line directly under the title, in
`utad-blue`, not inside the Subject/Year/Teacher/... info box. Reasoning:
the title block (eyebrow + title + degree) is the part of the cover that
identifies *what this document fundamentally is* — reading "Internship
Report" then "B.S. in Software Engineering..." together as one statement is
how a reader would describe the document out loud. The info box below, by
contrast, is administrative record-keeping (who supervised it, what term,
what dates) — useful, but secondary, and mixing "degree" into that list
would bury a defining fact about the document among logistics fields. If a
report ever needs to show multiple degrees or a joint program, the degree
line can wrap or shrink before it would make sense to demote it into the
info box instead.

## Design-audit pass — alignment, dashes, cohesion

A focused hunt for design flaws (misalignment, colors, cover space usage),
each fix confirmed by compiling and comparing rendered PNGs of the two
templates side by side, not by reading source.

- **LaTeX cover metadata baseline misalignment**: labels sat about half a
  line below their values (e.g. "Student" lined up with the gap under
  the author's name, not with the name itself). Two compounding causes,
  both found with isolated probes: (1) a `\strut` on the label cell only,
  and (2) the document-wide `\parskip` (see below) silently dropping each
  `p{}` label cell's first line. Fixed by putting `\strut` on both the
  label and value cell and zeroing `\parskip` on the title page (the cover
  positions everything with explicit `\vspace`, so it wants no `parskip`).
- **Literal `--` double-hyphens**: Carlito happens to carry a
  `--`→en-dash ligature in its own font tables, but Poppins does not — so
  every heading, Gantt label, evolution-chain box, section title and
  weekly-log week label (all Poppins) rendered a literal double-hyphen
  while body text (Carlito) showed a proper en-dash. Fixed by enabling
  `Ligatures=TeX` on both font families (and repeating it on the inline
  `\fontspec{Poppins Medium}` in the weekly-log macro, which does not
  inherit a `\newfontfamily`'s options). On the Typst side, string-literal
  labels (the timeline rows, weekly-log week strings, the cover date)
  don't get Typst's automatic `--`→en-dash conversion the way markup text
  does, so those specific strings in the example were switched to a real
  en-dash character.
- **Paragraph style mismatch**: the LaTeX side used the report class
  default (first-line indent, no space between paragraphs) while Typst
  used no indent and a blank-line gap. The same body copy read differently
  across the two. Set LaTeX to `\parindent=0pt` + a `\parskip` so a
  paragraph break looks the same in both. (This `parskip` is what exposed
  the cover-baseline and weekly-log spacing issues above, both now scoped
  so only their own explicit spacing applies.)
- **Typst cover metadata floated off the left margin**: with a fixed-width
  label column, the short labels (Subject/Year/Teacher/Author/Date)
  right-aligned to a point well inside the page, so the whole block sat
  visibly indented from the logo/title's left edge — breaking the cover's
  one-shared-left-margin principle (which the LaTeX side got right only
  because its longest label happens to reach the margin). Changed the
  label column to `auto` so the widest label sits exactly on the left
  margin, anchoring the block there like LaTeX.
- **Missing space before the period en-dash on the LaTeX cover**:
  `\utadPeriodStart -- \utadPeriodEnd` lost the space before `--` because
  a control-word macro gobbles its trailing space, giving "2026– Jul".
  Fixed with an explicit `{}` after the macro.
- **Table zebra-stripe colour drift**: LaTeX striped rows with
  `#EEF3FC` (utadlight) and Typst with a fainter `#F5F8FC`, so the same
  table read with different strength in each. Synced Typst to `#EEF3FC`.
- **`\cftaftertoctitle` undefined control sequence**: the rule under the
  "Contents" title used `\titlerule[0.5pt]`, whose optional-argument form
  needs titlesec internals only defined inside a `\titleformat` — it
  raised an "Undefined control sequence" at `\tableofcontents` (swallowed
  by nonstopmode). Swapped for a plain `\rule{\linewidth}{0.5pt}`, which
  draws the identical hairline with no titlesec dependency.

A new dark-navy `important()` callout was also added to the Typst side in
the previous pass.

## Cover vertical rebalance

The cover previously dumped all its free vertical space into one gap below
the title, so the title floated in the upper third over a large dead zone.
Both templates now split the slack into two flexible gaps — `1.15` units
above the title block and `1` below — so the title lands just above the
optical centre with balanced breathing room on both sides, while the logo
stays pinned near the top and the metadata block stays anchored at the
foot. The ratio is `>1` above so the title sits a touch below dead-centre
(more grounded than mathematically centred). Because the gaps are flexible
(`v(1.15fr)` / `v(1fr)` in Typst, `\vspace{\stretch{1.15}}` /
`\vspace{\stretch{1}}` in LaTeX), the layout adapts on its own to how tall
the metadata block is — the 10-field internship cover and a 5-field cover
both stay balanced without hand-tuning. Verified by rendering covers with
both field counts and checking the title landed in the same proportional
band. Anchoring the metadata at the very foot (rather than floating it with
slack below) was a deliberate choice — the foot anchor reads as
intentional, and the remaining above/below-title breathing is what makes
the composition feel balanced rather than top-heavy.

## Polish pass — title spacing, info-box alignment, code highlighting, navy callout

- **LaTeX cover info-box baseline skew + loose rows**: the label cell
  switches to `\headingfont` (Poppins), whose line height is taller than
  the Carlito value beside it — so the built-in `\strut` (which takes the
  *current* font's `\baselineskip`) both inflated each row and dropped the
  label about half a line below its value. Replaced it with `\utadstrut`, a
  fixed strut pinned to `\normalbaselineskip` (identical in both cells
  regardless of font), and set `\arraystretch` to `0.92`. Labels now sit on
  the same baseline as their values and the rows are noticeably tighter.
  Verified against an isolated probe (font-dependent strut skewed + loose,
  fixed strut aligned + tight).
- **Typst cover title spaced too loosely vs LaTeX**: Typst was adding its
  inter-paragraph spacing (0.8em) on top of the explicit gaps between
  subtitle / title / degree, pushing those lines ~0.3–0.5cm further apart
  than the identical gaps on the LaTeX cover. Wrapped the title block in a
  scope with paragraph spacing set to `0pt` and set the explicit gaps to
  match LaTeX; measured the rendered gaps to confirm they now line up
  (0.61cm / 0.78cm vs LaTeX's 0.63cm / 0.81cm).
- **LaTeX code block had no syntax highlighting**: the `listings` setup was
  plain monospace. Added a highlighting scheme sampled from the Typst
  side's `raw` output — red keywords, grey-italic comments, green strings —
  on the same light grey-blue background (`#F4F6FA`) with a hairline frame,
  and dropped the line numbers so the two templates' code blocks read the
  same. SQL type names (`INT`, `NUMERIC`, `UUID`, …) aren't in `listings`'
  base SQL keyword set, so they're added via `morekeywords`.
- **Typst `important()` box restyled to the callout family**: it was a
  solid navy fill with reversed white text, which stood apart from the
  light left-border note/callout boxes. Rebuilt it as `callout(...)` with
  the navy accent and a light navy-tint background (`#e6e8ef`) — so it's
  now the navy sibling of the blue `note()` box (navy title, navy left
  rule, light navy-tint fill), and all the status boxes share one visual
  language while staying distinguishable (cooler/greyer fill than the blue
  note's `#eef2f8`).

## Cover refinement — full logo, unified fields, spec-sheet info box

- **Full logo lockup on the cover**: both covers now use `logo-full.svg`
  (mark + "U-tad" + "University of Technology, Arts & Design" tagline, with
  a thin divider) instead of the bare "U-tad" wordmark. Built as a new
  asset (wordmark paths + the tagline as live Poppins text) and rendered to
  PDF for LaTeX; the tagline shows correctly in both Typst (native SVG) and
  LaTeX (via cairosvg) because Poppins is installed.
- **Same five cover fields in both templates**: the cover info box is now
  Subject / Year / Teacher / Author / Date in both (the LaTeX side dropped
  the internship-specific 10-field set). Author is `\setutadauthor` /
  `author:` — one source of truth, reused in the running header. The
  internship-specific details (company, tutors, hours, …) belong in the
  body now, not the cover.
- **Info-box restyled to the "spec sheet" look** the reader preferred from
  the original template: bold labels in the same muted grey as the
  "ACADEMIC DIVISION" eyebrow (right-aligned), a thin grey vertical divider,
  then values in navy (left-aligned). The block is left-justified — the
  widest label sits on the page's left margin (Typst `auto` column; LaTeX
  `\settowidth`), so it shares the logo/title's left edge. On the LaTeX side
  the divider is a `\vrule` in the intercolumn material, which is safe here
  (no `>{...}`-prefixed columns, so the old row-shift bug doesn't apply) —
  verified with a deliberately wrapping value.
- **Typst cover matched to LaTeX's proportions**: title bumped to 34pt (from
  28pt), degree line set lighter (weight 400, ~14pt, matching LaTeX's
  regular-weight `\Large`), and the cover — plus the body — moved to 2.5cm
  horizontal margins (from 2.2cm) to match LaTeX throughout. The body
  reflows cleanly (timeline/diagrams/tables are all flexible-width).

## Design audit — color theory & layout scrutiny

A pass over both templates against colour-theory and document-layout
principles. What was changed, and what was assessed and deliberately left.

**Fixed**

- **Info-box divider removed**: the label|value rule read as too heavy for a
  five-row block. Labels and values are now separated by whitespace alone
  (bold muted-grey labels, navy values) — lighter, still clearly a two-column
  spec sheet.
- **TOC typeface consistency**: subsection entries were silently falling back
  to the body font (Carlito) while chapters/sections were Poppins — the
  contents page mixed two typefaces. All three levels are Poppins now, on
  both templates.
- **TOC leader dots + depth unified**: LaTeX chapter entries now get the same
  dotted leaders as sections (they had none), matching the Typst outline; and
  both templates' contents pages now show the same depth (through
  subsections).
- **Heading hierarchy unified across templates**: the Typst headings were
  markedly smaller than LaTeX's (chapter 15pt vs ~24pt) and level-3 sat at
  the body size (no real step down). Typst now uses the same scale as LaTeX
  (~24 / 14 / 12pt for chapter / section / subsection) with matching spacing,
  and **level-1 headings start a new page** — the formal-report convention
  the LaTeX `report` class already applied. The two documents now share one
  heading system. (If you'd rather the Typst side stay compact — smaller
  headings, chapters flowing continuously instead of one-per-page — that's a
  one-line change; this pass chose to match the more formal LaTeX behaviour.)

**Assessed and kept as-is**

- **Palette**: navy `#14192C`, blue `#1B5FE0` and the grey `#5B6472` are all
  in the same blue hue family (~220°) — a tight analogous/monochromatic
  scheme with the grey as a desaturated cousin. That's why it reads as
  cohesive rather than busy. Blue is held to accent duty only (numbers,
  links, the degree line, thin rules) with no large blue fills; navy carries
  the structural weight (titles, headings, table headers, footer strips).
- **Contrast/accessibility**: navy on white ≈ 15:1, blue on white ≈ 5.2:1,
  grey on white ≈ 5.8:1 — all clear WCAG AA for body text, so nothing in the
  palette is too light to read.
- **Semantic colour coding**: `note()` = blue accent (informational), the
  navy `important()` = heavier navy accent, table headers = solid navy,
  evolution-chain states = grey→light-navy→solid-navy. Colour carries
  meaning consistently.
- **Code syntax colours** are the one intentional exception to the all-blue
  palette: keywords are red (`#D23246`), matching Typst's built-in
  highlighting. Red is off-brand, but it's confined to code blocks and hue
  variety is what makes syntax highlighting readable — a deliberate trade of
  brand purity for legibility, not an oversight.

One remaining *content* (not template) difference: the Typst example carries
three extra placeholder chapters (Competencies / Challenges / Conclusions)
that the LaTeX example omits, so the Typst PDF runs longer. That's example
copy, not a template asymmetry.

## Latest fixes

- **Cover logo alignment (LaTeX)**: an overlay `tikzpicture` (the navy
  strips) left the logo in its paragraph, nudging it ~0.09cm inboard of the
  left margin. A `\par` after the strips lets the logo sit flush on the
  margin, aligned with the title/metadata (matching the Typst cover).
- **Cover info-box spacing (LaTeX)**: opened the row spacing
  (`\arraystretch` 1.15 → 1.25) to match the more generous Typst rhythm.
- **Evolution-chain arrows (LaTeX)**: the boxes were ~3pt apart, so the
  connector arrows were invisible and their heads overlapped the next box.
  A real 0.7cm gap is now reserved between boxes (box widths recomputed to
  keep the row filling the text width), the arrows are drawn edge-to-edge
  in that gap, and long labels wrap inside the fixed-width boxes instead of
  stretching them past the margin.
- **Code line numbers**: both templates now number code lines in a small
  grey gutter (`numbers=left` on the LaTeX listing; a `raw.line` show rule
  on the Typst side).
- **Clean contents page (both templates)**: the long-format TOC is now
  front matter in Typst too -- no running header, no footer/page number --
  matching the LaTeX `\utadcontents`. Use `#utad-outline()` in the report
  body instead of a bare `#outline(...)`. (The compact assignment keeps its
  inline contents; this is long-format only.)
- **Typst timeline + evolution chain tightened to match LaTeX**: the Gantt
  now draws subtle per-day vertical gridlines (like the LaTeX `vgrid`), with
  tighter row bands and the day numbers sitting directly above the bars; the
  schema-evolution boxes use larger text and less vertical padding so they
  read like the LaTeX chain instead of looking empty.
- **Organigram / org-chart (both templates)**: a hierarchical tree for
  organisation, placement, or taxonomy diagrams. Typst: build the tree with
  `org-node(body, ..children, style:)` and pass the root to `orgchart(...)`.
  LaTeX: the `utadorgchart` environment wraps a styled TikZ tree (write it
  with `\node[...]{} child { node[...]{} ... }`). Both share three node
  styles -- `root` (navy), `node` (light, default), and `highlight`
  (accent-blue, e.g. the box you sat in) -- and draw square fork-down
  connectors. The internship example now uses it for the placement figure
  (replacing the old "Diagram TODO" note).
- **Gantt dependency arrows (both templates)**: finish-to-start links can be
  drawn between bars. LaTeX: name the bars (`\ganttbar[name=env]{...}`) and
  add `\ganttlink{from}{to}` inside `utadtimeline`. Typst: pass `links:` to
  `timeline()` as `(from, to)` 0-based row-index pairs, e.g.
  `links: ((0, 5), (5, 6))`. In both, the arrow is the accent blue with a
  thin white casing drawn underneath, so where a link must cross a navy bar
  it stays legible instead of blending in. Omit the links for a plain chart.
- **Contents page (LaTeX)**: `\utadcontents` typesets the table of contents
  as clean front matter -- no running header and no footer/page number,
  the same treatment as the cover -- instead of stamping a page number on
  the contents itself. (Use it in place of `\tableofcontents`.)

## Field-use pass — running header, auto chain, body metadata

Found while writing a real report with the LaTeX template. All
three confirmed by compiling and reading word-level text positions off the
rendered PDF (`pdftotext -bbox`), not by eyeballing the source.

- **Running header showed the author's name on every page** instead of the
  current section. The right-hand running head was hard-wired to
  `\utadAuthorName`, so all pages repeated the same name — no help for
  navigation. Changed to `\nouppercase{\rightmark}` so it tracks the current
  section (like the Typst side). Two things bundle here: `\rightmark` is what
  makes it follow the section, and `\nouppercase{}` is *required* because the
  `report` class's inherited `\sectionmark` upper-cases the mark — without it
  the header read `4.1. COMMERCIAL DATA SCHEMA DESIGN` in all-caps. With it,
  the header shows real title case, and is empty on a chapter-opening page
  (before the first section). Verified across pages 8–11 of the example
  report. `\utadAuthorName` is still used on the cover and is still set with
  `\setutadauthor{...}`.
- **Typst parity for the same header**: the Typst running head was showing
  the author too, so it got the matching fix — the right side now queries the
  current level-2 heading and prints `4.1. Section title` (mixed case), empty
  before the first section. LaTeX and Typst headers now say the same thing.
- **`utadchain` per-row count is now automatic** (see the usage note earlier
  in this guide). Previously `\begin{utadchain}[n]` needed a hand-tuned `n`
  found by trial and error — an 8-item chain wanted 4, but a 6-item chain
  needed 3 because the labels overflowed at the wider 2-per-row-implied box
  size. The environment now buffers its boxes, counts them at `\end`, and
  picks the largest per-row value that keeps every box above a minimum width
  (`\utadchainminw`, 2.6cm) for the current `\textwidth`, balanced across
  rows (8→4+4, 6→3+3, 5→3+2). `\begin{utadchain}[n]` still forces `n`.
  Implementation note: the balancing math uses iterative `\loop`/`\ifdim`
  and `\@whilenum` counting, **not** `\numexpr` division — `\numexpr` rounds
  rather than floors, which breaks the floor/ceil needed here. The option is
  matched with etoolbox's `\ifdefstring`, not `\ifx` (an `\ifx` against a
  `\def`'d "auto" string misfired and leaked the literal letters into a
  number register).
- **`\utadmetarow{Label}{Value}`** added for document metadata beyond the
  five fixed cover fields (Company, Period, Supervisor, …). It renders a
  body line in the cover's spec-sheet style (right-aligned bold grey label,
  navy value, values aligned on a fixed 3cm label column via
  `\utadmetalabelwidth`). The cover's five-field box stays fixed by design;
  the recommendation to "put extra metadata in the body" now has a helper and
  a worked snippet instead of only prose.
