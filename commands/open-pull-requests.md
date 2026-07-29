---
description: Open the PRs list page for this repo on GitHub in the browser
allowed-tools: Bash(git remote:*), Bash(open:*)
model: haiku
disable-model-invocation: true
---
Get the owner/repo from `git remote get-url origin`, build `https://github.com/<owner>/<repo>/pulls`, open it with `open <url>`. Report the URL too.
