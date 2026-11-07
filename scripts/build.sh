#!/usr/bin/env bash
# Compile a claude-academic document with the bundled fonts.
#
#   build.sh <input.typ> [output.pdf] [--png] [--ppi N] [--root DIR]
#
#   --png    also render every page to <output>-page-NN.png for visual review
#   --root   project root for absolute paths/imports (default: the input's folder)
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
png=0; ppi=110; root=""; pos=()
while [ $# -gt 0 ]; do
  case "$1" in
    --png)  png=1 ;;
    --ppi)  ppi="$2"; shift ;;
    --root) root="$2"; shift ;;
    -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
    *) pos+=("$1") ;;
  esac
  shift
done
[ ${#pos[@]} -ge 1 ] || { echo "usage: build.sh <input.typ> [output.pdf] [--png] [--ppi N] [--root DIR]" >&2; exit 2; }
in="${pos[0]}"
out="${pos[1]:-${in%.typ}.pdf}"

typst="$("$SKILL_DIR/scripts/install-typst.sh" --print-path)"
flags=(--font-path "$SKILL_DIR/fonts")
[ -n "$root" ] && flags+=(--root "$root")

"$typst" compile "${flags[@]}" "$in" "$out"
echo "PDF  $out"

if [ $png -eq 1 ]; then
  base="${out%.pdf}"
  rm -f "${base}"-page-*.png
  "$typst" compile "${flags[@]}" --format png --ppi "$ppi" "$in" "${base}-page-{0p}.png"
  echo "PNG  ${base}-page-*.png  (open and inspect every page)"
fi
