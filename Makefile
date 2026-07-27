# ============================================================
#  U-tad templates — build the worked examples locally.
#
#  Requires: typst, and xelatex (TeX Live / MiKTeX). The templates need the
#  Poppins + Carlito fonts — run `make fonts` once first if you don't have them.
#
#    make            # build all example PDFs (Typst + LaTeX)
#    make typst       # Typst examples only
#    make latex       # LaTeX example only
#    make check       # build + report pages / undefined refs / overfull boxes
#    make fonts       # download + install Poppins & Carlito
#    make clean       # remove LaTeX build artifacts
#
#  `make check` is the pre-commit sanity pass: it rebuilds both languages and
#  flags the things that fail silently -- an example that lost pages, an
#  undefined \ref/\cite, or a box spilling past the margin. Tune the overfull
#  threshold with `make check OVERFULL=5.0` (points; default 2.0).
# ============================================================

.PHONY: all typst latex check fonts clean

# Overfull \hbox warnings smaller than this many points are ignored as noise.
OVERFULL ?= 2.0

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

check:
	@echo "== LaTeX =="
	@cd latex && xelatex -interaction=nonstopmode example.tex >/dev/null 2>&1; \
	  xelatex -interaction=nonstopmode example.tex > _check.log 2>&1; \
	  printf '  example.pdf: %s pages\n' "$$(pdfinfo example.pdf 2>/dev/null | awk '/^Pages:/{print $$2}')"; \
	  u=$$(grep -Ec 'Reference .* undefined|Citation .* undefined|There were undefined references' _check.log); \
	  printf '  undefined references: %s\n' "$$u"; \
	  grep -E 'Overfull \\hbox' _check.log \
	    | sed -E 's/.*Overfull \\hbox \(([0-9.]+)pt too wide\).*/\1/' \
	    | awk -v t=$(OVERFULL) '$$1+0 > t {n++} END {printf "  overfull hboxes > %spt: %d\n", t, n+0}'; \
	  rm -f _check.log
	@echo "== Typst =="
	@cd typst && for f in example assignment spark-solution slides business-plan; do \
	  typst compile $$f.typ > /dev/null 2> _check.log; \
	  printf '  %-20s %s pages, %s warnings\n' "$$f.pdf:" \
	    "$$(pdfinfo $$f.pdf 2>/dev/null | awk '/^Pages:/{print $$2}')" \
	    "$$(grep -c 'warning:' _check.log)"; \
	  done; rm -f typst/_check.log

fonts:
	bash scripts/install-fonts.sh

clean:
	find latex -type f \( -name '*.aux' -o -name '*.log' -o -name '*.out' -o -name '*.toc' \) -delete
