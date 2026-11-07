#!/usr/bin/env bash
# Compile every example and smoke test; fail on any error or warning.
#   test.sh [path/to/typst]
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
typst="${1:-$("$SKILL_DIR/scripts/install-typst.sh" --print-path)}"
out="$(mktemp -d)"; trap 'rm -rf "$out"' EXIT
cd "$SKILL_DIR"
echo "Testing with $("$typst" --version)"

run() {  # name, file, extra args…
  local name="$1" file="$2"; shift 2
  local log
  if ! log="$("$typst" compile --root . --font-path fonts --ignore-system-fonts "$@" "$file" "$out/$name.pdf" 2>&1)"; then
    echo "FAIL  $name"; echo "$log"; exit 1
  fi
  if echo "$log" | grep -q "warning"; then
    echo "WARN  $name"; echo "$log"; exit 1
  fi
  echo "ok    $name"
}

run report  examples/report.typ
for v in cover classic print; do run "variant-$v" tests/variants.typ --input variant="$v"; done
run syntax  tests/syntax.typ

# The starter template must compile as scaffolded.
proj="$out/scaffold"
bash scripts/new.sh "$proj" >/dev/null
if ! log="$("$typst" compile --font-path fonts --ignore-system-fonts "$proj/main.typ" "$out/scaffold.pdf" 2>&1)" || echo "$log" | grep -q warning; then
  echo "FAIL  scaffold"; echo "$log"; exit 1
fi
echo "ok    scaffold"

# Chinese smoke test only if a CJK serif is installed.
if "$typst" fonts | grep -q "Noto Serif SC"; then
  "$typst" compile --root . --font-path fonts tests/zh.typ "$out/zh.pdf" && echo "ok    zh"
else
  echo "skip  zh (no Noto Serif SC font found)"
fi
echo "All tests passed."
