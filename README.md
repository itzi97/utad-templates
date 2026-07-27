# U-tad templates

[![build examples](https://github.com/itzi97/utad-templates/actions/workflows/build.yml/badge.svg)](https://github.com/itzi97/utad-templates/actions/workflows/build.yml)

Report, assignment, and problem-set templates for **U-tad** coursework, in two
typesetting systems that share one visual identity: a **LaTeX** package and a
**Typst** package. Squared corners, a navy-dominant palette with a single blue
accent, a full-logo cover lockup, and a matching set of components (callout
boxes, code blocks with line numbers, striped tables, and diagrams — evolution
chains, Gantt timelines with dependency arrows, and organigrams).

Three templates are included:

| Template | System | Use it for |
|---|---|---|
| **Report** | LaTeX **and** Typst | Multi-chapter reports (internship, project) — cover + contents page. |
| **Compact assignment** | Typst | Short deliverables (~2–5 pages) — masthead, no cover/contents page. |
| **Solution set** | Typst | Problem sets where you restate the question and box it above your answer. |
| **Slides** | Typst | 16:9 presentation deck — brand-matched title, section, and content slides. |

See `latex/example.pdf` and `typst/example.pdf` (full reports),
`typst/assignment.pdf` (problem set), `typst/spark-solution.pdf`
(question/solution style), and `typst/slides.pdf` (presentation deck) for
what they produce.

## New here? Fastest path (Typst)

If you're just starting and don't already have a LaTeX habit, **use Typst** —
it installs in seconds, compiles in one command, and gives the same result.
Four steps, from a clean machine to your first PDF:

```sh
git clone https://github.com/itzi97/utad-templates.git
cd utad-templates
./scripts/install-fonts.sh        # Poppins + Carlito (Windows: .\scripts\install-fonts.ps1)
./install.sh typst                # makes #import "@local/utad:0.1.0" work anywhere
```

Then copy a starter to wherever you're writing and compile it:

```sh
cp typst/starter-report.typ my-report.typ    # or starter-assignment / starter-slides
typst watch my-report.typ                     # live preview; or: typst compile my-report.typ
```

Open `my-report.typ`, fill in the fields at the top, and write. Every helper
is listed with a one-line example in the starter's comments and in
[`docs/GUIDE.md`](docs/GUIDE.md). Prefer LaTeX? Jump to
[LaTeX report](#latex-report-after-install) below — same idea, `starter.tex`.

> Don't want to install anything system-wide? See [*Manual use*](#manual-use-no-install)
> — copy one language's files into your project folder and use local imports.

## Requirements

- **Fonts:** [Poppins](https://fonts.google.com/specimen/Poppins) (headings) and
  [Carlito](https://fonts.google.com/specimen/Carlito) (body). Both are free
  (OFL). Install them with the included script — no manual downloading:

  ```sh
  ./scripts/install-fonts.sh          # macOS / Linux
  ```
  ```powershell
  .\scripts\install-fonts.ps1         # Windows (current user, no admin)
  ```

  Or install them by hand from Google Fonts if you prefer. On Debian/Ubuntu,
  Carlito is also available as the `fonts-crosextra-carlito` apt package.
  If Typst prints `unknown font family: Poppins` (or `Carlito`), the fonts
  aren't installed yet — run the script above, then recompile.
- **LaTeX:** a TeX distribution (TeX Live or MiKTeX). Compile with **XeLaTeX or
  LuaLaTeX** — the package uses `fontspec` and will not build under `pdflatex`.
- **Typst:** Typst 0.11 or newer.

## Install

Clone the repo, then run the installer for your system.

**macOS / Linux**

```sh
./install.sh          # both Typst and LaTeX
./install.sh typst    # Typst only
./install.sh latex    # LaTeX only
```

**Windows (PowerShell)**

```powershell
.\install.ps1         # both  (use `typst` or `latex` to pick one)
```

The installer puts the Typst files in your local package directory (so you can
`#import "@local/utad:0.1.0"`) and the LaTeX files in your home `texmf` tree (so
`\usepackage{utad}` works from any folder).

> **Prefer not to install system-wide?** You don't have to. Just copy the files
> for one language into your project folder and use relative imports — see
> *Manual use* below.

## Quick start

### Typst report (after install)

```typst
#import "@local/utad:0.1.0": *

#show: utad-doc.with(
  title: [Report Title],
  degree: [Software Engineering w/ AI & Data Science],
  subject: [Subject], year: [4], teacher: [Teacher Name],
  author: "Your Name", date: "Month YYYY",
  short-title: [Short Title],
)

#utad-outline()

= First Chapter
Write your content here.
```

### Typst compact assignment (after install)

```typst
#import "@local/utad:0.1.0": *

#show: assignment.with(
  title: [Problem Set 1], subject: [Subject],
  teacher: [Teacher Name], author: "Your Name",
  date: "Month YYYY", contents: true,
)

= Question 1
Your answer.
```

### Typst slides (after install)

```typst
#import "@local/utad:0.1.0": *

#title-slide(
  title: [Presentation Title], subtitle: [Optional subtitle],
  author: "Your Name", date: "Month YYYY", event: [Course · U-tad],
)

#section-slide[1 · First section]

#slide(title: [A content slide])[
  - point one
  - point two
]

#focus-slide[One big takeaway.]
```

Compile with `typst compile deck.typ` (or `typst watch` for live preview).

### LaTeX report (after install)

```latex
\documentclass[11pt,a4paper]{report}
\usepackage{utad}
\renewcommand{\utadTitle}{Report Title}
\renewcommand{\utadSubject}{Subject}
\setutadauthor{Your Name}
\begin{document}
\utadtitlepage
\utadcontents
\chapter{First Chapter}
Write your content here.
\end{document}
```

Compile with `xelatex file.tex` (run twice for the table of contents).

The `starter.tex`, `starter-report.typ`, `starter-assignment.typ`, and
`starter-slides.typ` files are ready-to-copy skeletons with every field and a
cheat-sheet of helpers in comments.

## Manual use (no install)

Copy the files for one language into your project folder and import locally:

- **Typst:** copy `typst/utad.typ`, `typst/utad-report.typ` (report extras) or
  `typst/utad-assignment.typ` (assignments), plus all `typst/logo-*.svg`, then
  `#import "utad.typ": *` (and `#import "utad-report.typ": *` if needed).
- **LaTeX:** copy `latex/utad.sty` and the `latex/logo-*.pdf` files, then
  `\usepackage{utad}`.

## What's inside

```
utad-templates/
├── install.sh / install.ps1     one-command install (Typst + LaTeX)
├── Makefile                     `make` to rebuild examples; `make check` to sanity-check a build
├── scripts/install-fonts.{sh,ps1}   download + install Poppins & Carlito
├── .github/workflows/build.yml  CI: compiles every example on push
├── README.md                    this file
├── CHANGELOG.md                 version history
├── LICENSE                      MIT
├── docs/GUIDE.md                usage guide + component reference (LaTeX + Typst)
├── docs/DEVLOG.md               development history + design rationale
├── latex/
│   ├── utad.sty                 the LaTeX package
│   ├── starter.tex              copy-to-start skeleton
│   ├── example.tex / .pdf       full worked report
│   └── logo-*.pdf               logo assets (PDF, for LaTeX)
└── typst/
    ├── typst.toml, lib.typ      package manifest + entrypoint (for @local install)
    ├── utad.typ                 base module (cover, headings, callouts, tables)
    ├── utad-report.typ          report extras (weekly log, diagrams, appendices)
    ├── utad-assignment.typ      compact assignment / problem-set format
    ├── utad-slides.typ          16:9 slide theme
    ├── starter-report.typ       copy-to-start report skeleton
    ├── starter-assignment.typ   copy-to-start assignment skeleton
    ├── starter-slides.typ       copy-to-start slide-deck skeleton
    ├── example.typ / .pdf       full worked report
    ├── assignment.typ / .pdf    worked problem set
    ├── spark-solution.typ / .pdf   question/solution style
    ├── slides.typ / .pdf        worked presentation deck (feature tour)
    ├── business-plan.typ / .pdf full pitch deck — a worked example
    └── logo-*.svg               logo assets (SVG, for Typst)
```

## Features (both templates, unless noted)

- Full-logo cover lockup, unified metadata info box, clean front-matter contents.
- **16:9 slide theme** (Typst) matching the report identity: title, section,
  content, and focus slides, with the callout boxes and diagrams reusable on
  slides. Self-contained — no Touying/Polylux dependency.
- Callout boxes: `note`, `callout`, `important`, `exercise`, `question` /
  `solution`, `prompt` / `response`.
- Code blocks with line numbers and syntax highlighting; striped tables.
- Diagrams: evolution / step chains, Gantt timelines with subtle day gridlines
  and finish-to-start **dependency arrows**, and **organigrams**.
- Weekly-log block and hanging-indent reference list (report).

Every helper is documented — LaTeX and Typst side by side — in the
**Component reference** in [`docs/GUIDE.md`](docs/GUIDE.md), which also has
per-language getting-started steps. Design rationale and development history
live in [`docs/DEVLOG.md`](docs/DEVLOG.md); version history is in
[`CHANGELOG.md`](CHANGELOG.md).

## Troubleshooting

The handful of things that trip people up on a first compile:

| Symptom | Cause | Fix |
|---|---|---|
| `unknown font family: Poppins` (or `Carlito`) | Fonts not installed yet | Run `./scripts/install-fonts.sh` (Windows: `.\scripts\install-fonts.ps1`), then recompile. Typst users can also point at the fonts directly: `typst compile --font-path ~/.local/share/fonts file.typ`. |
| LaTeX: `Package fontspec Error: The font "Poppins" cannot be found` or errors about `fontspec`/`unicode` | Compiled with **pdfLaTeX** | Compile with **XeLaTeX** (or LuaLaTeX): `xelatex file.tex`. The package can't build under pdfLaTeX. In Overleaf, set *Menu → Compiler → XeLaTeX*. |
| Typst: `file not found (searched at @local/utad:0.1.0)` | Package not installed | Run `./install.sh typst`, **or** don't install at all — copy the `typst/` files into your folder and use `#import "utad.typ": *` (see *Manual use*). |
| Typst: `file not found (searched at logo-full.svg)` (or another `logo-*.svg`) | Logo assets missing (a fresh clone or a fork without the U-tad marks) | Pass `variant: "none"` (report) or `logo-variant: "none"` (assignment) to build without any logo, or `no-logo-slides()` at the top of a deck. `"text"` uses a plain "U-tad" wordmark. (LaTeX degrades on its own; Typst can't detect a missing file.) |
| Table of contents / page numbers look wrong or empty (LaTeX) | Only compiled once | Run `xelatex` **twice** (the ToC needs a second pass). |
| Header/section references show `??` (LaTeX) | Same — needs a second pass | Compile twice. |
| A date like `Jul 1 - Jul 31` shows a hyphen, not a dash | Plain `-` used | Use a real en-dash `–` in date fields (see the starter comments). |
| Overleaf can't find `\usepackage{utad}` | `utad.sty` not in the project | Upload `latex/utad.sty` **and** the `latex/logo-*.pdf` files into the Overleaf project alongside your `.tex`. |

Still stuck? [`docs/DEVLOG.md`](docs/DEVLOG.md) lists every quirk found (and
fixed) during development, and the green **build examples** badge at the top
means every template compiled on the latest push —
so if the examples build in CI but yours doesn't, the difference is almost
always fonts or the compiler.

## Logo & trademark

The **U-tad** name and logo are trademarks of U-tad (Centro Universitario de
Tecnología y Arte Digital). The logo files in `latex/` and `typst/`
(`logo-*.pdf`, `logo-*.svg`) are the university's property and are bundled here
only so U-tad students can typeset their own coursework. **They are not covered
by the MIT license** below — the license applies to the template *code* only.

If you fork or adapt this project for anything that isn't U-tad coursework,
replace the logo files with your own institution's marks. The templates read
the logos by filename, so you only need to swap the `logo-*` assets (keep the
same names) — see `docs/GUIDE.md` for the logo variants used.

## License

MIT — see [`LICENSE`](LICENSE). Covers the template code, not the U-tad logo
assets (see *Logo & trademark* above).
