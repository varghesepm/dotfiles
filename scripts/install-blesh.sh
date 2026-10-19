#!/usr/bin/env bash
set -euo pipefail
base="${XDG_CONFIG_HOME:-$HOME/.config}/bash"
command -v git >/dev/null || { echo 'Install git first' >&2; exit 1; }
command -v gmake >/dev/null || { echo 'Install gmake (brew install make) first' >&2; exit 1; }
if [[ ! -d "$base/blesh/.git" ]]; then
  git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git "$base/blesh"
fi
gmake -C "$base/blesh"
echo 'ble.sh built. Open a new Bash tab.'
