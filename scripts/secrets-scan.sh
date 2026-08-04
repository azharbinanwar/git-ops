#!/bin/bash
# secrets-scan.sh — flag files `git add -A` would stage that may hold secrets.
# [secret] = stop and think. [review] = gray zone, confirm intended.
# Filename-based (fast, no deps); if gitleaks is installed, its content scan
# is appended for professional-grade coverage.
set -uo pipefail

git rev-parse --git-dir >/dev/null 2>&1 || { echo "none found."; exit 0; }

files=$(
  { git ls-files --others --exclude-standard 2>/dev/null
    git diff --name-only HEAD 2>/dev/null
    git diff --cached --name-only 2>/dev/null; } | sort -u
)

rows=""
add_row() { rows="$rows$(printf '[%s]  %-48s %-26s -> %s' "$1" "$2" "$3" "$4")
"; }

while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$f" in
    # safe-by-convention templates — never flag
    *.env.example|*.env.sample|*.env.template|.env.example|.env.sample|.env.template) : ;;
    *local.properties|*keystore.properties)      add_row secret "$f" "Android SDK/signing config" "add to .gitignore" ;;
    *.keystore|*.jks)                            add_row secret "$f" "signing key"               "exclude; rotate if pushed" ;;
    *.pem|*.p12|*.pfx|*.p8|*.der|*.key)          add_row secret "$f" "private key/certificate"   "exclude; rotate if pushed" ;;
    *id_rsa*|*id_ed25519*|*id_ecdsa*|*id_dsa*)   add_row secret "$f" "SSH private key"           "exclude; rotate if pushed" ;;
    .env|.env.*|*/.env|*/.env.*)                 add_row secret "$f" "environment secrets"       "add to .gitignore" ;;
    *credentials.json|*service-account*.json|*serviceAccountKey*.json) add_row secret "$f" "service credentials" "exclude; rotate if pushed" ;;
    .netrc|_netrc|*/.netrc|*/_netrc)             add_row secret "$f" "login credentials"         "exclude; rotate if pushed" ;;
    .pypirc|*/.pypirc)                           add_row secret "$f" "package registry token"    "exclude; rotate if pushed" ;;
    .htpasswd|*/.htpasswd)                       add_row secret "$f" "password hashes"           "exclude" ;;
    *secrets.yaml|*secrets.yml|*secrets.json|*secrets.properties) add_row secret "$f" "secrets file" "exclude; rotate if pushed" ;;
    kubeconfig|*/kubeconfig|*.kubeconfig)        add_row secret "$f" "cluster credentials"       "exclude; rotate if pushed" ;;
    .dockercfg|*/.dockercfg|*/docker/config.json) add_row secret "$f" "registry auth tokens"     "exclude; rotate if pushed" ;;
    *.tfvars|*.tfvars.json)                      add_row review "$f" "terraform vars, often secret" "confirm intended" ;;
    .npmrc|*/.npmrc)                             add_row review "$f" "may contain auth token"    "confirm intended" ;;
    *google-services.json|*GoogleService-Info.plist) add_row review "$f" "Firebase client config" "confirm intended" ;;
  esac
done <<< "$files"

# content-level scan when gitleaks is installed (newer `dir`, older `detect` syntax)
# ponytail: full-dir scan — scope to changed files if it ever feels slow
gl=""
if command -v gitleaks >/dev/null 2>&1; then
  n=$( { gitleaks dir . --no-banner --exit-code 0 --report-path /dev/stdout --report-format csv 2>/dev/null \
      || gitleaks detect --source . --no-git --no-banner --exit-code 0 --report-path /dev/stdout --report-format csv 2>/dev/null; } \
      | tail -n +2 | grep -c . ) || n=0
  [ "${n:-0}" -gt 0 ] && gl="[gitleaks] $n potential secret(s) inside file contents — run: gitleaks dir . -v"
fi

if [ -z "$rows" ] && [ -z "$gl" ]; then
  echo "none found."
  exit 0
fi
vis=$(gh repo view --json visibility -q .visibility 2>/dev/null || true)
[ "$vis" = "PUBLIC" ] && echo "repo is PUBLIC — these would be visible to everyone:"
[ -n "$rows" ] && printf '%s' "$rows"
[ -n "$gl" ] && echo "$gl"
exit 0
