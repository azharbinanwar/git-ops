---
description: Clone a repo by owner/repo or URL
argument-hint: [owner/repo or URL, optional folder name]
allowed-tools: Bash(git clone:*), Bash(gh repo clone:*), Bash(pwd:*)
model: haiku
disable-model-invocation: true
---
Work out the full destination path first: current working directory (`pwd`) plus the folder it will create (the given folder name, or the repo's own name if none given). State that full path clearly before cloning — e.g. "This will clone into: /Users/you/current-folder/repo-name".

Then run `gh repo clone <owner/repo>` (or `git clone <URL>` if a full URL was given), into the given folder name if one was specified. Report the local path it actually cloned into.

Repo (and optional folder name): $ARGUMENTS
