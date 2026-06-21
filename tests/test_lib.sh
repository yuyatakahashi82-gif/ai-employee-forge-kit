#!/usr/bin/env bash
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$DIR/tests/assert.sh"
. "$DIR/scripts/lib.sh"

# load_vars: forge.vars を読んで変数を export する
tmp="$(mktemp -d)"; printf 'OWNER_NAME=Test\nHERMES_HOME=%s/.hermes\n' "$tmp" > "$tmp/forge.vars"
load_vars "$tmp/forge.vars"
assert_eq "$OWNER_NAME" "Test" "load_vars sets OWNER_NAME"

# require_var: 未設定なら status 1
( unset MISSING_X; require_var MISSING_X ) ; assert_status 1

# idempotent_guard: 同じマーカーで2回目は status 1（スキップ）
m="$tmp/.done"
( idempotent_guard "$m" ) ; assert_status 0
( idempotent_guard "$m" ) ; assert_status 1

rm -rf "$tmp"
assert_summary
