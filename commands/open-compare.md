---
description: Open a compare/diff view between two branches on GitHub
argument-hint: [branch1...branch2, defaults to default-branch...current]
allowed-tools: Bash(git remote:*), Bash(git branch:*), Bash(git symbolic-ref:*), Bash(open:*)
model: haiku
disable-model-invocation: true
---
Get the owner/repo from `git remote get-url origin`. Use $ARGUMENTS as the branch range if given (format "branch1...branch2"), otherwise default to "`<default branch>`...`<current branch>`" (detect the default via `git symbolic-ref refs/remotes/origin/HEAD`, fall back to `main`). Build `https://github.com/<owner>/<repo>/compare/<range>` and open it with `open <url>`. Report the URL too.

Branches (optional, "a...b"): $ARGUMENTS
