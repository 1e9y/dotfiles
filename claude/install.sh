#!/bin/sh
# Install this repo's AI setup for Claude Code and Codex.
# - CLAUDE.md is linked as ~/.claude/CLAUDE.md and ~/.codex/AGENTS.md (one set of instructions for both).
# - Each skill is linked into ~/.claude/skills and ~/.agents/skills (where Codex looks);
#   each agent, command and rule into ~/.claude/<kind>.
#   Items are linked one by one, so work-only items and the tools' own files next to them stay untouched.
# - settings.json is merged into ~/.claude/settings.json, not linked (see merge-settings.jq).
# Safe to rerun. A real file in the way is renamed to <name>.bak.<timestamp> first.
set -eu
src=$(cd "$(dirname "$0")" && pwd)
claude=${CLAUDE_CONFIG_DIR:-$HOME/.claude}
codex=${CODEX_HOME:-$HOME/.codex}

link() {
	if [ -e "$2" ] && [ ! -L "$2" ]; then
		mv "$2" "$2.bak.$(date +%s)"
		echo "backed up $2"
	fi
	ln -sfn "$1" "$2"
}

# link_each <repo folder> <target folder>: link every item, drop links to items removed from the repo
link_each() {
	mkdir -p "$2"
	for item in "$2"/*; do
		if [ -L "$item" ] && [ ! -e "$item" ]; then
			case $(readlink "$item") in "$src"/*) rm "$item" && echo "removed stale $item" ;; esac
		fi
	done
	[ -d "$1" ] || return 0
	for item in "$1"/*; do
		[ -e "$item" ] || continue
		link "$item" "$2/$(basename "$item")"
	done
}

mkdir -p "$claude" "$codex"
link "$src/CLAUDE.md" "$claude/CLAUDE.md"
link "$src/CLAUDE.md" "$codex/AGENTS.md"

for kind in skills agents commands rules; do
	link_each "$src/$kind" "$claude/$kind"
done
link_each "$src/skills" "$HOME/.agents/skills"

settings=$claude/settings.json
[ -f "$settings" ] || echo '{}' >"$settings"
tmp=$(mktemp)
jq -s -f "$src/merge-settings.jq" "$settings" "$src/settings.json" >"$tmp"
cp "$settings" "$settings.bak"
mv "$tmp" "$settings"
echo "installed into $claude, $codex and $HOME/.agents/skills"
