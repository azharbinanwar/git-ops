#!/bin/bash
# resolve-user.sh <username-or-email> — one bounded lookup, one answer line:
#   user: <login> | <type> | name:<..> | bio:<..> | loc:<..> | <n> repos | <n> followers | joined <date>
#   none: <reason>        (unresolvable — the command asks for the username)
#   error: <reason>       (lookup failed — the command asks for the username, no retries)
set -uo pipefail

q="${1:-}"
[ -n "$q" ] || { echo "none: no username or email given"; exit 0; }

# portable time limit (macOS has no timeout(1))
bounded() { "$@" & pid=$!; ( sleep 15; kill "$pid" 2>/dev/null ) & w=$!; wait "$pid"; rc=$?; kill "$w" 2>/dev/null; return $rc; }

login="$q"
if [ "${q#*@}" != "$q" ]; then
  out=$(bounded gh api -X GET search/users -f q="$q in:email" --jq '.items[].login' 2>&1) || { echo "error: email lookup failed or timed out"; exit 0; }
  n=$(printf '%s\n' "$out" | grep -c . || true)
  [ "$n" = 1 ] || { echo "none: $q matches $n accounts (GitHub only finds public emails)"; exit 0; }
  login="$out"
fi

info=$(bounded gh api "users/$login" --jq '"user: \(.login) | \(.type) | name:\(.name // "") | bio:\(.bio // "" | gsub("\n";" ")) | loc:\(.location // "") | \(.public_repos) repos | \(.followers) followers | joined \(.created_at[:10])"' 2>&1) \
  || { case "$info" in *"Not Found"*) echo "none: no GitHub account named $login";; *) echo "error: user lookup failed or timed out";; esac; exit 0; }
echo "$info"
