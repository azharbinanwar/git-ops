#!/bin/bash
# change-list.sh [range] — pre-formatted change list for /create-pr context injection.
# ≤30 files: one labeled line each. More: counts per top-level folder, so the model
# never has to type (or pay for) hundreds of paths.
set -uo pipefail

range="${1:-origin/HEAD...HEAD}"
d=$(git diff --name-status "$range" 2>/dev/null)
[ -n "$d" ] || { echo "(no changes)"; exit 0; }
n=$(printf '%s\n' "$d" | wc -l | tr -d ' ')

if [ "$n" -le 30 ]; then
  printf '%s\n' "$d" | awk -F'\t' '{
    s=substr($1,1,1)
    if (s=="A")      print "Added:    " $2
    else if (s=="M") print "Modified: " $2
    else if (s=="D") print "Deleted:  " $2
    else if (s=="R") print "Renamed:  " $2 " -> " $3
    else if (s=="C") print "Copied:   " $2 " -> " $3
    else             print $1 ": " $2
  }'
else
  printf '%s\n' "$d" | awk -F'\t' '{
    p=$NF
    i=index(p,"/")
    k=(i ? substr(p,1,i) : p)
    c[k]++
  } END { for (k in c) printf "%s (%d files)\n", k, c[k] }' | sort
  echo "($n files total — grouped by top-level folder; per-file list on request)"
fi
