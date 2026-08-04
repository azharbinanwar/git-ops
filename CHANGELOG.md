# Changelog

## Unreleased

- Seven new/upgraded commands for everyday branch and PR work:
  - `/change-visibility` — flip the repo public/private with the consequences stated in the picker itself (private→public: all history becomes visible; public→private: stars/forks lost). `/repo-info` now shows current visibility.
  - `/checkout-branch` — pick from local + remote branches (recency-sorted, pre-injected) and switch, with the uncommitted-work guard.
  - `/view-prs` — ALL open PRs (any author) in the same 3-line format as `/pr-status`; `/pr-status` stays yours-only.
  - `/update-branch` — merge (recommended) or rebase the default branch into your feature branch; conflicts reported and stopped, never auto-resolved.
  - `/revert-commit` — the safe undo for pushed commits (opposite commit, history intact) — pairs with `/undo-commit`, which stays the unpushed-only tool.
  - `/delete-branch` — two pickers: which branch (merged/unmerged state shown in the option label), then scope — Local only (recommended, reversible) or Local + remote.
  - `/request-review` — reviewers now picked from the repo's collaborator list (multi-select) instead of requiring a typed username.
- `/create-pr` gains a third picker option: **Create as draft** (`--draft` through the same script).
- New offline test suite: `bash tests.sh` — 21 checks covering every bundled script (success paths, error paths, and a real push against a local bare repo, no network or GitHub needed). GitHub Actions runs it on Linux, macOS, and Windows on every push touching scripts. `.gitattributes` pins `*.sh` to LF line endings so Windows checkouts with autocrlf can't corrupt them.
- `/review-pr` now runs in a forked subagent context (`context: fork`) — the PR's full diff stays in the fork instead of permanently occupying the main conversation; only the review summary comes back.
- README: new "Fast and cheap by design" section with the measured numbers, and a "Judgment by model, mechanics by script" design principle.
- The approved step of `/commit-and-push`, `/commit-only`, `/create-pr`, and `/create-release` is now one deterministic script call (`scripts/<command-name>.sh`) instead of 3–5 improvised model commands. The model still does the judgment half — change list, AI check, message drafting, picker — then hands the approved text to the script via stdin. Measured A/B (commit-and-push execution half, real pushes): 4 turns → 2, output tokens −22%, and the dangerous flags (`--force`, `--no-verify`) no longer exist anywhere in the flow by construction. On failure (pre-commit hook rejection, non-fast-forward push) the script reports the exact error and stops; the success receipt lists every committed file (up to 20), so what went in is always visible even in the worst case.
- New **Secrets check** section in `/commit-and-push`, `/commit-only`, `/commit-msg`, and `/create-pr`: a pre-aligned report of files about to be staged that may hold secrets — `[secret]` for the real thing (`local.properties`, `.env`, keystores, private keys, service credentials) with a plain-words reason and action, `[review]` for gray-zone configs (`google-services.json`, `GoogleService-Info.plist`). When the repo is public, the section says so — "these would be visible to everyone." `Secrets check: none found.` when clean, so silence is also information. Coverage: ~25 filename patterns (SSH/TLS/signing keys, env files, cloud/registry/cluster credentials, secrets.* files, terraform vars) with `.env.example`-style templates explicitly never flagged — and if `gitleaks` is installed, its content-level scan (150+ rules) is appended to the same section automatically.
- New `scripts/untracked-scan.sh` feeds the three commit commands: untracked directories now appear in the Change list as `Added: dir/ (N files)` with a real count, and the AI check flags junk/secrets riding inside them (`build/`, `.gradle/`, `.idea/`, `node_modules/`, `local.properties`, keystores, `.env`, `.pem`). Counts and flags respect nested `.gitignore` files — only what `git add -A` would actually stage is counted, so ignored build output never triggers a false alarm.
- The four review sections of the commit commands are now mandatory on every invocation — a re-run in the same conversation re-shows them instead of jumping to the picker, since the working tree may have changed in between.
- `/stash` and `/unstage` are script-backed (measured: `/unstage` 5 turns → 1, output tokens −80%; `/stash` old flow stalled twice on permission checks headless, script version just works). `/stash` with no name now shows the open changes and offers a suggested kebab-case name instead of taking a conversational sentence literally. `/new-branch` pre-injects status and recent branch names, so naming style matching costs no extra lookups. `/fetch` deliberately unchanged — pre-running its network fetch measured slower in 1.4.0.
- `/merge-pr` pre-injects the PR summary, CI checks, and recent merge style — one model round-trip instead of 2–4.
- Command bodies compressed ~1,400 tokens across 29 files (repeated picker/correction boilerplate reworded, identical behavior) — invoked command text stays in context for the rest of a session, so this saves on every turn after any command runs.
- Six `/open-*` commands are now script-backed: a bundled `scripts/open.sh` builds the GitHub URL (ssh and https remotes both normalized) and opens it *before* the model starts — the model's only job is reporting the URL. Applies to `/open-repo`, `/open-pull-requests`, `/open-issues`, `/open-actions`, `/open-releases`, `/open-compare` (which keeps its `branch1...branch2` argument, defaulting to `default...current`). Measured A/B, 12 fresh sessions: output tokens −78% (3,542 → 793 total), every command exactly 1 turn (was 3–6), 3.2× faster (79.6s → 24.6s total), and 3 of 6 old commands failed headless permission checks mid-run while the script versions cannot — the script is the same single pre-approved call every time. `/open-pr` (needs `gh`) and `/open-file` (path/line handling) keep their model-driven flow.
- All 52 haiku-pinned commands now also set `effort: low` — mechanical flows (open pages, pull, stash, view lists) never warrant extended thinking, and the cap keeps sessions with always-thinking enabled from spending thinking tokens on them. Headless A/B measured neutral (headless runs don't think on these anyway); the cap targets interactive sessions.
- Pinned a model on every command that didn't have one (22 files): `model: haiku` on the 19 mechanical flows (`/pull`, `/discard`, `/undo-commit`, `/reset-hard`, `/merge-branch`, `/cherry-pick`, `/squash`, `/clean-branches`, `/amend-msg`, `/rename-branch`, `/add-remote`, `/create-repo`, `/create-gist`, `/fork`, `/close-pr`, `/close-issue`, `/approve-pr`, `/merge-pr`, `/pull-rebase`), `model: sonnet` on the three ignore commands that interpret paths and stacks (`/add-to-ignore`, `/init-gitignore`, `/refresh-ignore`). Every command now has a predictable cost instead of inheriting the session's (often much pricier) model.
- Commit flow slimmed — the same 14-file commit that measured ~5k tokens now targets ~3k:
  - `/commit-and-push`, `/commit-only`, `/commit-msg` no longer inject the changed-file list twice: the `--stat` context line is now `--shortstat` (totals only) since `git status --short` already carries every path.
  - Staging no longer retypes every path: the Change list is verified against `git status --short`, then staged with one `git add -A` (mismatch = stop and report). No `git status` re-run after staging — `git commit`'s own file count is the confirmation.
  - Commit body capped at ≤6 lines unless the diff truly demands more — the body is echoed twice (draft + heredoc), so length costs double.
- `/create-pr` context bounded: fetches only the current branch's PR (`gh pr list --head`) instead of every open PR in the repo, and caps the commit log and remote-branch lists at 20 entries each — trivial on small repos, real savings on a work repo with 40 open PRs.

## 1.4.0 — 2026-08-03

- 8 everyday commands rewritten to pre-run their git/gh command and inject the output before the model starts, instead of instructing the model to run it via a tool call: `/remote-url`, `/tags`, `/pr-status`, `/workflow-status`, `/repo-info`, `/notifications`, `/view-gists`, `/view-issues`. One model round-trip instead of 2–9, measured ~2× faster (A/B, 18 fresh sessions: total 88s → 48s, output tokens −48%, cached input reads −71%), and immune to mid-run permission stalls — the data is already in the prompt, so the model never has to ask to run anything. `/fetch` deliberately left as-is: its pre-run network fetch measured slower.
- `/tags` now uses a single `git tag --sort=-creatordate --format=...` call instead of one `git log` per tag (the old flow measured 9 turns / 26.9s on a 4-tag repo).
- `/create-pr`: target-branch picker now lists **remote** branches instead of local ones — a PR can only merge into a branch that exists on GitHub, so local-only branches were wrong to offer and remote-only ones (e.g. `main` never checked out locally) were wrongly missing.
- Pinned `model: sonnet` on all seven writing commands (`/commit-msg`, `/commit-only`, `/commit-and-push`, `/create-pr`, `/create-release`, `/pr-desc`, `/create-issue`) — drafting a commit message or PR description doesn't need the session's (often much pricier) model, and an explicit pin makes the cost predictable for every user.
- `/clone` redesigned: never clones into the current folder (nesting a repo inside the project you're working in is almost never wanted). Presents a real destination picker first — **Parent folder (Recommended)** / **Desktop**, full resolved paths shown, typed path accepted — then states the final path and clones with an explicit destination.

- `/create-repo`'s **Create** step no longer pushes or commits anything — it now only runs `gh repo create <name> --public/--private`, nothing else. Previously `--source=. --remote=origin --push` was used when the folder was already a git repo, which required an existing commit to push and led to an unrequested `git commit` being run just to make that work.
- New **Step 3**: after the repo is created, a separate Yes/No picker asks whether to wire up the local `origin` remote (`git init` if needed, then `git remote add`/`set-url`). Even choosing Yes only connects the remote — it never pushes. Pushing is always left to `/commit-and-push` or similar, run separately whenever the user is ready.
- Renamed `/ignore-fix` → `/add-to-ignore`, and it now presents a real picker (**Add to .gitignore** / **Add to .git/info/exclude** / Fix something first) instead of silently guessing which one the repo already relies on — `.git/info/exclude` is the right call for personal/tool-specific noise (e.g. AI-assistant working files) that shouldn't show up in the shared, committed `.gitignore`.
- New: `/refresh-ignore` — no argument, re-checks whatever's already in `.gitignore`/`.git/info/exclude` against currently tracked files and untracks anything that now matches, in one step. For when patterns were added earlier but tracking was never refreshed against them.

## 1.2.0 — 2026-07-29

- New: `/init-gitignore` — for a new project before the first commit: detects the stack (Node/Rust/Kotlin/Python/etc.), shows what will be ignored vs what's currently tracked that matches, one Apply writes `.gitignore` and untracks all matches together in a single step — never a separate follow-up call for the same setup

## 1.1.0 — 2026-07-29

- Renamed `/new-repo` → `/create-repo`, `/new-gist` → `/create-gist` — matches the `/create-*` naming used by everything else that actually creates something real (`/create-pr`, `/create-release`, `/create-issue`)
- `/create-repo` now bails out immediately if the current folder already has a git remote, instead of risking a conflicting `gh repo create --source=.`
- New: `/add-remote` — connects a local folder to an *existing* GitHub repo (adds or updates the `origin` remote), for when you already have a repo on GitHub and just need the local side wired up
- New: `/view-gists` (list), `/view-gist` (one, by ID) — this plugin is GitHub-only throughout (anything using `gh` won't work against Bitbucket/GitLab/etc.), worth noting explicitly in the README
- `/create-gist` no longer infers or asks public/secret as a separate plain-text question — visibility is now an explicit picker choice (**Create secret / Create public / Fix something first**)
- `/create-repo` redesigned as a two-step flow: Step 1 locks in the (never-blank) name and visibility via a picker; Step 2 shows those exact details back before a final Create/Fix-first picker — so you always see precisely what's about to be created before it happens

## 1.0.0 — 2026-07-29

First full release — 58 commands, organized into three tiers:

**Basics** (moved from claude-ops, unchanged): `/commit-msg`, `/commit-only`, `/commit-and-push`, `/create-release`, `/create-pr`, `/pr-desc`

**Risky — real Create/Fix (or 3-way) picker before anything happens**: `/create-issue`, `/ignore-fix`, `/undo-commit`, `/merge-pr`, `/new-repo`, `/amend-msg`, `/new-gist`, `/discard`, `/squash`, `/clean-branches`, `/close-pr`, `/close-issue`, `/rename-branch`, `/fork`, `/cherry-pick`, `/pull`, `/pull-rebase`, `/reset-hard`, `/merge-branch`, `/approve-pr`

**Everyday — quick, low-cost, no confirmation needed**: `/help`, `/stash`, `/new-branch`, `/unstage`, `/pr-status`, `/add-label-issue`, `/add-label-pr`, `/assign-issue`, `/assign-pr`, `/request-review`, `/workflow-status`, `/repo-info`, `/mark-draft`, `/tags`, `/remote-url`, `/notifications`, `/open-repo`, `/open-pr`, `/open-pull-requests`, `/open-issues`, `/open-actions`, `/open-releases`, `/open-compare`, `/open-file`, `/view-issues`, `/view-issue`, `/view-pr`, `/blame`, `/clone`, `/fetch`, `/review-pr`

Design decisions baked in from the start:
- No AI attribution anywhere — commits, releases, PRs, issues, gists, comments
- Risky/history-rewriting actions (`reset-hard`, `squash`, `amend-msg`, force-adjacent ones) always warn if already pushed, and always offer Stash-first where relevant
- Commands that could apply to either an issue or a PR are kept as separate commands (`/close-issue` vs `/close-pr`, `/assign-issue` vs `/assign-pr`, `/add-label-issue` vs `/add-label-pr`) rather than one auto-detecting command — no guessing, one direct `gh` call each
- Requires `gh` (GitHub CLI) installed and logged in for anything GitHub-facing
