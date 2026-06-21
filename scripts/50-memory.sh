#!/usr/bin/env bash
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"; . "$DIR/scripts/lib.sh"
load_vars "${1:?usage: <forge.vars>}" || exit 1
HERMES_BIN="$HERMES_HOME/hermes-agent/venv/bin/hermes"
log "50 memory: Hermes ネイティブ memory を設定"
log " - hermes config set memory.write_approval $MEMORY_WRITE_APPROVAL / memory.user_profile_enabled $MEMORY_USER_PROFILE"
log "完了条件: hermes config の memory が上記値"
[ "${DRYRUN:-0}" = "1" ] && exit 0
require_var HERMES_HOME || exit 1
"$HERMES_BIN" config set memory.write_approval "$MEMORY_WRITE_APPROVAL" >/dev/null 2>&1
"$HERMES_BIN" config set memory.user_profile_enabled "$MEMORY_USER_PROFILE" >/dev/null 2>&1
log "完了: memory 設定（write_approval=$MEMORY_WRITE_APPROVAL / user_profile=$MEMORY_USER_PROFILE）"
