#!/usr/bin/env bash
# Install the template as a local Typst package, importable from anywhere as
#   #import "@local/claude-academic:0.1.0": *
# Fonts still have to be passed with --font-path (or TYPST_FONT_PATHS).
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
version="$(sed -n 's/^version *= *"\(.*\)"/\1/p' "$SKILL_DIR/claude-academic/typst.toml")"
case "$(uname -s)" in
  Darwin) data="$HOME/Library/Application Support" ;;
  *)      data="${XDG_DATA_HOME:-$HOME/.local/share}" ;;
esac
dest="$data/typst/packages/local/claude-academic/$version"
mkdir -p "$dest"
cp -R "$SKILL_DIR/claude-academic/." "$dest/"
echo "Installed @local/claude-academic:$version → $dest"
