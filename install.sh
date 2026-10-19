#!/usr/bin/env bash
set -euo pipefail

[[ $(uname -s) == Darwin ]] || { echo 'This installer targets macOS' >&2; exit 1; }
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XDG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)-$$"
BACKUP="$XDG/dotfiles-backups/$STAMP"

link_file() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -L "$dst" && $(readlink "$dst") == "$src" ]]; then echo "Already linked $dst"; return; fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$BACKUP/$(dirname "${dst#"$XDG"/}")"
    mv "$dst" "$BACKUP/${dst#"$XDG"/}"
    echo "Backed up $dst"
  fi
  ln -s "$src" "$dst"
  echo "Linked $dst"
}

for f in bashrc env aliases functions history completions prompt; do
  link_file "$ROOT/bash/$f" "$XDG/bash/$f"
done
link_file "$ROOT/eza/theme.yml" "$XDG/eza/theme.yml"

for f in config delta.gitconfig aliases.gitconfig; do
  link_file "$ROOT/git/$f" "$XDG/git/$f"
done

for kind in personal work; do
  dest="$XDG/git/config-$kind"
  if [[ ! -e "$dest" ]]; then
    cp "$ROOT/git/config-$kind.example" "$dest"
    chmod 600 "$dest"
    echo "Created local identity template $dest — EDIT BEFORE COMMITTING"
  fi
done

# Existing ~/.gitconfig stays untouched by design. User must migrate it manually.
if [[ ${1:-} == '--wezterm' ]]; then link_file "$ROOT/wezterm/wezterm.lua" "$XDG/wezterm/wezterm.lua"; fi
printf '\nInstall complete. Backups (if needed): %s\n' "$BACKUP"
printf 'Set personal/work names and emails in %s/git/config-{personal,work}.\n' "$XDG"
printf 'Review ~/.gitconfig for conflicting identity before using Git.\n'
printf 'Start Bash: /opt/homebrew/bin/bash --noprofile --rcfile "$HOME/.config/bash/bashrc" -i\n'
printf 'Optional WezTerm install: bash install.sh --wezterm (backs up your existing WezTerm config).\n'
