# utad-tfg — the U-tad / UCJC TFG template, in LaTeX

A port of the official Word template distributed on Blackboard as
`Template - inso.docx` (End-of-Degree Project, 2609_INSG4_TFGR_A).

This is **separate from `utad.sty`** and not meant to be combined with it.
`utad.sty` is the branded coursework identity (Poppins/Carlito, navy and
blue, custom cover). A TFG is marked against the template, so this class
is deliberately plain: Times, black, no branding beyond the two cover logos.

## Files

| File | What it is |
|---|---|
| `utad-tfg.cls` | the class |
| `main.tex` | copy-to-start skeleton, also the demo |
| `refs.bib` | demo bibliography |
| `logo-utad.png`, `logo-ucjc.png` | logos lifted from the .docx, cropped to their ink |
| `tools/measure.py`, `tools/lines.py` | the line-position diff against a LibreOffice render of the .docx |
| `test-thesis/` | 67-page filler stress test, `./build.sh` builds it in both languages |

## Build

```sh
latexmk -pdf main.tex          # pdfLaTeX + biber, no system fonts needed
latexmk -xelatex main.tex      # only if you pass the [tnr] class option
```

Overleaf: upload all of the above, leave the compiler on pdfLaTeX.

## Everything is measured, not guessed

The values in the class were read out of the `.docx` XML, and the output
was then diffed against a rendering of the Word file page by page:

* `word/styles.xml` — Normal is **Times New Roman 12pt**, justified, line
  `360 auto` = **1.5 lines**, **6pt before** each paragraph, no first-line
  indent. Heading 1 is **14pt bold**; headings 2–3 are 12pt bold with 10pt
  before; the TOC heading is 16pt.
* `word/document.xml` — A4. The **cover** section has 2.54cm top/bottom and
  3.17cm left/right margins; the **body** section has 2.5cm and 3.0cm. The
  class switches geometry for the title page accordingly.
* Logo display sizes come from `wp:extent`: U-tad **3.08 × 1.43 cm**, UCJC
  **3.66 × 1.22 cm**. Both images carry a `srcRect` crop in Word; the
  shipped PNGs are trimmed to the same region (within 1.4%).

Heading sizes were read off the rendered template with `pdfplumber`:
chapter 14pt bold, section 12pt bold, Index 16pt bold, Glossary and
Appendix 14pt bold, **Acknowledgements 12pt bold**, ABSTRACT/RESUMEN 12pt
bold small caps. Figures are **14.99 × 12.70 cm** — full text width.
Captions are 9pt italic, single-spaced. The cover's lower block is a
floating text box with 0.254cm insets, so its text starts 7.2pt in from
the margin; both logos are anchored pictures, the UCJC one placed at
11.805cm from the column's left edge, which puts its right edge 0.82cm
past the text width (and 2.4cm inside the paper edge).

## How close it actually is

`main.tex` reproduces the template **page for page**: 14 pages, the same
content on each. Mean vertical deviation of every text line, measured
against a rendering of the .docx:

| Page | Mean \|Δ\| | Max \|Δ\| | lines |
|---|---|---|---|
| 1 Cover | 1.3 pt | 2 pt | 8 |
| 2 Acknowledgements | 1.5 pt | 2 pt | 2 |
| 4 Index (cont.) | 1.0 pt | 1 pt | 1 |
| 6 Introduction | 0.6 pt | 1 pt | 14 |
| 7 State of the art | 0.9 pt | 2 pt | 12 |
| 11 Conclusions | 2.6 pt | 9 pt | 17 |
| 13 Glossary | 1.1 pt | 2 pt | 7 |
| 14 Appendix | 1.0 pt | 1 pt | 5 |

Measured 22 Sept 2026 by glyph baseline (`tools/measure.py --baseline`)
against a LibreOffice render of the .docx; a PDF exported by Word for
the web the same day agrees with that render to 0.4 pt mean over the same
67 lines, and the class measures 1.5 pt against it (1.1 pt on the index
page, 0.25 pt on the abstract page, footer and cover logos within 1 pt).
Across those eight pages — the ones whose content is identical in both —
**mean deviation is 1.4 pt over 66 text lines** (1.8 pt when measured by
pdfplumber's `top` instead, which sits 2.6pt high on every bold line of
the LaTeX build because TeXGyreTermesX-Bold declares more ascent than the
regular face). The other six pages differ because their content
deliberately differs (a real bibliography, a LaTeX note in place of the
Word-styles one, figure placeholders instead of images). The footer page
number lands on the reference's baseline to within 1pt.

On the cover, every line lands within 2 pt, including the CALL line
wrapping onto a second line at the same word.

Findings from that diff, all fixed here:

* `\onehalfspacing` is *not* Word's "1.5 lines" — it gives ~18pt at 12pt
  where Word gives 20.69pt (1.5 × Times New Roman's 1.149em line height).
  The class uses `\setstretch{1.427}`; 1.45 drifted 0.3pt per line.
* Section before-space cannot be set to Word's literal 10pt, because
  LaTeX's `\parskip` is added on top of it. 4pt reproduces the gap.
  Heading 1 has no after-space at all; the 6pt below it is `\parskip`.
* **microtype's font expansion** squeezed an extra word onto each line, so
  a five-line paragraph came out in four. Expansion and protrusion are
  disabled; the kerning improvements are kept.
* The Acknowledgements heading is 12pt, not 14pt like Glossary and
  Appendix, and it is **not** listed in the index.
* One empty paragraph separates the Keywords line from RESUMEN (26.7pt,
  not 12pt).
* The footer sits 1.25cm from the page edge *at its bottom*; the number's
  baseline is 45pt up. `footskip` is 25.9pt, not 1.25cm.

The residual on the Conclusions page is one line: newtx sets the "Please
note…" paragraph in four lines where Word needs five. It is the font's
kerning, not TeX's breaker — Liberation Serif (same widths, its own kerns)
also gives four, the real Times New Roman under XeLaTeX (`[tnr]`) gives
five, and that build measures 1.28 pt on the page and 1.04 pt over all 67
lines of the eight pages (measured on Fedora, TeX Live 2026, with the
Microsoft core-fonts Times v2.82). It does not change pagination.

## Font

The default build uses **newtx (Nimbus Roman)**, which has Times New
Roman's character widths but its own kerning, so lines break where Word
breaks them *almost* everywhere (one paragraph in the 14-page template
loses a line), and no font has to be installed. With the real Times New
Roman installed, `[tnr]` under XeLaTeX matched Word line for line on every
template page. Times New Roman has no small-caps glyphs, so on that path
the class fakes them as 80% capitals, which is what Word does.

Fedora: `dnf install cabextract`, then `curl -LO
https://downloads.sourceforge.net/corefonts/times32.exe && cabextract -d
~/.local/share/fonts/msttcorefonts -F '*.ttf' times32.exe && fc-cache -f`.
The class also needs `texlive-biblatex-apa`, `texlive-biber` and
`texlive-newtx` there (the stress test adds `texlive-lipsum` and
`texlive-kantlipsum`).

## Options

```latex
\documentclass[english]{utad-tfg}   % or [spanish] — switches Index /
                                    % Image index / Glossary / Appendix /
                                    % Keywords to the Spanish names
\documentclass[spanish,tnr]{utad-tfg}
```

## Deliberate deviations from the template

* The logos are placed where the `.docx` anchors them, and the UCJC
  mark overhangs the right margin by 0.82cm there too (it stays 2.4cm
  inside the paper). LibreOffice additionally paints both marks at their
  **uncropped** sizes (4.92 and 4.43 cm against the 3.08 and 3.66 cm in
  the XML) because it ignores the `srcRect` crop; the shipped PNGs are cut
  to Word's exact `srcRect`, not auto-trimmed.
* The template's stray empty paragraphs before "3.2", "4. DEVELOPMENT" and
  "6. REFERENCES" are not copied (see below for the first one).
* The index entries in the `.docx` carry the theme's minor font (Cambria)
  in their run properties, an artefact of Word's TOC field; Word's own
  PDF shows it only affects the tab characters — the visible entries are
  Times New Roman there too.
* The template's index stops at `1.1`; `tocdepth` is 2 here, which also
  lists `1.1.1`, as the graded theses do. Set it to 1 for a literal match.
* The image index is called in the front matter in `main.tex`; the template
  places it as §6.2 after the bibliography. Move the `\listoffigures` call
  if you want that.
* `secnumdepth` is 5 — graded theses go as deep as `4.1.3.2.1`.
* The template has a **stray blank paragraph** before "4. DEVELOPMENT", so
  that one chapter heading starts 28pt lower than every other. Not copied.
* The template's page-3 note explains Word's style gallery, which is
  meaningless here; it is replaced with the LaTeX equivalent.
* Chapter 3 in the template **skips 3.1** and labels its only section 3.2;
  its own index repeats the error. `main.tex` reproduces it with an
  explicit `\setcounter` you can delete.

## Commands

```latex
\tfgtitle{} \tfgmodality{} \tfgdegree{} \tfgcall{} \tfgstudent{}
\tfgtutor{} \tfgcotutor{}        % leave co-tutor empty and its line vanishes
\tfgcover

\begin{tfgacknowledgements} ... \end{tfgacknowledgements}
\begin{tfgabstractpage}
  \tfgabstract{text}{keywords}
  \tfgaltabstract{text}{keywords}
\end{tfgabstractpage}

\source{Author (2026)}            % the "Source: ..." caption tail
\tfgimageindex \tfgtableindex     % the lists, under your own \section
\begin{tfgquote} ... \end{tfgquote}  % the template's Quote style, 11pt
\begin{tfgglossary} \begin{tfgglosslist} \gloss{Term} definition
  \end{tfgglosslist} \end{tfgglossary}
\begin{tfgappendix} ... \end{tfgappendix}
\begin{tfgrefs} \refitem ... \end{tfgrefs}   % if you'd rather not run biber
```

## Logos

`logo-utad.png` and `logo-ucjc.png` are U-tad's and UCJC's trademarks,
extracted from the template U-tad distributes to its own students. They are
here so you can typeset your own TFG; they are not yours to relicense. Drop
in a vector `logo-utad.pdf` / `logo-ucjc.pdf` and the class prefers it.
