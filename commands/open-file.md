---
description: Open the current file, at the current line, on GitHub in the browser
argument-hint: [file path, optional :line]
allowed-tools: Bash(git remote:*), Bash(git branch:*), Bash(open:*)
model: haiku
effort: low
disable-model-invocation: true
---
Work out the file's path relative to the repo root, the current branch, and the remote's owner/repo from `git remote get-url origin`. Build the blob URL: `https://github.com/<owner>/<repo>/blob/<branch>/<path>#L<line>` (only add `#L<line>` if a line number was given or is obvious from context). Open it with `open <url>` (macOS). Report the URL too, in case it doesn't open automatically.

File (and optional line): $ARGUMENTS
