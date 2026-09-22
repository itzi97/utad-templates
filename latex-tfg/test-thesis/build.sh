#!/bin/sh
# Builds the stress test twice, thesis-en.pdf and thesis-es.pdf, from
# scratch. The class and logos are picked up from the parent directory.
set -e
cd "$(dirname "$0")"
export TEXINPUTS="..:${TEXINPUTS}"
rm -f thesis-e[ns].*
for lang in english spanish; do
  case $lang in english) job=thesis-en;; spanish) job=thesis-es;; esac
  latexmk -pdf -interaction=nonstopmode -usepretex -pretex="\\def\\tfglang{$lang}" -jobname=$job thesis.tex
done
python3 check.py thesis-en; python3 check.py thesis-es
