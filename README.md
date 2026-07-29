# git-ops

Typed, per-turn git commands for [Claude Code](https://claude.com/claude-code) — real Create/Fix pickers before anything risky happens, so you never have to re-explain the flow.

Split out from [claude-ops](https://github.com/azharbinanwar/claude-ops) once the git-related command set grew large enough to be its own thing.

## Install

```
/plugin marketplace add azharbinanwar/git-ops
```

```
/plugin install git-ops@git-ops
```

Then `/reload-plugins`.

**Requires `gh` (GitHub CLI) installed and logged in** (`gh auth login`) — almost every command here shells out to `gh` or `git`, and the GitHub-facing ones (release, PR, issue, gist, fork, etc.) won't work without it.

Run `/help` anytime for the full cheat sheet below, in chat.

## Commands

| Command | What it does |
|---|---|
| `/commit-msg` | Short + detailed message from your real open changes, flags AI-artifact files worth excluding, never commits, no AI sign |
| `/commit-only` | Lists changes + message, then a real Commit/Fix-first picker — commits locally, never pushes |
| `/commit-and-push` | Same flow, but the picker's Commit & Push option pushes too |
| `/create-release` | Shows the version + release notes, then Create/Fix-first — actually creates the GitHub release |
| `/create-pr` | Detects the real default branch, checks for a duplicate PR, shows title/description, then Create/Fix-first — actually opens the PR |
| `/pr-desc` | PR title + description from the branch diff (doesn't open it) |

### Risky actions — real Create/Fix-first picker
| Command | What it does |
|---|---|
| `/ignore-fix <file>` | Adds to `.gitignore`, untracks it too (`git rm --cached`) if git already tracks it |
| `/undo-commit` | Undo the last commit, keep changes staged — like GitHub Desktop's Undo |
| `/merge-pr [number]` | Merge a PR — squash/rebase/merge choice |
| `/new-repo [name]` | Create a new GitHub repo — suggests a name, asks public/private |
| `/amend-msg <message>` | Change only the last commit's message, content untouched |
| `/new-gist <file>` | Create a gist from a file — suggests a description, asks public/secret |
| `/discard <file>` | Discard uncommitted changes to one file — this loses that work |
| `/squash <N>` | Squash the last N commits into one |
| `/clean-branches` | Delete local branches already merged into the default branch |
| `/close-pr [number]` | Close a PR without merging |
| `/close-issue <number>` | Close an issue with a closing comment |
| `/rename-branch <name>` | Rename the current branch, locally and on the remote |
| `/fork [owner/repo]` | Fork a repo and clone it locally |
| `/cherry-pick <commit>` | Bring one commit over from another branch |
| `/pull [branch]` | Safe pull — fetch + merge; if it could conflict, offers Pull anyway / Stash first / Cancel |
| `/pull-rebase [branch]` | Pull with rebase instead of merge — same Pull anyway / Stash first / Cancel choice |
| `/reset-hard` | Hard-reset local branch to exactly match remote — discards all local commits/changes, offers Reset anyway / Stash first / Cancel |
| `/merge-branch <branch>` | Merge one local branch into another — direct git merge, not a PR |
| `/approve-pr [number]` | Approve a PR, with an optional comment |
| `/create-issue [description]` | Describe a bug/feature, then Create/Fix-first — actually creates the issue |

### Everyday — quick, low-cost, no confirmation needed
| Command | What it does |
|---|---|
| `/stash <name>` | Stash your changes with a name |
| `/new-branch <description>` | Suggest a branch name, create + switch to it |
| `/unstage <file>` | Undo `git add` on one file, keeps the changes |
| `/pr-status` | List your open PRs with CI/review status |
| `/add-label-issue <number>` | Add labels to an issue, suggests likely ones |
| `/add-label-pr [number]` | Add labels to a PR, suggests likely ones |
| `/assign-issue <number> <username or "me">` | Assign an issue to yourself or another developer |
| `/assign-pr [number] <username or "me">` | Assign a PR to yourself or another developer |
| `/request-review <username>` | Request review from someone on the current PR |
| `/workflow-status` | Check the latest GitHub Actions runs' pass/fail |
| `/repo-info` | Quick stats: stars, open issues, open PRs, last release |
| `/mark-draft` | Convert an existing PR back to draft status |
| `/tags` | List all tags with dates |
| `/remote-url` | Print the remote URL |
| `/notifications` | Check unread GitHub notifications |
| `/open-repo` | Open this repo's GitHub page in the browser |
| `/open-pr` | Open the current branch's PR in the browser |
| `/open-pull-requests` | Open the PRs list page in the browser |
| `/open-issues` | Open the issues list page in the browser |
| `/open-actions` | Open the GitHub Actions/CI runs page in the browser |
| `/open-releases` | Open the releases page in the browser |
| `/open-compare [a...b]` | Open a compare/diff view between two branches |
| `/open-file <path>` | Open the current file, at the current line, on GitHub |
| `/view-issues` | List open issues (companion to `/pr-status`) |
| `/view-issue <number-or-text>` | View one issue's full details — by number or title search |
| `/view-pr <number-or-text>` | View one PR's full details — by number or title search |
| `/blame <file>` | Who last touched each line of a file, quickly |
| `/clone <repo>` | Clone a repo by `owner/repo` or URL — states the full destination path first |
| `/fetch` | Fetch the latest from remote — no merge, just shows what's new |
| `/review-pr <number>` | Check out a PR locally and show its diff, before deciding anything |

## License

MIT
