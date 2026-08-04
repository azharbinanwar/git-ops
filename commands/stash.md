---
description: Stash your changes with a name, so you can find it later
argument-hint: [stash name]
allowed-tools: Bash(git stash:*), Bash(git status:*)
model: haiku
effort: low
disable-model-invocation: true
---
If there are no open changes, say so and stop. Otherwise, if $ARGUMENTS is empty, ask for a name in one line instead of guessing one. Run `git stash push -m "<name>"`. Report what was stashed (file count) and the stash reference (e.g. `stash@{0}`).

Stash name: $ARGUMENTS
