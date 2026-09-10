---
description: Invite a collaborator to this repo by username or email — resolves email, permission picker, confirm before inviting
argument-hint: "<github username or email> [permission: pull/triage/push/maintain/admin]"
allowed-tools: Bash(bash:*), Bash(gh api:*), Bash(gh repo view:*)
model: haiku
effort: low
disable-model-invocation: true
---
## Context
- Repo: !`gh repo view --json nameWithOwner,isPrivate,isInOrganization --jq '"\(.nameWithOwner) (\(if .isPrivate then "private" else "public" end), \(if .isInOrganization then "org repo — roles apply" else "personal repo — no role choice, collaborators get write access" end))"' 2>&1 || true`
- Existing collaborators: !`gh api 'repos/{owner}/{repo}/collaborators' --jq '.[].login' 2>/dev/null | head -15 || true`
- Pending invites: !`gh api 'repos/{owner}/{repo}/invitations' --jq '.[].invitee.login' 2>/dev/null || true`
- Suggestions: !`bash "${CLAUDE_PLUGIN_ROOT}/scripts/suggest.sh" add-collaborator`

## Task
If $ARGUMENTS gives no username or email, show this usage hint and stop:
```
Who should I invite? Give a GitHub username or an email.
  /git-ops:add-collaborator <username>
  /git-ops:add-collaborator <email>            (works only if their email is public on GitHub)
  /git-ops:add-collaborator <username> <role>  (role picked via menu when repo supports it)
```
Follow it with the "Existing collaborators" from Context (one line: `Already in: <names>`) so the user knows who's there.

Resolve who to invite:
- No `@` in it → it's a username: validate it exists with `gh api 'users/<name>' --jq '"\(.login) | \(.type) | \(.name // "") | \(.location // "") | \(.public_repos) repos | joined \(.created_at[:10]) | \(.html_url)"'` once. Not found → say no GitHub account by that name exists, suggest checking the spelling, ask for the exact username or email, and stop — never show the invite picker for an unverified name. If type is Organization → say an organization can't be invited as a collaborator and stop.
- Contains `@` → it's an email: run `gh api 'search/users?q=<email> in:email' --jq '.items[].login'` once. Exactly one match → use that username, and show both (email → resolved username) so the user can verify it's the right person. Zero or multiple matches → say the email can't be resolved (GitHub only finds public emails) and ask for the username instead; stop.

If the resolved username is already in "Existing collaborators" or "Pending invites" above, say so and stop — nothing to send.

Permission — only when "Repo" above says org repo (personal repos don't support role choice: every collaborator gets write access, so never show a role picker or a Permission line there, and never pass a permission to the API). On an org repo: use the role from $ARGUMENTS if given (pull/triage/push/maintain/admin); if none was given, present a real option-picker (never plain text) before the confirm step:
- **Push (Recommended)** — clone, branch, and push; the normal collaborator role
- **Pull** — read-only: clone and view
- **Triage** — manage issues and PRs, no code write
- **Maintain** — push plus repo settings except destructive/sensitive ones
- **Admin** — full control including settings, collaborators, deletion

Show the plan clearly:
```
Repo:       <nameWithOwner>
Invite:     <username> (resolved from <email>, if applicable)
Who:        <name> · <location> · <N> repos · joined <year-month> — skip any empty field; omit the line only if all are empty
Profile:    <html_url>
Permission: <permission>          <- org repos only; omit the line on a personal repo
```
Then present two options via the option-picker tool (never plain text):
- **Send invite** — runs `gh api -X PUT 'repos/{owner}/{repo}/collaborators/<username>' --jq '"invited: \(.invitee.login) — \(.permissions) (\(.html_url))"'` once, appending `-f permission=<permission>` only on an org repo (the --jq keeps the response to one line; a 204/empty response means they were added directly with no invite step). Report exactly one line — `Invite sent: <username> → <repo> (pending acceptance)` — nothing more; no explanation of how GitHub invitations work.
- **Fix something first** — ends the turn immediately, nothing sent. A typed correction (different user, different permission) = the fix: apply it, then re-show the plan with this picker.

After the action completes successfully, end your output by reproducing the "Suggestions" block above verbatim. Omit it entirely — silently, never mentioning it — if it is empty, shows an error, or failed to load, and when the action failed or was cancelled.

Username or email (optional): $ARGUMENTS
