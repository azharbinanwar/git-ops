---
description: Show the git-ops cheat sheet — all commands at a glance
model: haiku
effort: low
disable-model-invocation: true
---
Output exactly this table, nothing else:

**Basics**
| Command | Use when you want |
|---|---|
| /commit-msg | Short + detailed message from open changes, never commits |
| /commit-only | List + message + Commit/Fix picker — commits, no push |
| /commit-and-push | Same, but Commit & Push actually pushes too |
| /create-release | Version + notes + Create/Fix picker — creates the release |
| /create-pr | Detects default branch + dup check + Create/Fix picker |
| /pr-desc | PR title + description only, doesn't open it |

**Risky — real Create/Fix (or 3-way) picker first**
| Command | Use when you want |
|---|---|
| /add-to-ignore | Add a file/folder — pick .gitignore vs .git/info/exclude, untracks if already tracked |
| /refresh-ignore | Re-check existing ignore rules against tracked files, untrack new matches |
| /init-gitignore | New project: detect stack, show tracked/ignored, one confirm |
| /undo-commit | Undo last commit, keep changes staged |
| /revert-commit | Safe undo for a pushed commit — opposite commit, history intact |
| /update-branch | Bring the default branch's latest into yours — merge or rebase |
| /delete-branch | Delete one branch — local only (default) or local + remote |
| /change-visibility | Make the repo public/private — consequences shown first |
| /merge-pr | Merge a PR — squash/rebase/merge choice |
| /create-repo | Name + visibility, create, then separate yes/no on wiring remote — never pushes |
| /add-remote | Connect this folder to an existing GitHub repo |
| /amend-msg | Change only the last commit's message |
| /create-gist | Create a gist from a file |
| /view-gists | List your gists |
| /view-gist | View one gist's full content, by ID |
| /discard | Discard uncommitted changes to one file |
| /squash | Squash the last N commits into one |
| /clean-branches | Delete local branches already merged |
| /close-pr | Close a PR without merging |
| /close-issue | Close an issue with a comment |
| /rename-branch | Rename current branch, locally + remote |
| /fork | Fork a repo and clone it |
| /cherry-pick | Bring one commit from another branch |
| /pull | Safe pull — Pull anyway / Stash first / Cancel |
| /pull-rebase | Same, but rebase instead of merge |
| /reset-hard | Hard-reset to remote — discards local work |
| /merge-branch | Merge one local branch into another |
| /approve-pr | Approve a PR, with an optional comment |
| /create-issue | Describe a bug/feature, Create/Fix picker — actually creates it |

**Everyday — quick, low-cost, no confirmation**
| Command | Use when you want |
|---|---|
| /stash | Stash changes with a name |
| /view-stashes | List all stashes with names + age |
| /pop-stash | Pick a stash, restore it — pop or apply |
| /create-branch | Suggest a name, create + switch |
| /checkout-branch | Pick a branch from a list, switch safely |
| /view-prs | List ALL open PRs (any author) with CI/review |
| /unstage | Undo git add on one file |
| /pr-status | List your open PRs + CI/review status |
| /add-label-issue | Add labels to an issue |
| /add-label-pr | Add labels to a PR |
| /assign-issue | Assign an issue to yourself or another developer |
| /assign-pr | Assign a PR to yourself or another developer |
| /request-review | Request review from someone |
| /view-actions | Latest GitHub Actions pass/fail (pairs with /open-actions) |
| /repo-info | Stars, open issues/PRs, last release |
| /mark-draft | Convert an existing PR back to draft |
| /view-tags | List all tags with dates (pairs with /open-tags) |
| /remote-url | Print the remote URL |
| /view-notifications | Unread GitHub notifications (pairs with /open-notifications) |
| /open-repo | Open the repo's GitHub page |
| /open-pr | Open the current branch's PR |
| /open-pull-requests | Open the PRs list page |
| /open-issues | Open the issues list page |
| /open-actions | Open the Actions/CI runs page |
| /open-releases | Open the releases page |
| /open-tags | Open the tags page |
| /open-notifications | Open your notifications |
| /open-issue | Open one issue, by number |
| /open-gist | Open one gist, by id |
| /open-commit | Open one commit's diff, by hash |
| /open-file-history | Open a file's commit history |
| /view-releases | List releases here in chat, with total count |
| /open-compare | Open a branch compare/diff view |
| /open-file | Open current file+line on GitHub |
| /view-issues | List open issues |
| /view-issue | View one issue in full — by number or title search |
| /view-pr | View one PR in full — by number or title search |
| /blame | Who last touched each line of a file |
| /clone | Clone a repo — states destination first |
| /fetch | Fetch only, no merge, shows what's new |
| /review-pr | Check out a PR + show its diff |
