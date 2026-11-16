# CLI tools. GUI apps live in Brewfile.casks

## Taps

# HashiCorp formulae (vault left homebrew-core after the license change)
tap "hashicorp/tap"

## Shell

# Friendly interactive shell (login shell)
brew "fish"

## Security

# OpenSSH with FIDO2 support, needed for YubiKey sk-* SSH keys (Apple's ssh can't)
brew "openssh"
# YubiKey configuration tool
brew "ykman"

## CLI tools & utilities

# Search tool. Rust alternative to `find`
brew "fd"
# Search tool. Rust alternative to `grep`
brew "ripgrep"
# JSON processor
brew "jq"
# YAML/JSON/XML processor, `jq` for YAML
brew "yq"
# GitHub CLI: PRs, issues, Actions from the terminal
brew "gh"
# Task runner for project `justfile`s
brew "just"
# Fuzzy finder for files, history, anything piped in
brew "fzf"
# Smarter `cd` that jumps to frequently used directories
brew "zoxide"
# Loads per-directory environment variables from `.envrc`
brew "direnv"
# Re-runs a command every few seconds and shows its output
brew "watch"

## Programming environments

# Go version manager
brew "goenv"
# Node.js version manager
brew "nodenv"
# Fast, disk-efficient Node package manager
brew "pnpm"

## Infrastructure

# Kubernetes CLI (kubectl)
brew "kubernetes-cli"
# Kubernetes package manager
brew "helm"
# Terminal UI for Kubernetes clusters
brew "k9s"
# Fast switching between kubectl contexts (kubectx) and namespaces (kubens)
brew "kubectx"
# Follow logs from multiple Kubernetes pods at once
brew "stern"
# HashiCorp Vault CLI: read and write secrets (uses VAULT_ADDR)
brew "hashicorp/tap/vault"
# Postgres client (psql, pg_dump) without the server
brew "libpq"
# Grafana MCP server, used by Claude Code
brew "mcp-grafana"
