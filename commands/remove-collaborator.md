---
description: Remove a collaborator or cancel a pending invite — pick who, consequences stated, confirm before removal
argument-hint: "[github username, or nothing to pick from the list]"
allowed-tools: Bash(bash:*), Bash(gh api:*), Bash(gh repo view:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Repo: !`gh repo view --json nameWithOwner --jq .nameWithOwner 2>&1 || true`
- Collaborators: !`gh api 'repos/{owner}/{repo}/collaborators' --jq '.[] | "\(.login) | \(.role_name) | active"' 2>/dev/null || true`
- Pending invites: !`gh api 'repos/{owner}/{repo}/invitations' --jq '.[] | "\(.invitee.login) | id:\(.id) | pending"' 2>/dev/null || true`
- Suggestions: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/suggest.sh" remove-collaborator`

## Task
Build the candidate list from Context above (active collaborators + pending invites, never the repo owner). If it's empty, say there's nobody to remove and stop.

If $ARGUMENTS names someone, match them in the list (not there → say so and stop). Otherwise present the list as a real option-picker — each option label is the username, its description the permission and active/pending status.

Then confirm with a second picker (never plain text):
- **Remove** — for an active collaborator: runs `gh api -X DELETE 'repos/{owner}/{repo}/collaborators/<username>'` — the description must state they lose access immediately, though existing clones and forks they made remain theirs. For a pending invite: runs `gh api -X DELETE 'repos/{owner}/{repo}/invitations/<id>'` — the description says the invite is cancelled before acceptance. Report the result.
- **Cancel** — ends the turn immediately, nothing removed.

After the action completes successfully, end your output by reproducing the "Suggestions" block above verbatim (omit it entirely if empty, and omit it when the action failed or was cancelled).

Username (optional): $ARGUMENTS
