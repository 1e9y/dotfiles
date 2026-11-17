# Global instructions

Shared by Claude Code (`~/.claude/CLAUDE.md`) and Codex (`~/.codex/AGENTS.md`). Apply to every project; a project's own CLAUDE.md or AGENTS.md overrides these.

## Communication

- I'm not a native English speaker. Correct my English mistakes from time to time.

## Engineering

These bias toward caution over speed; use judgment on trivial tasks.

- **Think before coding.** State your assumptions. If the request can be read more than one way, or something is unclear, stop and ask instead of guessing. Say so when a simpler approach exists.
- **Keep it simple.** Write the minimum code that solves the problem: no features, abstractions or configurability nobody asked for, no error handling for impossible cases.
- **Make surgical changes.** Every changed line traces back to the request. Don't reformat, refactor or "improve" nearby code, and match the existing style. Mention unrelated problems instead of fixing them. Remove only what your own change made unused.
- **Work toward a checkable goal.** Turn the task into something you can verify (a failing test to make pass, a command that must succeed). For multi-step work, give a short plan with a check per step, and run the checks before saying the work is done.

## Git

- Commit messages are a single line. No body.
- Never add Co-Authored-By or any other AI attribution to commits or pull requests.
