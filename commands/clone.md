---
description: Clone a repo by owner/repo or URL — asks where first, defaults to the parent folder
argument-hint: [owner/repo or URL, optional folder name]
allowed-tools: Bash(git clone:*), Bash(gh repo clone:*), Bash(pwd:*)
model: haiku
disable-model-invocation: true
---
Work out the folder the clone will create: the given folder name, or the repo's own name if none given. Run `pwd` to find the current directory — its parent (one level up) is the recommended destination root. Never clone into the current directory itself: it's usually an existing project, and nesting one repo inside another is almost never wanted.

Present the destination as real selectable options using the option-picker tool, not plain-text:
- **Parent folder (Recommended)** — `<parent of pwd>/<folder>` — show the full resolved path in the option's description
- **Desktop** — `~/Desktop/<folder>` — show the full resolved path too
- If the user types a path instead of picking (the picker's built-in free-text option), treat it as the destination root — use it directly.

After the choice, state the full final path — e.g. "Cloning into: /Users/you/parent/repo-name" — then run `gh repo clone <owner/repo> <full path>` (or `git clone <URL> <full path>` if a full URL was given). Report the local path it actually cloned into.

Repo (and optional folder name): $ARGUMENTS
