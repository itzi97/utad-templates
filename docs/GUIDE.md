# U-tad report templates (LaTeX + Typst)

Two templates, one visual identity: squared corners everywhere, a navy-dominant
palette (`#14192C`) with blue (`#1B5FE0`) used only as a small accent (chapter
numbers, section numbers, links, a thin accent rule) — never as a fill for
large areas. Both share the same cover layout: a masthead. Thin navy accent
strips top and bottom (a color detail, not a container — a bright blue band
here would read as a different palette from the rest of the navy-dominant
identity and clash against it), the logo standalone in the white body,
left-aligned, then an eyebrow line, a CAPITALIZED title, and a blue degree
line all sharing one left margin, then a left-aligned metadata block near the
foot. One consistent left edge anchors the whole page, rather than centering
everything — this reads as an official document, not a poster/slide title
card.

## Contents

- [What's here](#whats-here)
- [Starting a new document (Typst)](#starting-a-new-document-typst)
- [Starting a new document (LaTeX)](#starting-a-new-document-latex)
- [Component reference](#component-reference) — every helper, LaTeX + Typst side by side
- [Compact assignment template](#compact-assignment-template)
  - [Solution-set convention](#solution-set-convention)
- [Development history & design notes](DEVLOG.md) — dated passes, fixed-issue log, design rationale

## What's here

The kit is split by language so each folder is self-contained (drop it into a
new project as-is). Within each folder, the files fall into three groups:
**template** files you import, a **starter** you copy to begin a new document,
and **examples** you read for reference.

```
latex/
  utad.sty                 ← TEMPLATE: the package you \usepackage
  starter.tex              ← STARTER: copy this to begin a new report
  example.tex              ← EXAMPLE: full worked report
  logo-*.pdf               ← logo assets (LaTeX needs the PDF versions)
typst/
  utad.typ                 ← TEMPLATE: base module (cover, headings, callouts…)
  utad-report.typ          ← TEMPLATE: long-report extras (appendices, weekly
                              log, evolution-chain, timeline, orgchart)
  utad-assignment.typ      ← TEMPLATE: compact assignment / problem-set format
  starter-report.typ       ← STARTER: copy to begin a long report
  starter-assignment.typ   ← STARTER: copy to begin a short assignment
  example.typ              ← EXAMPLE: full worked report
  assignment.typ           ← EXAMPLE: worked problem set
  spark-solution.typ       ← EXAMPLE: boxed question / solution style
  logo-*.svg               ← logo assets (Typst reads the SVGs)
README.md
```

The three templates and the format each uses:

1. **LaTeX report** — a real LaTeX package: `\usepackage{utad}`, set fields with
   `\renewcommand`, call `\utadtitlepage` / `\utadcontents`. Multi-chapter.
2. **Typst report** — imported modules: `#import "utad.typ": *` (+
   `utad-report.typ`) then `#show: utad-doc.with(...)`. Multi-chapter, cover +
   contents page, the same feature set as the LaTeX package.
3. **Typst compact assignment** — one module: `#import "utad-assignment.typ": *`
   then `#show: assignment.with(...)`. No cover/contents page; a compact
   masthead then content. For short deliverables (~2–5 pages).

To start a new document, copy the matching **starter** file (and keep the
template files + logo assets in the same folder), then fill in the fields.
Detailed steps per language are in the two sections below. The **examples**
compile as-is and show every feature in context.

> **Feature parity.** The LaTeX package and the Typst templates now ship the
> same callout/box set. LaTeX exposes them as environments — `utadnote`,
> `utadcallout`, `utadimportant`, `utadexercise`, `utadquestion` (+
> `\utadsolution`), and `utadprompt` / `utadresponse` — styled to match the
> Typst `note` / `callout` / `important` / `exercise` / `question` /
> `solution` / `prompt` / `response`.

- Logo assets (dark-ink + white-ink variants of each). The **cover** uses
  the full lockup, `logo-full.svg` — the mark + "U-tad" + a "University of
  Technology, Arts & Design" tagline (with a thin divider between the
  wordmark and the tagline). The other variants are available via the
  `variant:` option (Typst) or by pointing `\utadLogoFile` at a different
  file (LaTeX): `logo-wordmark.svg` (mark + "U-tad" only), `logo-mark.svg`
  (just the rounded-U mark). The Typst footer uses `logo-mark.svg`. Keep the
  `.svg` files in the same folder as your `.typ` document. LaTeX needs PDF
  versions — `logo-full.pdf`, `logo-wordmark.pdf`, `logo-mark.pdf` (+ white
  variants) are included pre-rendered; regenerate them if you edit a source
  `.svg`, e.g.:
  `python3 -c "import cairosvg; cairosvg.svg2pdf(url='logo-full.svg', write_to='logo-full.pdf')"`.
  (The tagline in `logo-full.svg` is live text set in Poppins, so that font
  must be installed for the PDF re-render to match.)

## Starting a new document (Typst)

1. Copy `utad.typ`, `utad-report.typ` (only if you need appendices, the
   weekly-log block, or the diagrams), and all three `.svg` logo files into
   your project folder.
2. Import and call the template:

   ```typst
   #import "utad.typ": *
   #import "utad-report.typ": *   // only if you're using the report extras

   #show: utad-doc.with(
     title: [Your Title],
     subtitle: [Academic Division],   // optional
     subject: [Course / Placement],   // optional, shown on the cover
     degree: [Your Degree],
     year: [4],
     teacher: [Tutor Name],
     author: "Your Name",
     date: "Month DD – Month DD, YYYY",   // note: use a real en-dash "–" in
                                          // string values; Typst only auto-
                                          // converts "--" inside markup, not
                                          // inside quoted strings
     variant: "full",                 // "full" (default) | "wordmark" | "mark" | "text" | "none"
   )

   #utad-outline()   // clean front-matter contents page (no header/footer)

   = Your First Heading
   Body text...
   ```
3. Compile with `typst compile report.typ report.pdf` (or `typst watch` while
   editing).

Or just copy **`typst/starter-report.typ`** (long report) or
**`typst/starter-assignment.typ`** (short assignment) — each has all the
fields and a cheat-sheet of the available helpers in comments.

Useful pieces from `utad.typ`: `callout(...)`, `note(...)`, `prompt(...)` /
`response(...)`, `utad-table(...)`, `exercise(title, body)`,
`question(body, label: "Question")` / `solution(body)`,
`utad-outline(title: [Contents])` (clean front-matter TOC). From
`utad-report.typ`: `weeklog(week, tasks, tools, outcome)`,
`reference-list((...))`, `evolution-chain((...), per-row: 4)`,
`timeline(total-days: N, rows: (...), links: (...))`,
`orgchart(org-node(...))` (organigram tree). The LaTeX side mirrors these
with `utadtimeline` (+ `\ganttlink`) and the `utadorgchart` environment
(`orgroot` / `orgnode` / `orghi` node styles).

**Appendices**: switching from numeric to lettered headings can't be a
function call in Typst (`set`/`show` rules don't leak out of one) — write it
as two bare statements at the point appendices start:

```typst
#counter(heading).update(0)
#set heading(numbering: "A.1")
```

## Starting a new document (LaTeX)

1. Copy `utad.sty` and the pre-rendered logo PDFs
   (`logo-wordmark-white.pdf`, `logo-mark.pdf`, `logo-mark-white.pdf`) into
   your project folder.
2. Compile with **XeLaTeX or LuaLaTeX** — the package needs `fontspec` for
   Poppins/Carlito and will not build under plain `pdflatex`.
3. Minimal document:

   ```latex
   \documentclass[11pt,a4paper]{report}
   \usepackage{utad}

   \renewcommand{\utadTitle}{Your Title}
   \renewcommand{\utadSubtitle}{Academic Division}
   \renewcommand{\utadDegree}{Your Degree}
   \renewcommand{\utadSubject}{Course / Placement}
   \renewcommand{\utadYear}{4}
   \renewcommand{\utadTeacher}{Tutor Name}
   \renewcommand{\utadDate}{Month DD -- Month DD, YYYY}
   \setutadauthor{Your Name}
   \setutadrunningtitle{Short Running Title}

   \begin{document}
   \utadtitlepage
   \utadcontents

   \chapter{Your First Chapter}
   Body text...
   \end{document}
   ```
4. Compile: `xelatex document.tex` (run twice for the table of contents).

Or just copy **`latex/starter.tex`** — it already has all the fields and a
cheat-sheet of the available helpers in comments.

Every title-page field is set with `\renewcommand` before `\utadtitlepage` —
not passed as macro arguments — because TeX macros cap at 9 positional
arguments and this title page needs more than that; this is the deliberate
workaround, not an oversight.

Other building blocks: `\utadtable` + `\tblheadrow`/`\tblhead{...}` for
tables, `\utadweeklog{week}{tasks}{tools}{outcome}`,
`\utadmetarow{Label}{Value}` for extra document metadata that doesn't fit
the five cover fields (see below), the `utadrefs`
environment + `\utadref`, the `utadchain` environment +
`\utadchainbox{style}{version}{label}` for evolution diagrams, the
`utadtimeline` environment + `\ganttbar`/`\ganttmilestone` (+ `\ganttlink`
between named bars for dependency arrows), and the `utadorgchart`
environment (`orgroot`/`orgnode`/`orghi` node styles) for organigrams.

The `utadchain` environment now **lays itself out automatically**: just
`\begin{utadchain}` (no argument) and drop in as many `\utadchainbox` calls
as you need — it picks a balanced number of boxes per row that keeps each
box above a sensible minimum width for the current `\textwidth`, so an
8-item chain wraps to 4+4 and a 6-item chain to 3+3 without you counting.
Pass an explicit count (`\begin{utadchain}[3]`) only to override the
automatic choice.

Extra cover metadata (Company, Period, Supervisor, Cohort, …) that isn't one
of the five fixed cover fields (Subject / Year / Teacher / Author / Date)
goes in the **body**, not on the cover, styled to match the cover's spec
sheet with `\utadmetarow{Label}{Value}`:

```latex
\chapter{Introduction}
\utadmetarow{Company}{Acme Software}
\utadmetarow{Period}{Jun--Sep 2026}
\utadmetarow{Supervisor}{Dr. Jane Smith}
```

Consecutive rows align on a fixed 3cm label column; if your labels are
wider, `\setlength{\utadmetalabelwidth}{3.6cm}` once before the first row.

Callout / box environments (parity with Typst): `utadnote[Title]`,
`utadcallout[Title]`, `utadimportant[Title]`, `utadexercise{Title}`,
`utadquestion[Label]` + `\utadsolution`, and `utadprompt` / `utadresponse`.
All take their body as environment content; the `[...]` title is optional
(pass an empty `[]` for no title).

## Component reference

Every helper the templates provide, with the **LaTeX** and **Typst** form
side by side and a minimal example. Where a component exists in only one
system, the other column says so. LaTeX fields are set with `\renewcommand`
(or the `\set...` commands) *before* the cover command; Typst options are
passed to `utad-doc` / `assignment`.

### Document setup and cover

The report cover reads a fixed set of fields and renders a full-logo cover
plus a clean contents page.

**LaTeX** — set the fields, then call `\utadtitlepage` and `\utadcontents`:

```latex
\renewcommand{\utadTitle}{Report Title}
\renewcommand{\utadSubtitle}{Academic Division}   % small eyebrow
\renewcommand{\utadDegree}{Software Engineering w/ AI & Data Science}
\renewcommand{\utadSubject}{Subject}
\renewcommand{\utadYear}{4}
\renewcommand{\utadTeacher}{Teacher Name}
\renewcommand{\utadDate}{Month YYYY}
\setutadauthor{Your Name}
\setutadrunningtitle{Short Title}   % shown in the running header
\begin{document}
\utadtitlepage
\utadcontents
```

**Typst** — pass the same fields to `utad-doc`, then `#utad-outline()`:

```typ
#show: utad-doc.with(
  title: [Report Title], subtitle: [Academic Division],
  degree: [Software Engineering w/ AI & Data Science],
  subject: [Subject], year: [4], teacher: [Teacher Name],
  author: "Your Name", date: "Month YYYY",
  short-title: [Short Title],   // running-header title; defaults to title
  variant: "full",             // logo: "full" | "wordmark" | "mark" | "text" | "none"
)
#utad-outline()
```

### Headings

Both systems auto-number headings and show the current section in the
running header. LaTeX: `\chapter{}`, `\section{}`, `\subsection{}`,
`\subsubsection{}`. Typst: `=`, `==`, `===`, `====`.

The **fourth level** (`\subsubsection` / `====`) is styled navy Poppins bold
with a small blue-square lead-in, one step down from the third. By default
it is **unnumbered and absent from the contents** (LaTeX `secnumdepth` is 2;
the Typst outline is capped at depth 3), so it doubles as a lightweight
"named phase" heading for breaking up a long run without cluttering the TOC.
Bump `secnumdepth`/`tocdepth` to 3 in LaTeX if you want it numbered and
listed.

### Body metadata — `\utadmetarow`

Extra metadata that doesn't fit the five cover fields (Company, Period,
Supervisor, …) goes in the body, styled to match the cover's spec sheet.

**LaTeX:**

```latex
\utadmetarow{Company}{Acme Software}
\utadmetarow{Period}{Jun--Sep 2026}
```

Rows align on a fixed 3 cm label column (`\setlength{\utadmetalabelwidth}{3.6cm}`
to widen). **Typst:** no dedicated helper — put such lines in body text or a
small `table`.

### Callout boxes

Same seven boxes in both systems; the `[Title]` / `title:` is optional.

| Purpose | LaTeX | Typst |
|---|---|---|
| Blue note | `\begin{utadnote}[Title] … \end{utadnote}` | `#note(title: [Title])[ … ]` |
| Navy callout | `\begin{utadcallout}[Title] … \end{utadcallout}` | `#callout(title: [Title])[ … ]` |
| Emphasis | `\begin{utadimportant}[Title] … \end{utadimportant}` | `#important(title: [Title])[ … ]` |
| Exercise / problem | `\begin{utadexercise}{Title} … \end{utadexercise}` | `#exercise([Title])[ … ]` |
| Question (restate) | `\begin{utadquestion} … \end{utadquestion}` | `#question[ … ]` |
| Solution lead-in | `\utadsolution worked answer…` | `#solution[ … ]` |
| Prompt / response | `\begin{utadprompt} … \end{utadprompt}` / `utadresponse` | `#prompt[ … ]` / `#response[ … ]` |

### Tables

Striped tables with a navy header row.

**LaTeX** — prefix a `tabularx` with `\utadtable`; open the header row with
`\tblheadrow` and wrap each header cell in `\tblhead{}`:

```latex
{\utadtable
\begin{tabularx}{\textwidth}{@{}p{4cm}X@{}}
\tblheadrow \tblhead{Category} & \tblhead{Detail} \\
Languages & Python, SQL \\
\end{tabularx}}
```

**Typst** — `utad-table(columns, header, …cells)`; optional `cell-align`
(a value or per-column array) and `inset`:

```typ
#utad-table(
  columns: (auto, 1fr),
  header: ([Category], [Detail]),
  [Languages], [Python, SQL],
)
```

### Code blocks

Line-numbered with syntax highlighting. **LaTeX:**
`\begin{lstlisting}[language=Python] … \end{lstlisting}`. **Typst:** a fenced
block ```` ```python … ``` ````.

### Evolution / step chain

A row of connected boxes; the per-row count is chosen automatically.

**LaTeX** — `utadchain` (no argument = auto; `[n]` forces n per row) with
one `\utadchainbox{style}{version}{label}` per step; styles are `start`,
`mid`, `final`:

```latex
\begin{utadchain}
\utadchainbox{start}{v1}{Baseline}
\utadchainbox{mid}{v2}{Refined}
\utadchainbox{final}{v3}{Final}
\end{utadchain}
```

**Typst** — `evolution-chain((version, label, style), …)`. It lives in the
**base module** (`utad.typ`), so the compact assignment can use it too — no
need to import `utad-report.typ` for the step chain alone. (It's still
re-exported from `utad-report.typ` for older imports.)

```typ
#evolution-chain(
  ("v1", "Baseline", "start"),
  ("v2", "Refined", "mid"),
  ("v3", "Final", "final"),
)
```

### Timeline (Gantt)

A proportional bar chart with day gridlines and finish-to-start dependency
arrows.

**LaTeX** — `utadtimeline{total-days}` with `\ganttbar[opts]{label}{start}{end}`,
`\ganttmilestone{label}{day}`, and `\ganttlink{from}{to}` between named bars
(`[name=x]`); a greyed "planned" bar uses `bar/.append style={…}`:

```latex
\begin{utadtimeline}{31}
\ganttbar[name=a]{Design}{1}{10} \\
\ganttmilestone{Demo}{10} \\
\ganttbar[name=b]{Build}{11}{20} \\
\ganttlink{a}{b}
\end{utadtimeline}
```

**Typst** — `timeline(total-days, rows, links)`; each row is
`(label, start, end, kind)` with kind `"done"` / `"planned"` / `"milestone"`;
`links` are 0-based `(from, to)` row-index pairs:

```typ
#timeline(total-days: 31, rows: (
  ("Design", 1, 10, "done"),
  ("Demo", 10, 10, "milestone"),
  ("Build", 11, 20, "done"),
), links: ((0, 2),))
```

### Org chart / tree

A hierarchical tree (organisation, placement, taxonomy, architecture). Three
node styles: root (navy), default node, and highlight (accent blue).

**LaTeX** — `utadorgchart` around a TikZ tree; node styles `orgroot`,
`orgnode`, `orghi`:

```latex
\begin{utadorgchart}
\node[orgroot]{Top}
  child { node[orgnode]{Branch}
    child { node[orghi]{Focus} } };
\end{utadorgchart}
```

**Typst** — build with `org-node(body, ..children, style:)` (styles `"root"`,
`"node"`, `"highlight"`) and pass the root to `orgchart`:

```typ
#orgchart(
  org-node("Top", style: "root",
    org-node("Branch",
      org-node("Focus", style: "highlight"))),
)
```

### Weekly / development log

**LaTeX:** `\utadweeklog{week}{tasks}{tools}{outcome}`.
**Typst:** `weeklog(week, tasks, tools, outcome)`.

```typ
#weeklog("1 (Week 1)", [Set up pipeline…], [Python, Git], [Baseline done.])
```

### Reference list

Hanging-indent bibliography. **LaTeX:** `\begin{utadrefs} \utadref Author…
\end{utadrefs}`. **Typst:** `reference-list((item, item, …))`.

### Slides (Typst only)

A self-contained 16:9 deck (`utad-slides.typ`), no external package:

- `title-slide(title:, subtitle:, author:, date:, event:)` — opening slide.
- `section-slide[1 · Section]` — divider; records the section tag.
- `slide(title: [Heading])[ … ]` — content slide; options `align-center:`,
  `fit: true` (scale a wide diagram to fill).
- `focus-slide[One big takeaway.]` — full-bleed statement slide.
- `slide-columns(left, right, ratio: (1fr, 1fr))` — two-column body.
- `agenda-slide(items, current: n)` — contents slide highlighting a section.
- `stat(number, caption)` — a headline-number block.

### Compact assignment (Typst only)

`assignment.with(title:, subtitle:, subject:, teacher:, author:, date:,
contents:)` — a masthead format with no cover/contents page (see the
dedicated section below).


## Compact assignment template

A second Typst template for short deliverables -- a handful of questions,
~2-5 pages (problem sets, short assignments). It shares the whole U-tad
brand with the report (`#import "utad-assignment.typ": *` re-exports
everything from `utad.typ`, so `callout` / `note` / `important` /
`exercise` / `utad-table` are all available), but differs in structure:

- **No cover page and no separate contents page.** Page 1 opens with a
  compact masthead -- logo, title, optional subtitle, the same
  bold-label / navy-value info box as the report cover, and a navy rule --
  then the content flows straight on.
- **Continuous flow**: level-1 headings do NOT start a new page (they keep
  the navy underline rule, just at a compact size), since a 2-5 page
  document shouldn't scatter one question per sheet.
- **Optional inline contents**: `contents: true` prints a short "Contents"
  list right under the header (never on its own page).

```typst
#import "utad-assignment.typ": *
#show: assignment.with(
  title: [Problem Set 3],
  subtitle: [Series and Fourier Transforms],  // optional
  subject: [Mathematical Analysis],
  teacher: [Teacher Name],
  author: "Your Name",
  date: "May 24, 2026",
  contents: true,                 // optional inline contents
  logo-variant: "full",           // "full" | "wordmark" | "mark" | "none"
)

= Question 1
...
```

See `assignment.typ` (`assignment.pdf`) for a worked two-page problem set.
Needs the same logo `.svg` files in the folder.

### LaTeX compact deliverables — `\utadmasthead`

The LaTeX side has the same option without a separate class: call
`\utadmasthead` instead of `\utadtitlepage`/`\utadcontents`, and use
`\section` as your top level. It reuses the whole package and just swaps the
cover for a compact inline header (logo, title, optional subtitle, navy rule,
the shared info box); `\section`/`\subsection` renumber flat (1, 1.1) since
there are no chapters.

```latex
\documentclass[11pt,a4paper]{report}
\usepackage{utad}
\renewcommand{\utadTitle}{Problem Set 3}
\renewcommand{\utadSubtitle}{Series and Fourier Transforms}  % optional
\renewcommand{\utadSubject}{Mathematical Analysis}
\setutadauthor{Your Name}
\begin{document}
\utadmasthead
\section{Question 1}
...
```

### Building without the logo assets

The U-tad logo files are the university's property and aren't covered by the
MIT license, so a fresh clone or a fork may not have them. LaTeX degrades
automatically (every logo is wrapped in `\IfFileExists`, so a missing asset
just leaves a bare cover). **Typst has no file-existence check**, so it can't
do that silently — instead pass `variant: "none"` (report) or `logo-variant:
"none"` (assignment) to skip every logo image, or call `no-logo-slides()`
once at the top of a deck. `"text"` stands in a plain "U-tad" wordmark;
`"none"` omits the mark. Without one of these, Typst stops at the first
missing `logo-*.svg` with a "file not found" error.

### Solution-set convention

For a document where you restate a given problem and then work it (a graded
solution set), put the verbatim statement in a `question[...]` box and open
your worked answer with `solution`. The question box is a light navy-tinted
panel with a navy left rule and a small `QUESTION` eyebrow -- enough to set
the given task apart from your work without the heavy dark bar of
`exercise()`, which would double up under a numbered "Exercise N" heading.
Pair one per numbered level-1 heading:

```typst
= Outlier detection with the IQR rule
#question[
  Apply the following rule to identify candidate outliers for each variable...
]
#solution[] We take the quantiles with `approxQuantile`, then fold over the
numeric columns adding one flag per variable.
// ... explanation, note boxes, code blocks flow underneath ...
```

`#solution[]` prints just the bold navy "Solution." lead-in before block
content (code, displayed math); `#solution[The radius is 2.]` uses it inline
for a one-line prose answer. See `spark-solution.typ` (`spark-solution.pdf`)
for a full worked example in this style. Keep `exercise(title, body)` (the
dark title bar) for a standalone prompt that has no numbered heading of its
own -- e.g. a discussion question.


## Development history & design notes

The dated design-audit and polish passes, the record of issues found and
fixed (so they aren't reintroduced), and the rationale behind specific design
decisions now live in [`DEVLOG.md`](DEVLOG.md) — kept separate so this guide
stays focused on *using* the templates.
