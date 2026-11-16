# Fish shell config. Symlinked to ~/.config/fish/config.fish
# Machine-specific and corporate settings go in ~/.config/fish/local.d/*.fish (never committed)

## Environment

set -gx LANG en_US.UTF-8

# Homebrew in ~/homebrew. Its own settings live in ~/.homebrew/brew.env
if test -x ~/homebrew/bin/brew
    ~/homebrew/bin/brew shellenv fish | source
    # Keg-only Postgres client: psql, pg_dump
    fish_add_path -g $HOMEBREW_PREFIX/opt/libpq/bin
end

# Claude Code, pipx and other user-installed binaries
fish_add_path -g ~/.local/bin

## Programming environments

# Go and Node version managers (add their shims to PATH)
type -q goenv; and goenv init - fish | source
type -q nodenv; and nodenv init - fish | source

# Global npm packages of the current Node version, after the shims so `.node-version` still wins
type -q nodenv; and fish_add_path -aP (nodenv prefix 2>/dev/null)/bin

# Global pnpm packages (`pnpm add -g`) and pnpm's package store
set -gx PNPM_HOME ~/.local/share/pnpm
fish_add_path -g $PNPM_HOME/bin

set -gx BUN_INSTALL ~/.bun
fish_add_path -g $BUN_INSTALL/bin

## Infrastructure

# Google Cloud SDK (gcloud), installed by the gcloud-cli cask
set -l gcloud_path $HOMEBREW_PREFIX/share/google-cloud-sdk/path.fish.inc
test -f $gcloud_path; and source $gcloud_path

# OrbStack CLI: docker, orb, orbctl
fish_add_path -aP ~/.orbstack/bin

## Interactive shell

if status is-interactive
    set -g fish_greeting

    abbr -a g git

    # Smarter `cd`: `z <part of path>`
    type -q zoxide; and zoxide init fish | source
    # Per-directory environment from .envrc
    type -q direnv; and direnv hook fish | source

    # YubiKey FIDO2 (sk-*) SSH keys need Homebrew's ssh-agent: Apple's can't sign with them.
    # Reuse the agent saved in ~/.ssh/agent.env, or start a new one and load the keys.
    test -f ~/.ssh/agent.env; and source ~/.ssh/agent.env
    if not ssh-add -l >/dev/null 2>&1
        ssh-agent -c | sed -n 's/^setenv \(.*\);$/set -gx \1/p' >~/.ssh/agent.env
        source ~/.ssh/agent.env
        ssh-add ~/.ssh/id_yubikey_1 ~/.ssh/id_yubikey_nano_1
    end
end

## Local settings

for file in $__fish_config_dir/local.d/*.fish
    source $file
end
