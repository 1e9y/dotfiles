---
name: commit
description: Create one signed git commit from the staged changes, with a one-line message in the repository's own style. Use when asked to commit, make a commit, or commit changes.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git commit:*)
argument-hint: "[optional scope or message hint]"
---

Create a single commit from the staged changes:

1. Run `git status --short`, `git diff --cached` and `git log --oneline -10`.
2. If nothing is staged, say so and suggest what to stage. Don't stage on your own.
3. Write a one-line message, no body. Match the style of the recent commits (for example `area: summary` or `type(scope): summary`). If the history has no clear style, use a conventional commit: `type(scope): description` with type one of feat, fix, docs, style, refactor, perf, test, chore. If the user gave a scope or message hint, use it.
4. No AI attribution: no Co-Authored-By trailer, no mention of the AI tool.
5. Sign it: `git commit -S -m "<message>"`. Signing needs a YubiKey touch, so tell the user to touch the key.
