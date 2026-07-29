---
description: Show the git-ops cheat sheet — all commands at a glance
model: haiku
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
| /ignore-fix | Add to .gitignore, untrack if already tracked |
| /init-gitignore | New project: detect stack, show tracked/ignored, one confirm |
| /undo-commit | Undo last commit, keep changes staged |
| /merge-pr | Merge a PR — squash/rebase/merge choice |
| /create-repo | Name + visibility picked first, then confirm details, then create |
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
| /new-branch | Suggest a name, create + switch |
| /unstage | Undo git add on one file |
| /pr-status | List your open PRs + CI/review status |
| /add-label-issue | Add labels to an issue |
| /add-label-pr | Add labels to a PR |
| /assign-issue | Assign an issue to yourself or another developer |
| /assign-pr | Assign a PR to yourself or another developer |
| /request-review | Request review from someone |
| /workflow-status | Latest GitHub Actions pass/fail |
| /repo-info | Stars, open issues/PRs, last release |
| /mark-draft | Convert an existing PR back to draft |
| /tags | List all tags with dates |
| /remote-url | Print the remote URL |
| /notifications | Check unread GitHub notifications |
| /open-repo | Open the repo's GitHub page |
| /open-pr | Open the current branch's PR |
| /open-pull-requests | Open the PRs list page |
| /open-issues | Open the issues list page |
| /open-actions | Open the Actions/CI runs page |
| /open-releases | Open the releases page |
| /open-compare | Open a branch compare/diff view |
| /open-file | Open current file+line on GitHub |
| /view-issues | List open issues |
| /view-issue | View one issue in full — by number or title search |
| /view-pr | View one PR in full — by number or title search |
| /blame | Who last touched each line of a file |
| /clone | Clone a repo — states destination first |
| /fetch | Fetch only, no merge, shows what's new |
| /review-pr | Check out a PR + show its diff |
