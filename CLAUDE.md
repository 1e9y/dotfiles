# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal macOS dotfiles. No build, lint, or test tooling, and no install/symlink script: files are copied to their home locations by hand (`~/.config/fish` and `~/.gitconfig` are plain files, not symlinks to this repo).

## Layout → destination

| Repo path | Lives at |
|-----------|----------|
| `.gitconfig` | `~/.gitconfig` (GPG-signed commits, `pull.rebase = true`, short aliases like `s`, `cm`, `go`) |
| `.gnupg/gpg.conf` | `~/.gnupg/gpg.conf` |
| `fish/` | `~/.config/fish/` |
| `Brewfile` | CLI formulae, used with `brew bundle --file=Brewfile` |
| `Brewfile.casks` | GUI apps (casks), used with `brew bundle --file=Brewfile.casks` |
| `.homebrew/brew.env` | `~/.homebrew/brew.env`: Homebrew settings for every shell (`KEY=value` per line, no quotes) |

## Brewfile

`Brewfile` is the **minimal set of tools that must exist on a fresh Mac**, not a mirror of what happens to be installed.

- **Never install, uninstall, or upgrade anything.** No `brew install/uninstall/upgrade`, no `brew bundle` without a subcommand, no `brew bundle cleanup --force`. Only edit the `Brewfile` text.
- Homebrew lives at `~/homebrew/bin/brew` (may not be on `PATH` in non-fish shells).
- Read-only commands for comparing the machine with the file:
  - `~/homebrew/bin/brew leaves --installed-on-request`: formulae installed on purpose (this skips dependencies)
  - `~/homebrew/bin/brew list --cask`: installed casks
  - `~/homebrew/bin/brew bundle dump --describe --file=-`: what's installed, with descriptions, printed to stdout
  - `~/homebrew/bin/brew bundle check --file=Brewfile`: whether everything in the file is installed
  - `~/homebrew/bin/brew bundle cleanup --file=Brewfile`: dry run listing what's installed but not in the file
- Leave out:
  - packages that are only dependencies of another entry
  - packages that duplicate another entry's job (keep one tool per job)
  - packages installed for a one-off task
  - anything macOS already ships
- When unsure whether something is a must-have, ask the user instead of adding it.
- Every entry gets a one-line `#` comment directly above it saying what the package does, in the existing style:
  ```ruby
  # Search tool. Rust alternative to `grep`
  brew "ripgrep"
  ```
- `Brewfile` holds only `tap`/`brew` entries; every `cask` goes in `Brewfile.casks`. Run the read-only commands above against both files.
- `Brewfile` sections, in this order, each headed `## Name` (a markdown-style heading that is also a Ruby comment): Shell (fish) → Security (ssh, YubiKey, …) → CLI tools & utilities (fd, ripgrep, jq, yq, …) → Programming environments (goenv, nodenv, pnpm, …) → everything else. A `## Taps` section, if any, goes first.
- `Brewfile.casks` uses the same `## Name` headings, grouped by purpose.

## Fish

- `fish/config.fish` is the only hand-written fish file. Homebrew is expected at `~/homebrew/bin/brew` (non-standard prefix), casks install to `~/Applications`.
- Everything else under `fish/functions`, `fish/conf.d`, `fish/completions` is vendored by the **fisher** plugin manager from `fish/fish_plugins` (fisher, nvm.fish, autopair.fish, tide@v5, z, bass). Don't edit those files; change `fish_plugins` and run `fisher update`.
- `fish/fish_variables` is fish's auto-generated universal-variable store (includes tide prompt config and fisher bookkeeping with absolute home paths). Don't hand-edit.

## Conventions

- Commit messages: `<area>: <lowercase summary>` (e.g. `fish: use english language`, `brew: add Brewfile`).
- `.editorconfig`: LF, final newline, tab indentation.
