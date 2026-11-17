# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal macOS dotfiles. No build, lint, or test tooling, and no install script: setup is manual, per the README (fish, git and Claude instruction files are symlinked; Claude settings are merged; the rest copied).

## Layout → destination

| Repo path | Lives at |
|-----------|----------|
| `git/config`, `git/ignore` | symlinked into `~/.config/git/` (`~/.gitconfig` must not exist, or it overrides them) |
| `.gnupg/gpg.conf` | `~/.gnupg/gpg.conf` |
| `fish/config.fish`, `fish/fish_plugins` | symlinked into `~/.config/fish/` |
| `Brewfile` | CLI formulae, used with `brew bundle --file=Brewfile` |
| `Brewfile.casks` | GUI apps (casks), used with `brew bundle --file=Brewfile.casks` |
| `.homebrew/brew.env` | `~/.homebrew/brew.env`: Homebrew settings for every shell (`KEY=value` per line, no quotes) |
| `claude/` | installed by `sh claude/install.sh`: `CLAUDE.md` → `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`; skills → `~/.claude/skills/` and `~/.agents/skills/` (Codex); agents, commands, rules → `~/.claude/`; all per-item symlinks. `settings.json` merged, never linked |

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

- Deployed as symlinks: `~/.config/fish/config.fish` → `fish/config.fish`, `~/.config/fish/fish_plugins` → `fish/fish_plugins` (setup steps in README). Everything else in `~/.config/fish` (plugin files, completions, `fish_variables`, `conf.d/fish_frozen_*`) is machine state: never add it to the repo.
- `fish/config.fish` sections, in order: Environment → Programming environments → Infrastructure → Interactive shell → Local settings. Guard optional tools with `type -q <tool>; and …` or `test -f`, so a fresh Mac doesn't error before everything is installed.
- PATH: `fish_add_path -g` prepends via `fish_user_paths`, which always sits **before** `$PATH`, even with `-a`. For anything that must come after the version-manager shims (nodenv's global npm bin, OrbStack), use `fish_add_path -aP`.
- Corporate/private settings (tokens, internal URLs like `VAULT_ADDR`) go in `~/.config/fish/local.d/*.fish`, sourced last. Never put them in `config.fish`.
- `fish/fish_plugins` holds only plugin names: fisher rewrites the file on install/update and drops comments. Describe plugins in the README's Plugins table instead, and keep that table in sync.
- Test changes without touching the live shell: point `XDG_CONFIG_HOME` at a scratch dir whose `fish/config.fish` is a symlink to the repo file, then run `env -i HOME=$HOME PATH=/usr/bin:/bin TERM=xterm XDG_CONFIG_HOME=<dir> ~/homebrew/bin/fish -c '…'`. `fish --no-config` is not enough: it skips the startup code that applies `fish_add_path -g`. Syntax only: `fish -n fish/config.fish`.

## Git

- `git/config` is the global config. Corporate and machine-specific settings (work email, `includeIf` blocks for company repos, extra signing rules) go in `~/.config/git/local`, which `git/config` includes last. Never put company names, internal hosts or work emails in `git/config`.
- Use `~/` or `$HOME` instead of `/Users/<name>` paths: the username differs between Macs.
- Test without touching the live config: make a scratch dir with `.config/git/config` symlinked to the repo file, then run `env -i HOME=<dir> PATH=/usr/bin:/bin git config --global --list --show-origin`.

## Claude Code

- `claude/` is the user's AI methodology: it mirrors `~/.claude`. When adding a skill, agent, command or rule, put it there in the right folder (skills as `<name>/SKILL.md`), add it to the catalog in `claude/README.md`, and keep that catalog in sync on removal.
- Third-party skills are copied in whole, with their `LICENSE`, and the catalog links the exact upstream commit.
- The repo is public and `~/.claude/settings.json` holds work `autoMode` rules that Claude Code rewrites itself. So `claude/settings.json` is a personal baseline merged into the live file, never a symlink. Don't copy keys from the live file into it without checking they're not work-related.
- Work-only skills, rules and settings stay directly in `~/.claude`, never in `claude/`.
- Skills are shared with Codex, so keep them tool-neutral: no `!` command injection or `$ARGUMENTS`. Copied third-party skills stay unchanged.

## Conventions

- Commit messages: `<area>: <lowercase summary>` (e.g. `fish: use english language`, `brew: add Brewfile`).
- `.editorconfig`: LF, final newline, tab indentation.
