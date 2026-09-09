---
description: Invite a collaborator to this repo by username or email — resolves email, permission picker, confirm before inviting
argument-hint: "<github username or email> [permission: pull/triage/push/maintain/admin]"
allowed-tools: Bash(bash:*), Bash(gh api:*), Bash(gh repo view:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Repo: !`gh repo view --json nameWithOwner,isPrivate --jq '"\(.nameWithOwner) (\(if .isPrivate then "private" else "public" end))"' 2>&1 || true`
- Existing collaborators: !`gh api 'repos/{owner}/{repo}/collaborators' --jq '.[].login' 2>/dev/null | head -15 || true`
- Pending invites: !`gh api 'repos/{owner}/{repo}/invitations' --jq '.[].invitee.login' 2>/dev/null || true`
- Suggestions: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/suggest.sh" add-collaborator`

## Task
If $ARGUMENTS gives no username or email, ask for one in one line and stop.

Resolve who to invite:
- No `@` in it → it's a username, use as-is.
- Contains `@` → it's an email: run `gh api 'search/users?q=<email> in:email' --jq '.items[].login'` once. Exactly one match → use that username, and show both (email → resolved username) so the user can verify it's the right person. Zero or multiple matches → say the email can't be resolved (GitHub only finds public emails) and ask for the username instead; stop.

If the resolved username is already in "Existing collaborators" or "Pending invites" above, say so and stop — nothing to send.

Permission: use the one from $ARGUMENTS if given (pull/triage/push/maintain/admin), otherwise default to `push`.

Show the plan clearly:
```
Repo:       <nameWithOwner>
Invite:     <username> (resolved from <email>, if applicable)
Permission: <permission>
```
Then present two options via the option-picker tool (never plain text):
- **Send invite** — runs `gh api -X PUT 'repos/{owner}/{repo}/collaborators/<username>' -f permission=<permission>` once. The person gets a GitHub invitation email they must accept. Report the result.
- **Fix something first** — ends the turn immediately, nothing sent. A typed correction (different user, different permission) = the fix: apply it, then re-show the plan with this picker.

After the action completes successfully, end your output by reproducing the "Suggestions" block above verbatim (omit it entirely if empty, and omit it when the action failed or was cancelled).

Username or email (optional): $ARGUMENTS
