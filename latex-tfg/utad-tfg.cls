%% utad-tfg.cls -- U-tad / UCJC Trabajo de Fin de Grado (BFP)
%%
%% A LaTeX port of the official Word template distributed on Blackboard as
%% "Template - inso.docx" (End-of-Degree Project, 2609_INSG4_TFGR_A).
%%
%% Every measurement below was READ OUT OF THE .docx, not eyeballed:
%%
%%   word/styles.xml   Normal = Times New Roman, 12pt (w:sz 24),
%%                     justified (w:jc both), line 360 auto = 1.5 lines,
%%                     6pt before each paragraph (w:before 120), no
%%                     first-line indent.
%%                     heading 1 = 14pt bold (w:sz 28)
%%                     heading 2/3 = 12pt bold, 10pt before (w:before 200)
%%                     TOC heading = 16pt (w:sz 32)
%%   word/document.xml A4; body section margins 1418 twips top and bottom
%%                     = 2.5 cm, 1701 twips left and right = 3.0 cm.
%%   word/media/       image1.jpg = U-tad logo, image2.png = the
%%                     "Centro adscrito a Universidad Camilo Jose Cela"
%%                     lockup. Both ship alongside this class.
%%
%% DESIGN INTENT: this reproduces the OFFICIAL TEMPLATE, not the utad.sty
%% house identity. A TFG is marked against the template, so it is plain on
%% purpose. The two are separate and are not meant to be combined.
%%
%% FONT: the default build uses newtx (Nimbus Roman), which has Times New
%% Roman's character widths but not its kerning; on the template's own
%% pages that costs one line in one paragraph (measured 22 Sept 2026:
%% newtx and Liberation Serif set the page-11 "Please note" paragraph in
%% 4 lines, real Times New Roman and Word in 5). It needs no system fonts
%% and works on Overleaf. With the real Times New Roman installed, pass
%% [tnr] and compile with XeLaTeX: that build matched Word line for line.
%%
%% Build:  latexmk -pdf main.tex               (default, pdfLaTeX)
%%         latexmk -xelatex main.tex           (with the [tnr] option)
%%
%% Class options:
%%   english (default) | spanish   language for generated names
%%   tnr                           real Times New Roman (XeLaTeX only)
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{utad-tfg}[2026/09/22 v0.3.2 U-tad TFG / BFP template]

\newif\ifutfg@spanish \utfg@spanishfalse
\newif\ifutfg@tnr     \utfg@tnrfalse
\DeclareOption{spanish}{\utfg@spanishtrue}
\DeclareOption{english}{\utfg@spanishfalse}
\DeclareOption{tnr}{\utfg@tnrtrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ExecuteOptions{english}
\ProcessOptions\relax
% 12pt, from w:sz 24 in the docDefaults.
\LoadClass[12pt,a4paper,oneside]{report}

% ------------------------------------------------------------------
%  Fonts
% ------------------------------------------------------------------
\ifutfg@tnr
  \RequirePackage{fontspec}
  \setmainfont{Times New Roman}
  % Times New Roman has no small-caps glyphs, so under fontspec \textsc
  % silently prints lower case -- the modality value and the ABSTRACT /
  % RESUMEN headings lost their caps. Word fakes them as capitals at 80%
  % (9.6pt in the reference render); do the same.
  \renewcommand{\textsc}[1]{{\fontsize{\dimexpr\f@size pt*4/5\relax}{\f@baselineskip}\selectfont\MakeUppercase{#1}}}
\else
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage{newtxtext}
  \RequirePackage{newtxmath}
\fi
% microtype WITHOUT font expansion or protrusion. Expansion squeezes extra
% words onto a line, so the same paragraph came out 4 lines here against
% Word's 5 -- measured on the Conclusions page. Turning it off makes line
% breaking follow Word's; the kerning improvements are kept.
\RequirePackage[expansion=false,protrusion=false]{microtype}
\RequirePackage{etoolbox}
% Word puts a single space after a full stop; TeX defaults to a wider one.
\frenchspacing

% ------------------------------------------------------------------
%  Language
% ------------------------------------------------------------------
\ifutfg@spanish
  \RequirePackage[english,main=spanish]{babel}
\else
  \RequirePackage[spanish,main=english]{babel}
\fi

% ------------------------------------------------------------------
%  Page geometry -- from the body section's w:pgMar.
% ------------------------------------------------------------------
% footskip: the .docx puts the footer's bottom edge 709 twips (1.25cm) above
% the page edge; its one Normal line then has the number's baseline 2.6pt
% descent plus the 6.9pt of 1.5-spacing leading (laid below the text)
% higher: 45pt from the edge, measured identically in LibreOffice's render
% and in a PDF exported by Word itself, so 70.9 - 45 = 25.9pt below the
% text block. 1.25cm put it 9pt too low.
\RequirePackage[a4paper,top=2.5cm,bottom=2.5cm,left=3cm,right=3cm,
  footskip=25.9pt]{geometry}
\RequirePackage{fancyhdr}
\fancypagestyle{utfg}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
  % The template's footer holds a bare PAGE field in a paragraph that
  % inherits Normal's justification, so the number sits on the left
  % margin. Change [L] to [R] if your tutor prefers it on the right --
  % the graded theses in the repository are split between the two.
  \fancyfoot[L]{\normalfont\normalsize\thepage}%
}
\pagestyle{utfg}
\AtBeginDocument{\pagestyle{utfg}}
% report.cls stamps \thispagestyle{plain} on chapter-opening pages, which
% would centre the number there instead of leaving it on the left.
\renewcommand{\ps@plain}{\ps@utfg}

% ------------------------------------------------------------------
%  Body text -- justified, no first-line indent, 6pt before each
%  paragraph, 1.5 line spacing. All four come from the Normal style.
% ------------------------------------------------------------------
\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt plus 1pt minus 0.5pt}
\RequirePackage{setspace}
% Word's "1.5 lines" is 1.5 x the FONT's own line height: Times New Roman
% declares (1825+443+87)/2048 = 1.149 em, so 13.79pt at 12pt and 20.69pt
% per line. Measured 20.75pt in the reference render (page 7, five
% consecutive lines). setspace's \onehalfspacing only reaches ~18pt at this
% size; 1.45 gave 21.0pt, which drifted 0.3pt per line. 1.427 x 14.5pt =
% 20.69pt.
\setstretch{1.427}

% ------------------------------------------------------------------
%  Core packages
% ------------------------------------------------------------------
\RequirePackage{graphicx}
% largestsep: when a section follows a chapter, take the larger of the
% chapter's after-space and the section's before-space rather than the
% chapter's alone. Word gives heading 2 its 10pt "before" there too.
\RequirePackage[largestsep]{titlesec}
\RequirePackage{tocloft}
\RequirePackage{enumitem}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{caption}
\RequirePackage{float}
\RequirePackage{xurl}
\RequirePackage{csquotes}
\RequirePackage[hidelinks]{hyperref}

% ------------------------------------------------------------------
%  Headings
%
%  The template's top level is typed in capitals ("1. INTRODUCTION") at
%  14pt bold, while the same entry in the index is sentence case
%  ("1. Introduction"). \MakeUppercase in the before-code argument gives
%  exactly that split: the heading is uppercased, the contents entry is
%  left alone.
%
%  secnumdepth 5 because graded theses go as deep as 4.1.3.2.1.
%  tocdepth 2 lists 1, 1.1 and 1.1.1; the template's own index stops at
%  1.1, so set it to 1 for a literal match.
% ------------------------------------------------------------------
\setcounter{secnumdepth}{5}
\setcounter{tocdepth}{2}

\titleformat{\chapter}[block]
  {\normalfont\fontsize{14}{17}\selectfont\bfseries}
  {\thechapter.}{0.4em}{\MakeUppercase}
% Heading 1 has no after-space in the .docx; the 6pt to the next paragraph
% is that paragraph's own \parskip. 4pt here put every first line 4pt low.
\titlespacing*{\chapter}{0pt}{-28pt}{0pt}

% Headings 2-3 carry 10pt before in the .docx against Normal's 6pt, so the
% extra is 4pt on top of \parskip. (The earlier 3pt was fitted to
% pdfplumber 'top' values, which sit 2.6pt high on TeXGyreTermesX-Bold
% lines because that font declares more ascent than the regular; measured
% by glyph baseline the gap is 4pt.)
\titleformat{\section}[block]{\normalfont\normalsize\bfseries}{\thesection}{0.4em}{}
\titlespacing*{\section}{0pt}{4pt}{0pt}
\titleformat{\subsection}[block]{\normalfont\normalsize\bfseries}{\thesubsection}{0.4em}{}
\titlespacing*{\subsection}{0pt}{4pt}{0pt}
\titleformat{\subsubsection}[block]{\normalfont\normalsize\bfseries}{\thesubsubsection}{0.4em}{}
\titlespacing*{\subsubsection}{0pt}{4pt}{0pt}
% Headings 4 and 5 are heading 3 plus italic in styles.xml (Ttulo4 basedOn
% Ttulo3 adds w:i; Ttulo5 basedOn Ttulo4), so bold italic, same spacing.
% Their 2cm / 2.5cm first-line indents are not copied, like heading 3's.
\titleformat{\paragraph}[block]{\normalfont\normalsize\bfseries\itshape}{\theparagraph}{0.4em}{}
\titlespacing*{\paragraph}{0pt}{4pt}{0pt}
\titleformat{\subparagraph}[block]{\normalfont\normalsize\bfseries\itshape}{\thesubparagraph}{0.4em}{}
\titlespacing*{\subparagraph}{0pt}{4pt}{0pt}

% Unnumbered top-level division that still looks like a chapter title and
% still reaches the contents: Acknowledgements, Glossary, Appendix.
% #1 optional: "toc" to list it in the index, "notoc" to leave it out.
% #2 optional: font size in pt. Measured off the reference PDF --
% Acknowledgements is 12pt bold and absent from the index; Glossary and
% Appendix are 14pt bold and present.
\newcommand{\utfgunnumbered}[3][toc]{%
  \clearpage
  {\normalfont\fontsize{#2}{\the\numexpr#2*12/10\relax}\selectfont\bfseries #3\par}%
  \vspace{2pt}%
  \ifstrequal{#1}{toc}{\addcontentsline{toc}{chapter}{#3}}{}%
  \markboth{#3}{#3}%
}

% ------------------------------------------------------------------
%  Contents and image index
% ------------------------------------------------------------------
\renewcommand{\cftchapfont}{\normalfont}
\renewcommand{\cftchappagefont}{\normalfont}
% The template's index reads "1. Introduction" -- number, period, title --
% flush on the left margin, with sections indented a little under it.
% tocloft's defaults give "1   Introduction" with a wide number column.
\renewcommand{\cftchapaftersnum}{.}
% Word's entries are plain text, "1.1 Justification", number, one space,
% title, and a wrapped title continues under the number, not under the
% title. tocloft boxes the number to \cft...numwidth and hangs the rest,
% so the number is set unboxed here and the widths are zero.
\renewcommand{\numberline}[1]{\@cftbsnum #1\@cftasnum\ \@cftasnumb}
\setlength{\cftchapindent}{0pt}
\setlength{\cftchapnumwidth}{0pt}
\setlength{\cftsecindent}{12pt}      % TDC2 w:ind left 240 twips
\setlength{\cftsecnumwidth}{0pt}
\setlength{\cftsubsecindent}{24pt}
\setlength{\cftsubsecnumwidth}{0pt}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftchapdotsep}{\cftdotsep}
% Word's dot leader is a run of periods, 3pt apart at 12pt (123 on the
% Glossary line); tocloft's default 4.5mu each side gave 9pt.
\renewcommand{\cftdotsep}{0}
% Entry pitch is uniform, 26.7pt at every level, in both the reference
% render and Word's own PDF: Word takes the larger of TDC1/TDC2's 5pt
% after and the next entry's 6pt before, not the sum.
\setlength{\cftbeforechapskip}{0pt}
% Word's right tab for the page number sits at 8488 twips, 16 twips inside
% the text width, and the title may run up to it; tocloft's default 2.55em
% right margin wrapped the 2.1 entry a word early.
\cftsetrmarg{1.55em}
\renewcommand{\cfttoctitlefont}{\normalfont\fontsize{16}{19}\selectfont\bfseries}
\renewcommand{\cftloftitlefont}{\normalfont\fontsize{16}{19}\selectfont\bfseries}
\renewcommand{\cftaftertoctitle}{\par\vspace{8pt}}
\renewcommand{\cftafterloftitle}{\par\vspace{8pt}}

% babel reinstalls its own names at \begin{document} and again after every
% language switch (biblatex switches for each foreign-language entry, and
% the table index follows the bibliography), so they go into babel's own
% caption hook, not a one-off \AtBeginDocument. With the one-off, the
% table index of the [spanish] test build still said "Cuadro".
\ifutfg@spanish
  % babel-spanish calls a table "Cuadro"; the graded theses say "Tabla".
  \addto\captionsspanish{%
    \renewcommand{\contentsname}{\'Indice}%
    \renewcommand{\listfigurename}{\'Indice de im\'agenes}%
    \renewcommand{\listtablename}{\'Indice de tablas}%
    \renewcommand{\tablename}{Tabla}}
  \newcommand{\utfg@glossaryname}{Glosario}
  \newcommand{\utfg@appendixname}{Anexos}
  \newcommand{\utfg@ackname}{Agradecimientos}
  \newcommand{\utfg@keywordsname}{Palabras clave}
  \newcommand{\utfg@abstractname}{Resumen}
  \newcommand{\utfg@altabstractname}{Abstract}
  \newcommand{\utfg@altkeywordsname}{Keywords}
  \newcommand{\utfg@l@modality}{Modalidad del TFG}
  \newcommand{\utfg@l@call}{Convocatoria}
  \newcommand{\utfg@l@student}{Alumno / a}
  \newcommand{\utfg@l@tutor}{Tutor / a}
  \newcommand{\utfg@l@cotutor}{Cotutor / a}
  \newcommand{\utfg@l@degree}{Grado}
\else
  \addto\captionsenglish{%
    \renewcommand{\contentsname}{Index}%
    \renewcommand{\listfigurename}{Image index}%
    \renewcommand{\listtablename}{Table index}}
  \newcommand{\utfg@glossaryname}{Glossary}
  \newcommand{\utfg@appendixname}{Appendix}
  \newcommand{\utfg@ackname}{Acknowledgements}
  \newcommand{\utfg@keywordsname}{Keywords}
  \newcommand{\utfg@abstractname}{Abstract}
  \newcommand{\utfg@altabstractname}{Resumen}
  \newcommand{\utfg@altkeywordsname}{Palabras clave}
  \newcommand{\utfg@l@modality}{BFP modality}
  \newcommand{\utfg@l@call}{Call}
  \newcommand{\utfg@l@student}{Student}
  \newcommand{\utfg@l@tutor}{Tutor}
  \newcommand{\utfg@l@cotutor}{Co-tutor}
  \newcommand{\utfg@l@degree}{Degree}
\fi

% ------------------------------------------------------------------
%  Figures and tables -- numbered continuously (Figure 1, Figure 2),
%  not per chapter, which is how the template's image index runs.
% ------------------------------------------------------------------
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
% Caption style in styles.xml: 9pt italic throughout, single line spacing
% (w:line 240), 6pt before (Normal), 10pt after. Measured in the reference
% render and in Word's own PDF, page 8: image bottom to caption baseline
% 21pt, caption baseline to the next text baseline 23pt (Word takes the
% larger of the caption's 10pt after and the next paragraph's 6pt before,
% not their sum). TeX puts a full 20.7pt \baselineskip between the float
% box's bottom and the next line, so a negative skip under the caption is
% what brings it down; with 0 it was 35pt after a [H] figure. LaTeX drops
% the \parskip after an [h] float but not after the float package's [H],
% so one value cannot fit both: -9.5pt measures 28pt after [H] and 22pt
% after [h].
\DeclareCaptionFont{utfgcap}{\fontsize{9}{10.3}\selectfont\itshape}
\captionsetup{
  font=utfgcap, labelsep=period, justification=justified,
  singlelinecheck=false, skip=13pt
}
\setlength{\belowcaptionskip}{-9.5pt}
% Above a figure Word has the previous line's leading plus 6pt: 17pt from
% a heading baseline to the image top on page 8. A [H] float adds
% \intextsep and \parskip to the line's depth; 12pt gave 22.5.
\setlength{\intextsep}{7pt}
% Image index entries read "Figure 2. caption", as Word lists the whole
% caption paragraph.
\renewcommand{\cftfigpresnum}{\figurename~}
\renewcommand{\cftfigaftersnum}{.}
\setlength{\cftfignumwidth}{0pt}
\setlength{\cftfigindent}{0pt}
\renewcommand{\cfttabpresnum}{\tablename~}
\renewcommand{\cfttabaftersnum}{.}
\setlength{\cfttabnumwidth}{0pt}
\setlength{\cfttabindent}{0pt}
\newcommand{\source}[1]{%
  \ifutfg@spanish Fuente: #1.\else Source: #1.\fi}

% ------------------------------------------------------------------
%  Cover
%
%  From the template's own first page: one row with the U-tad logo left
%  and the UCJC "Centro adscrito a" lockup right, a deep gap, the title
%  centred in bold, the modality line centred with a bold label and a
%  small-caps value, then a left block of justified lines with bold
%  labels and plain values.
%
%  Both logos are ANCHORED pictures (wp:anchor, not inline) hung off the
%  cover's first paragraph: U-tad at 8890 EMU (0.7pt) from the column's
%  left edge, UCJC at 4249950 EMU = 11.805cm. With its 3.66cm width the
%  UCJC mark ends at 15.46cm, 0.82cm past the 14.64cm column: it
%  overhangs the right margin in Word too, and stays 2.4cm inside the
%  paper edge. (LibreOffice paints it 4.43cm wide because it ignores the
%  srcRect crop; that is the only part of its render not to trust.)
%  The lower block of labelled rows is a floating text box (wps, 14.92cm
%  wide at the left margin, insets 0.254cm), so its text starts 7.2pt in
%  from the margin.
% ------------------------------------------------------------------
\newcommand{\utfg@title}{Title}
\newcommand{\utfg@modality}{Conventional or linked to projects}
\newcommand{\utfg@degree}{Degree and specialization}
\newcommand{\utfg@call}{}
\newcommand{\utfg@student}{}
\newcommand{\utfg@tutor}{}
\newcommand{\utfg@cotutor}{}
\newcommand{\tfgtitle}[1]{\renewcommand{\utfg@title}{#1}}
\newcommand{\tfgmodality}[1]{\renewcommand{\utfg@modality}{#1}}
\newcommand{\tfgdegree}[1]{\renewcommand{\utfg@degree}{#1}}
\newcommand{\tfgcall}[1]{\renewcommand{\utfg@call}{#1}}
\newcommand{\tfgstudent}[1]{\renewcommand{\utfg@student}{#1}}
\newcommand{\tfgtutor}[1]{\renewcommand{\utfg@tutor}{#1}}
\newcommand{\tfgcotutor}[1]{\renewcommand{\utfg@cotutor}{#1}}

% Logo files, shipped next to this class. Any of the three extensions is
% accepted, so a vector PDF can be swapped in without editing anything.
\newcommand{\utfg@logo}[3]{%
  \IfFileExists{#1.pdf}{\includegraphics[width=#2]{#1.pdf}}{%
   \IfFileExists{#1.png}{\includegraphics[width=#2]{#1.png}}{%
    \IfFileExists{#1.jpg}{\includegraphics[width=#2]{#1.jpg}}{%
     \fbox{\parbox[c][1.7cm][c]{#2}{\centering\scriptsize\itshape #3}}}}}%
}

% Cover rows: bold capitalised label, then the value. The modality line is
% one run of the "Book Title" character style (bold, smallCaps) -- label
% and value both bold, the lower-case value showing as small capitals --
% while the five rows below are typed in capitals, value in regular weight.
\newcommand{\utfg@row}[2]{\textbf{\MakeUppercase{#1}:}\ #2}
\newcommand{\utfg@scrow}[2]{\textbf{\MakeUppercase{#1}:\ \textsc{#2}}}

\newcommand{\tfgcover}{%
  \begin{titlepage}
  % The .docx gives the cover its own section with margins 1440 twips top
  % and bottom (2.54 cm) and 1800 twips left and right (3.17 cm) -- wider
  % than the body section's 2.5 / 3.0. Without this the whole cover sat
  % 3px high and 10px left of the reference rendering.
  \newgeometry{top=2.54cm,bottom=2.54cm,left=3.17cm,right=3.17cm}
  \thispagestyle{empty}
  \setlength{\parskip}{0pt}
  % NOT \singlespacing: the cover's paragraphs are Normal in the .docx, so
  % they carry the same 1.5 leading as the body. With single spacing the
  % five metadata rows came out 23px apart against the reference's 30px.
  % Bottoms aligned: the anchors put the UCJC top 0.25cm below the U-tad
  % top and it is 0.21cm shorter. \makebox[0pt] because the UCJC mark ends
  % past the text width (see above) and must not report an overfull line.
  \noindent\utfg@logo{logo-utad}{3.08cm}{U-tad}%
  \hspace*{\dimexpr11.805cm-3.08cm\relax}%
  \makebox[0pt][l]{\utfg@logo{logo-ucjc}{3.66cm}{Universidad Camilo Jos\'e Cela}}

  \vspace{6.53cm}

  \begin{center}
    {\bfseries\MakeUppercase{\utfg@title}}

    \vspace{1.15cm}

    \utfg@scrow{\utfg@l@modality}{\utfg@modality}
  \end{center}

  \vspace{4.91cm}

  % The text box: 14.92cm wide at the left margin, insets 0.254cm left and
  % right and 0.127cm top. Its text edge is 0.006cm past the text width;
  % the box is cut to the text width here rather than report that.
  \vspace{0.127cm}
  \noindent\hspace*{0.254cm}\begin{minipage}[t]{\dimexpr\textwidth-0.254cm\relax}
  \setlength{\parskip}{6pt}
  % Word does not hyphenate by default, and the template's CALL line breaks
  % at a space. Without this, "ACADEMIC" was split across the two lines.
  % Word also justifies that first line however wide the gaps get; with
  % TeX's default tolerance the break was infeasible and ACADEMIC ran 26pt
  % into the margin, and with [spanish] the longer CONVOCATORIA label was
  % left alone on its line until the emergency pass was allowed.
  \hyphenpenalty=10000 \exhyphenpenalty=10000 \tolerance=9999 \emergencystretch=3cm
  \utfg@row{\utfg@l@call}{\utfg@call}\par
  \utfg@row{\utfg@l@student}{\utfg@student}\par
  \utfg@row{\utfg@l@tutor}{\utfg@tutor}\par
  % \ifdefempty, not \ifx against \@empty: \newcommand makes the macro
  % \long and \@empty is not, so \ifx reports them different even when
  % both are empty -- which printed a stray "Co-tutor:" with no value.
  \ifdefempty{\utfg@cotutor}{}{\utfg@row{\utfg@l@cotutor}{\utfg@cotutor}\par}%
  \utfg@row{\utfg@l@degree}{\utfg@degree}\par
  \end{minipage}

  \vspace{2cm}
  \end{titlepage}
  % After \end{titlepage}, not before: inside it the restored text height
  % reached page 2 one page late and its footer sat 2.3pt high (the two
  % 0.04cm margin differences).
  \restoregeometry
  \setcounter{page}{2}
}

% ------------------------------------------------------------------
%  Front matter blocks
% ------------------------------------------------------------------
\newenvironment{tfgacknowledgements}
  {\utfgunnumbered[notoc]{12}{\utfg@ackname}}
  {\clearpage}

% ABSTRACT and RESUMEN are set bold small caps in the template, both on
% one page, each followed by four or five keywords.
% Both headings are plain Normal paragraphs in the .docx (no heading style,
% no extra space), and one EMPTY Normal paragraph separates the Keywords
% line from RESUMEN: a full line plus its 6pt before, 26.7pt. A 12pt skip
% here left RESUMEN 13pt high.
\newcommand{\utfg@abshead}[1]{%
  \addcontentsline{toc}{chapter}{\texorpdfstring{\bfseries\textsc{#1}}{#1}}%
  \par{\normalfont\normalsize\bfseries\textsc{#1}\par}}
\newcommand{\tfgabstract}[2]{%
  \utfg@abshead{\utfg@abstractname}#1\par
  \textbf{\utfg@keywordsname:} #2\par\vspace{\dimexpr\baselineskip+\parskip}}
\newcommand{\tfgaltabstract}[2]{%
  \utfg@abshead{\utfg@altabstractname}#1\par
  \textbf{\utfg@altkeywordsname:} #2\par\vspace{\dimexpr\baselineskip+\parskip}}
\newenvironment{tfgabstractpage}{\clearpage}{\clearpage}

% The template's own glossary is running prose, not a definition list.
\newenvironment{tfgglossary}
  {\utfgunnumbered{14}{\utfg@glossaryname}}
  {\clearpage}
% ...but a definition list is what you will actually want once you have
% terms to define, so it is here as an opt-in environment.
\newenvironment{tfgglosslist}
  {\begin{description}[style=nextline,leftmargin=1.2cm,labelsep=0.4em,
     itemsep=4pt,parsep=0pt]}
  {\end{description}}
\newcommand{\gloss}[1]{\item[\normalfont\bfseries #1]}

\newenvironment{tfgappendix}
  {\utfgunnumbered{14}{\utfg@appendixname}}
  {\clearpage}

% \tfgindex -- the index, WITHOUT the page break that \tableofcontents
% forces. In the template the "Index" heading (16pt bold, measured) follows
% the style note on the same page, so a \chapter*-based contents page puts
% it on a page of its own and shifts the whole document by one.
% No hyphenation: Word does not hyphenate, and the wrapped 2.1 entry has
% to break at the same word.
% -5pt: the reference render has 25pt from the Index baseline to the first
% entry's; with +2pt it was 34pt.
\newcommand{\tfgindex}{%
  \par\vspace{6pt}%
  {\normalfont\fontsize{16}{19}\selectfont\bfseries\contentsname\par}%
  \vspace{-5pt}%
  \begingroup\hyphenpenalty=10000 \exhyphenpenalty=10000
  \@starttoc{toc}\endgroup
}

% The template puts the figure list under section 6.2 "Image index", not
% in the front matter, and with no heading of its own (the \section
% supplies it). \@starttoc emits just the list. The table list is the same
% thing for tables; the template has none, the graded theses do.
\newcommand{\tfgimageindex}{\par\begingroup\hyphenpenalty=10000
  \exhyphenpenalty=10000 \@starttoc{lof}\endgroup}
\newcommand{\tfgtableindex}{\par\begingroup\hyphenpenalty=10000
  \exhyphenpenalty=10000 \@starttoc{lot}\endgroup}

% Long quotations: the template's "Quote" style (Cita) is 11pt, indented
% 709 twips (1.25cm) on both sides with a 720 twip (1.27cm) first-line
% indent, upright, otherwise Normal.
\newenvironment{tfgquote}
  {\par\begingroup\fontsize{11}{13.3}\selectfont
   \setlength{\leftskip}{1.25cm}\setlength{\rightskip}{1.25cm}%
   \setlength{\parindent}{1.27cm}\ignorespaces}
  {\par\endgroup}

% Hanging-indent reference list, for when you would rather not run biber.
\newenvironment{tfgrefs}
  {\begin{list}{}{\setlength{\leftmargin}{1.2cm}%
     \setlength{\itemindent}{-1.2cm}\setlength{\itemsep}{6pt}%
     \setlength{\parsep}{0pt}}}
  {\end{list}}
\newcommand{\refitem}{\item}

\endinput
