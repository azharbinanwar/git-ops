---
description: Request review on the current branch's PR — pick reviewers from the collaborator list
argument-hint: [optional: github username(s), comma-separated]
allowed-tools: Bash(gh pr edit:*), Bash(gh pr view:*), Bash(gh api:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- PR for this branch: !`gh pr view --json number,title,url --jq '"#\(.number) \(.title) \(.url)"' 2>/dev/null || echo "none"`
- Collaborators: !`gh api 'repos/{owner}/{repo}/collaborators' --jq '.[].login' 2>/dev/null | head -15 || true`

## Task
If "PR for this branch" above is "none", say there's no PR for this branch (suggest `/create-pr`) and stop.

If $ARGUMENTS names one or more usernames, use them directly. Otherwise present the Collaborators from Context as a real option-picker (multi-select — several can be picked at once); if the collaborator list is empty, ask for a username in one line instead.

Run `gh pr edit --add-reviewer <user1,user2,...>` once with all picked names. Report who was requested on which PR. The Context above is the only data needed — run nothing else to gather.

Reviewer(s) (optional): $ARGUMENTS
