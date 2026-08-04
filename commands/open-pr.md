---
description: Open a PR in the browser — by number, or the current branch's PR if none given
argument-hint: [optional: PR number]
allowed-tools: Bash(bash:*), Bash(gh pr view:*)
model: haiku
effort: low
disable-model-invocation: true
---
- Opened (when a number was given): !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/open.sh" pr $ARGUMENTS`

If the line above shows a URL, report it in one line — done, run nothing. If it shows "error: PR number required" (no number was given), run `gh pr view --web` for the current branch's PR instead; if there's no PR for this branch, say so in one line.

PR number (optional): $ARGUMENTS
