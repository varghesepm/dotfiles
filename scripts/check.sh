#!/usr/bin/env bash
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failed=0
for f in "$ROOT"/bash/* "$ROOT"/install.sh "$ROOT"/scripts/*.sh; do
 [[ -f "$f" ]] || continue
 if bash -n "$f"; then printf 'OK  %s\n' "${f#$ROOT/}"; else failed=1; fi
done
if command -v git >/dev/null 2>&1; then
 for f in config delta.gitconfig aliases.gitconfig config-personal.example config-work.example; do
  if git config --file "$ROOT/git/$f" --list >/dev/null; then echo "OK  git/$f"; else failed=1; fi
 done
fi
exit "$failed"
