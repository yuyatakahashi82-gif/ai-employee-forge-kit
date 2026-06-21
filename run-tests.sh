#!/usr/bin/env bash
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
rc=0
for t in "$DIR"/tests/test_*.sh; do
  echo "== $(basename "$t") =="
  bash "$t" || rc=1
done
exit $rc
