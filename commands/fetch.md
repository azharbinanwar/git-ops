---
description: Fetch the latest from remote — no merge, just downloads and shows what's new
allowed-tools: Bash(git fetch:*), Bash(git log:*), Bash(git status:*)
model: haiku
disable-model-invocation: true
---
Run `git fetch`. Then report how far behind/ahead the local branch is versus its upstream (`git status --short --branch` or `git log HEAD..@{u} --oneline`). Nothing is merged or changed locally — this is read-only against your working tree.
