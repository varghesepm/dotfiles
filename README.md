# Bash dotfiles (macOS / Apple Silicon)

Includes modern Bash, WezTerm, Catppuccin Mocha eza, Starship, fzf, optional ble.sh, Bash history, aliases/functions, Git/delta/lazygit support, and personal/work Git identities.

## Requirements

- macOS with Homebrew (Apple Silicon paths assumed for WezTerm). Install Homebrew from https://brew.sh if missing.
- Install WezTerm separately (e.g. `brew install --cask wezterm`).
- Install Hack Nerd Font (e.g. `brew install --cask font-hack-nerd-font`).

## Quick start on a new Mac

```bash
# In a terminal, after Homebrew is installed:
brew install bash bash-completion@2 git git-delta lazygit starship eza fzf zoxide bat gawk make nvim shellcheck shfmt
brew install --cask wezterm font-hack-nerd-font
# Clone your OWN uploaded repository and cd into it:
git clone git@github.com:YOUR_ACCOUNT/YOUR_DOTFILES_REPO.git ~/dotfiles
cd ~/dotfiles
bash scripts/check.sh
bash install.sh --wezterm
bash scripts/install-blesh.sh
```

Edit your local author identity files **before committing**:

```bash
nvim ~/.config/git/config-personal
nvim ~/.config/git/config-work
```

Default directory mapping in `~/.config/git/config`: `~/personal/` = personal, `~/work/` = work. Create those folders or change the patterns. For an existing `~/.gitconfig`, **do not blindly delete it**: back it up, migrate relevant settings, and remove conflicts; `~/.gitconfig` overrides XDG settings for repeated scalar keys. `user.useConfigOnly` refuses identity-less commits, unless another config or environment variable sets identity.

Open WezTerm. Its config launches modern Bash directly via `--rcfile`. This does **not** change the macOS login shell. No `.bash_profile`, `.zshrc`, or `.zprofile` is needed.

## Repository layout

```text
bash/         bashrc, env, aliases, functions, history, completions, prompt
eza/          Catppuccin Mocha eza theme (Mauve directories)
git/          XDG config, delta, aliases, identity examples
wezterm/      Complete WezTerm settings (Catppuccin Mocha, Hack Nerd Font, Bash)
scripts/      optional ble.sh installer, validator
install.sh    symlink installer with backups
```

## Daily commands

- `ll`, `la`, `ls`, `lt`: eza listing with Git annotations and icons.
- `gst`, `gds`, `gl`, `gll`, `lg`: Git status, staged diff, history, lazygit.
- `gwho`: show effective Git author/committer identities and email source; run before commits.
- `ij .`: open current project using the macOS IntelliJ IDEA app (`open -a`); Toolbox launcher not required.
- `bashreload`: restart the configured interactive Bash in the current tab.
- `k`: kubectl alias; kubectl Bash completion is configured when available.
- `tang`: remove dangling Docker images; **destructive** — inspect with `docker images --filter dangling=true` first.
- `fzf` Ctrl+R history and ble.sh enhancements (when built).

## Git personal / work identity

The Git XDG config `~/.config/git/config` is loaded **automatically** by Git. Its `include` and `includeIf` entries load the additional files. Never commit real email/name files if you don't want them public; the installer creates untracked local copies of `.example` templates. SSH authentication is separate from Git authorship; private SSH keys are not included.

```bash
git config --list --show-origin
git config --show-origin --get user.email
git var GIT_AUTHOR_IDENT
git var GIT_COMMITTER_IDENT
gwho
```

In repositories with existing `.git/config` local identity or environment variables (`GIT_AUTHOR_EMAIL` etc.), those can override the XDG identity. For two GitHub accounts, configure separate SSH host aliases in `~/.ssh/config` manually, never track private keys.

**If delta doesn't start**, run `delta --version` and `git config --show-origin --get core.pager`. `git-delta` supplies the `delta` executable.

**If lazygit complains about Git being older than 2.32:** run `type -a git`, `git --version`, and ensure Homebrew Git precedes `/usr/bin/git` in `PATH` (the Bash `env` initializes Homebrew).

## Customize

- Directory colors: edit `eza`; ensure `EZA_COLORS`, `EXA_COLORS`, and `LS_COLORS` aren't overriding the eza theme.
- Prompt: by default Starship picks up `~/.config/starship.toml` if you already have one; otherwise it uses its built-in theme. Starship Git indicators depend on Git config being valid.
- Machine-specific PATH/exports: create **untracked** `~/.config/bash/local.env` (not symlinked from repository).
- Add aliases under `bash` and functions under `bash/functions` — both are symlinked, so updates can be committed.
- Customize the `wezterm` default shell path for Intel Macs (`/usr/local/bin/bash`).

## History

Uses private `~/.config/bash/bash_history`, with append + import across interactive tabs on prompt (`history -a; history -n`). History timestamps are enabled. Concurrent terminal ordering may not be strictly chronological. History is **not stored in Git**. Note that `ble.sh` can influence interactive history editing; test Ctrl+R with your installed version.

## Existing-machine safety / rollback

`bash install.sh` links Bash/eza/Git config files only; `bash install.sh --wezterm` additionally links the complete WezTerm config. **Existing destination files are moved to** `~/.config/dotfiles-backups/<timestamp>/` instead of being deleted. Git's `~/.gitconfig`, SSH keys, history, and ble.sh source aren't modified. The installer is repeatable (already-correct links are skipped).

To roll back: remove only the new symlinks you want to revert, then restore the corresponding files from the printed backup directory. If you installed a WezTerm config, you can remove `~/.config/wezterm/wezterm.lua` symlink and restore its backup, or comment out `config.default_prog` to use the macOS default shell again. Avoid removing `~/.config/bash` wholesale because it contains runtime history and optional ble.sh.

## Checks and troubleshooting

```bash
bash scripts/check.sh
/opt/homebrew/bin/bash --noprofile --rcfile "$HOME/.config/bash/bashrc" -i
type ll; type bashreload; type ij; type gwho
printf 'Bash: %s\n' "$BASH_VERSION"
command -v git; git --version
git config --list --show-origin
```

If `ble.sh` displays `-- MULTILINE --`, press Ctrl+J to execute or Ctrl+C to cancel. If `[ble: exit 127]` appears, it means a command was not found; it is not, by itself, a ble.sh failure.

The repo is intended for **fresh Mac setup**, not POSIX `/bin/sh`. Scripts requiring Bash should use `#!/usr/bin/env bash`. For Mac-native tools, some optional CLIs (gcloud, kubectl, Docker, IntelliJ, NVM/Pyenv/SDKMAN) must be installed separately. No credentials or secrets are bundled.
