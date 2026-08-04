---
description: Fork a repo and clone it locally
argument-hint: "[owner/repo, or nothing for the current repo]"
allowed-tools: Bash(gh repo fork:*), Bash(git remote:*)
model: haiku
effort: low
disable-model-invocation: true
---
Resolve the target repo — given `owner/repo`, or the current repo's remote if none given. Show what will happen: fork it under your account, and clone it into a new folder named after the repo (or add it as a remote if you're already inside a clone of the original).

Present two options via the option-picker tool (never plain text):
- **Fork it** — runs `gh repo fork <owner/repo> --clone` (or `--remote` if already inside a clone of the original). Report the resulting URL/path.
- **Fix something first** — ends the turn immediately, nothing forked. A typed correction = the fix: apply it, then re-show the corrected plan with this picker.

Target (optional): $ARGUMENTS
