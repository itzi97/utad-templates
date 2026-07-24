#!/usr/bin/env bash
# ============================================================
#  Install the template fonts (macOS / Linux)
#
#  The templates set headings in Poppins and body text in Carlito. This
#  script downloads both (regular + the weights the templates use) from the
#  Google Fonts repository and installs them into your user font directory,
#  then refreshes the font cache. Both fonts are free/open (OFL).
#
#  Usage:  ./scripts/install-fonts.sh
# ============================================================
set -uo pipefail

BASE="https://raw.githubusercontent.com/google/fonts/main/ofl"
POPPINS=(Poppins-Regular Poppins-Italic Poppins-Medium Poppins-MediumItalic \
         Poppins-SemiBold Poppins-Bold Poppins-BoldItalic)
CARLITO=(Carlito-Regular Carlito-Italic Carlito-Bold Carlito-BoldItalic)

case "$(uname -s)" in
  Darwin) FONTDIR="$HOME/Library/Fonts" ;;
  *)      FONTDIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts" ;;
esac
mkdir -p "$FONTDIR"

fetch() {  # $1 = family dir (poppins|carlito), $2 = file base
  local url="$BASE/$1/$2.ttf"
  if curl -fsSL "$url" -o "$FONTDIR/$2.ttf"; then
    printf '  %s\n' "$2.ttf"
  else
    printf 'warning: could not download %s\n' "$url" >&2
  fi
}

echo "Installing Poppins (headings) -> $FONTDIR"
for f in "${POPPINS[@]}"; do fetch poppins "$f"; done
echo "Installing Carlito (body) -> $FONTDIR"
for f in "${CARLITO[@]}"; do fetch carlito "$f"; done

if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$FONTDIR" >/dev/null 2>&1 || true
  echo "Refreshed font cache."
fi
echo "Done."
