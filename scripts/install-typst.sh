#!/usr/bin/env bash
# Ensure a Typst compiler >= 0.13 is available; install a pinned release if not.
#
#   install-typst.sh                # install if needed, report what is used
#   install-typst.sh --print-path   # same, but print only the binary path on stdout
#
# Env: TYPST_VERSION (default below), TYPST_INSTALL_DIR (default ~/.local/bin)
set -euo pipefail

PINNED="${TYPST_VERSION:-0.15.1}"
INSTALL_DIR="${TYPST_INSTALL_DIR:-$HOME/.local/bin}"
quiet=0
[ "${1:-}" = "--print-path" ] && quiet=1
log() { [ $quiet -eq 1 ] && echo "$@" >&2 || echo "$@"; }

version_ok() {  # $1 = path to typst; accepts >= 0.13
  local v major minor
  v="$("$1" --version 2>/dev/null | awk '{print $2}')" || return 1
  major="${v%%.*}"; minor="$(echo "$v" | cut -d. -f2)"
  [ -n "$major" ] && { [ "$major" -gt 0 ] || [ "$minor" -ge 13 ]; }
}

for candidate in "$(command -v typst 2>/dev/null || true)" "$INSTALL_DIR/typst"; do
  if [ -n "$candidate" ] && [ -x "$candidate" ] && version_ok "$candidate"; then
    log "Using $("$candidate" --version) at $candidate"
    [ $quiet -eq 1 ] && echo "$candidate"
    exit 0
  fi
done

case "$(uname -s)-$(uname -m)" in
  Linux-x86_64)         target="x86_64-unknown-linux-musl" ;;
  Linux-aarch64|Linux-arm64) target="aarch64-unknown-linux-musl" ;;
  Darwin-arm64)         target="aarch64-apple-darwin" ;;
  Darwin-x86_64)        target="x86_64-apple-darwin" ;;
  *) echo "Unsupported platform $(uname -s)-$(uname -m). Install Typst >= 0.13 manually: https://github.com/typst/typst#installation" >&2; exit 1 ;;
esac

url="https://github.com/typst/typst/releases/download/v${PINNED}/typst-${target}.tar.xz"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
log "Downloading Typst ${PINNED} (${target})…"
curl -fsSL "$url" -o "$tmp/typst.tar.xz"
if command -v xz >/dev/null 2>&1; then
  tar -xJf "$tmp/typst.tar.xz" -C "$tmp"
else  # minimal images often lack xz; Python's lzma is a reliable fallback
  python3 -c "import lzma,tarfile,sys; tarfile.open(fileobj=lzma.open(sys.argv[1])).extractall(sys.argv[2])" "$tmp/typst.tar.xz" "$tmp"
fi
mkdir -p "$INSTALL_DIR"
install -m 755 "$tmp/typst-${target}/typst" "$INSTALL_DIR/typst"
log "Installed $("$INSTALL_DIR/typst" --version) to $INSTALL_DIR/typst"
[ $quiet -eq 1 ] && echo "$INSTALL_DIR/typst"
exit 0
