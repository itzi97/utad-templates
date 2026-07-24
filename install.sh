#!/usr/bin/env bash
# ============================================================
#  U-tad templates installer  (macOS / Linux)
#
#  Usage:
#     ./install.sh            # install both Typst and LaTeX
#     ./install.sh typst      # Typst only
#     ./install.sh latex      # LaTeX only
#
#  Typst  -> installs a local package so you can
#              #import "@local/utad:0.1.0": *
#  LaTeX  -> installs into your home texmf tree so you can
#              \usepackage{utad}   (compile with xelatex or lualatex)
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="0.1.0"
TARGET="${1:-all}"

info()  { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
ok()    { printf '\033[1;32m  ok\033[0m %s\n' "$1"; }
warn()  { printf '\033[1;33mwarning:\033[0m %s\n' "$1"; }
fail()  { printf '\033[1;31merror:\033[0m %s\n' "$1" >&2; }

install_typst() {
  info "Installing the Typst package (utad $VERSION)…"
  command -v typst >/dev/null 2>&1 || warn "typst not on PATH — copying files anyway."
  case "$(uname -s)" in
    Darwin) base="$HOME/Library/Application Support/typst/packages/local" ;;
    *)      base="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/local" ;;
  esac
  dest="$base/utad/$VERSION"
  mkdir -p "$dest" || { fail "could not create $dest"; return 1; }
  cp "$SCRIPT_DIR"/typst/utad.typ \
     "$SCRIPT_DIR"/typst/utad-report.typ \
     "$SCRIPT_DIR"/typst/utad-assignment.typ \
     "$SCRIPT_DIR"/typst/utad-slides.typ \
     "$SCRIPT_DIR"/typst/lib.typ \
     "$SCRIPT_DIR"/typst/typst.toml \
     "$dest"/ || { fail "copy failed"; return 1; }
  cp "$SCRIPT_DIR"/typst/logo-*.svg "$dest"/ || { fail "logo copy failed"; return 1; }
  ok "installed to $dest"
  ok 'use it with:  #import "@local/utad:'"$VERSION"'": *'
}

install_latex() {
  info "Installing the LaTeX package (utad)…"
  if ! command -v kpsewhich >/dev/null 2>&1; then
    fail "no TeX installation found (kpsewhich missing). Install TeX Live or MiKTeX first."
    return 1
  fi
  texmf="$(kpsewhich -var-value TEXMFHOME)"
  texmf="${texmf%%:*}"                       # first path if a list
  [ -n "$texmf" ] || texmf="$HOME/texmf"
  dest="$texmf/tex/latex/utad"
  mkdir -p "$dest" || { fail "could not create $dest"; return 1; }
  cp "$SCRIPT_DIR"/latex/utad.sty "$dest"/ || { fail "copy failed"; return 1; }
  cp "$SCRIPT_DIR"/latex/logo-*.pdf "$dest"/ || { fail "logo copy failed"; return 1; }
  if command -v mktexlsr >/dev/null 2>&1; then
    mktexlsr "$texmf" >/dev/null 2>&1 || true
  elif command -v texhash >/dev/null 2>&1; then
    texhash "$texmf" >/dev/null 2>&1 || true
  fi
  ok "installed to $dest"
  ok 'use it with:  \usepackage{utad}   (compile with xelatex or lualatex)'
}

case "$TARGET" in
  typst) install_typst ;;
  latex) install_latex ;;
  all)   install_typst; echo; install_latex ;;
  -h|--help|help)
    sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//' ; exit 0 ;;
  *) fail "unknown target '$TARGET' (use: typst | latex | all)"; exit 1 ;;
esac
