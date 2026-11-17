# How I work with AI

My Claude Code and Codex setup: global instructions, skills, agents, commands and settings.
The layout mirrors `~/.claude`, and `install.sh` links each item there, and the instructions and skills into Codex too (see the main README).

## Layout

| Path | What it is | Installed as |
|---|---|---|
| `CLAUDE.md` | Global instructions for every project, shared by both tools | `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` symlinks |
| `skills/<name>/SKILL.md` | Workflows loaded when a task matches the description, or run as `/<name>` in Claude Code and `$<name>` in Codex | `~/.claude/skills/<name>` and `~/.agents/skills/<name>` symlinks |
| `agents/<name>.md` | Subagents with their own prompt, tools and model, for focused side tasks (review, research) | `~/.claude/agents/<name>.md` symlink |
| `commands/<name>.md` | Plain slash commands. Prefer a skill: it does the same and Claude can also load it on its own | `~/.claude/commands/<name>.md` symlink |
| `rules/<name>.md` | Extra global instructions, one topic per file | `~/.claude/rules/<name>.md` symlink |
| `settings.json` | Settings baseline: attribution off, secret files blocked, plugins | Merged into `~/.claude/settings.json` |

Skills use the [Agent Skills](https://agentskills.io) format (`<name>/SKILL.md` with `name` and `description` frontmatter), so Codex uses them too. An optional `agents/openai.yaml` holds Codex-only metadata, such as `policy.allow_implicit_invocation: false` for skills that should only run when called.
Keep skills tool-neutral: Claude-only syntax (`!` command injection, `$ARGUMENTS`) shows up as plain text in Codex. Plugins don't carry over; install their Codex versions inside Codex.

## Catalog

Keep this list in sync when adding or removing an item.

### Skills

| Skill | Use it for | Source |
|---|---|---|
| [`commit`](skills/commit/SKILL.md) | One signed, one-line commit in the repo's own message style | Mine |
| [`grill-me`](skills/grill-me/SKILL.md) | `/grill-me`: be interviewed relentlessly about a plan or design. Only runs when called; hands off to `grilling` | [mattpocock/skills@5863806](https://github.com/mattpocock/skills/tree/5863806dd4e15c63174bee4e7515a4256792ecfa/skills/productivity/grill-me), MIT, unchanged |
| [`grilling`](skills/grilling/SKILL.md) | The interview itself: walks the decision tree of a plan one question at a time | [mattpocock/skills@5863806](https://github.com/mattpocock/skills/tree/5863806dd4e15c63174bee4e7515a4256792ecfa/skills/productivity/grilling), MIT, unchanged |
| [`handoff`](skills/handoff/SKILL.md) | `/handoff [what's next]`: writes the session into a short document in `$TMPDIR` that a fresh Claude or Codex session can continue from. Only runs when called | [mattpocock/skills@5863806](https://github.com/mattpocock/skills/tree/5863806dd4e15c63174bee4e7515a4256792ecfa/skills/productivity/handoff), MIT, unchanged |

### Agents

None yet.

### Plugins

Installed from marketplaces, enabled in `settings.json`, updated by Claude Code. Not copied into this repo.

| Plugin | What it adds |
|---|---|
| `superpowers@claude-plugins-official` | Process skills: brainstorming, plans, TDD, systematic debugging, code review |
| `ponytail@ponytail` | Pushes for the simplest working solution; over-engineering review and audit |
| `ralph-loop@claude-plugins-official` | Runs the same prompt in a loop until a task is done |
| `gopls-lsp@claude-plugins-official` | Go language server, so Claude gets real Go diagnostics and navigation |
| `security-guidance@claude-plugins-official` | Warns about insecure code patterns while Claude edits files |
| `second-opinion@trailofbits` | `/second-opinion`: independent review of uncommitted changes, a branch diff or a commit by Codex (needs the `codex` CLI). From [trailofbits/skills](https://github.com/trailofbits/skills), CC-BY-SA-4.0, so used as a plugin rather than copied |

## Adding things

- **My own skill:** create `skills/<name>/SKILL.md`, add it to the catalog, run `sh claude/install.sh`.
- **Someone else's skill:** copy the whole skill folder into `skills/<name>/`, including its `LICENSE`. In the catalog's Source column, link the exact upstream commit, not a branch, so it's clear what was copied. Note any local changes there too.
- **A whole plugin:** add its marketplace to `extraKnownMarketplaces` and the plugin to `enabledPlugins` in `settings.json`, then add it to the Plugins table.
- **Work-only items** (company Jira, internal tools, company names) never go here. Put them directly in `~/.claude/skills/`, `~/.claude/rules/` and so on: the installer leaves real files alone.

