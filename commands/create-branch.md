---
description: Suggest a branch name from what you're about to do, create and switch to it — takes open changes along if you want
argument-hint: [what you're about to work on]
model: haiku
effort: low
allowed-tools: Bash(git branch:*), Bash(git checkout:*), Bash(bash:*)
disable-model-invocation: true
---
## Context
- Open changes: !`git status --porcelain 2>/dev/null | wc -l`
- Recent branches: !`git branch --sort=-committerdate --format='%(refname:short)' 2>/dev/null | head -8`

## Task
1. If no description was given below, ask in one line what the branch is for (that's where the name comes from) and wait — never invent a name from nothing.
2. Suggest a short kebab-case branch name from the description (e.g. "fix login bug" → `fix/login-bug`), matching the style visible in "Recent branches".
3. If "Open changes" above is 0: run `git checkout -b <name>`, report the branch name, done.
4. If there ARE open changes, present three options via the option-picker tool (never plain text):
   - **Take my changes to the new branch (Recommended)** — runs `git checkout -b <name>`; uncommitted work moves with you, nothing is lost. The usual "I started coding before branching" fix.
   - **Stash first, start clean** — runs `bash "${CLAUDE_PLUGIN_ROOT}/scripts/stash.sh" <short name derived from the changes>` then `git checkout -b <name>`; the new branch starts clean, `git stash pop` brings the work back wherever wanted.
   - **Cancel** — ends the turn; nothing created or stashed.

Report the branch you're now on (and the stash reference if one was made). The Context above is the only data needed — run nothing else to gather.

What you're about to work on: $ARGUMENTS
