# ============================================================
#  U-tad templates — build the worked examples locally.
#
#  Requires: typst, and xelatex (TeX Live / MiKTeX). The templates need the
#  Poppins + Carlito fonts — run `make fonts` once first if you don't have them.
#
#    make            # build all example PDFs (Typst + LaTeX)
#    make typst       # Typst examples only
#    make latex       # LaTeX example only
#    make fonts       # download + install Poppins & Carlito
#    make clean       # remove LaTeX build artifacts
# ============================================================

.PHONY: all typst latex fonts clean

all: typst latex

typst:
	cd typst && typst compile example.typ
	cd typst && typst compile assignment.typ
	cd typst && typst compile spark-solution.typ
	cd typst && typst compile slides.typ
	cd typst && typst compile business-plan.typ

latex:
	cd latex && xelatex -interaction=nonstopmode -halt-on-error example.tex
	cd latex && xelatex -interaction=nonstopmode -halt-on-error example.tex

fonts:
	bash scripts/install-fonts.sh

clean:
	find latex -type f \( -name '*.aux' -o -name '*.log' -o -name '*.out' -o -name '*.toc' \) -delete
