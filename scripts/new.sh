#!/usr/bin/env bash
# Scaffold a new report: <dir>/main.typ, <dir>/refs.bib and a private copy of the template.
#
#   new.sh <dir>
#
# The template is copied (not linked) so the project compiles on its own and
# later template changes never alter a finished report.
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dir="${1:?usage: new.sh <dir>}"

if [ -e "$dir/main.typ" ]; then
  echo "Refusing to overwrite $dir/main.typ" >&2
  exit 1
fi
mkdir -p "$dir"
cp -R "$SKILL_DIR/claude-academic" "$dir/"
cp "$SKILL_DIR/templates/main.typ" "$dir/main.typ"
[ -e "$dir/refs.bib" ] || cp "$SKILL_DIR/templates/refs.bib" "$dir/refs.bib"
echo "Created $dir/main.typ"
echo "Build:  bash $SKILL_DIR/scripts/build.sh $dir/main.typ --png"
