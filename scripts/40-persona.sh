#!/usr/bin/env bash
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"; . "$DIR/scripts/lib.sh"
load_vars "${1:?usage: <forge.vars>}" || exit 1
SOUL="$HERMES_HOME/SOUL.md"
log "40 persona: $PERSONA_TYPE を Hermes の SOUL.md に配置"
log " - templates/soul.md.tmpl を展開し \$HERMES_HOME/SOUL.md へ（実体は persona_prompt_file でなく SOUL.md）"
log "完了条件: \$HERMES_HOME/SOUL.md が存在し owner 名を含む"
[ "${DRYRUN:-0}" = "1" ] && exit 0
require_var HERMES_HOME || exit 1
mkdir -p "$HERMES_HOME"
sed "s/{{OWNER_NAME}}/$OWNER_NAME/g" "$DIR/templates/soul.md.tmpl" > "$SOUL"
if [ -f "$SOUL" ] && grep -q "$OWNER_NAME" "$SOUL"; then log "完了: SOUL.md 配置を確認"; else log "FAIL: SOUL.md 未配置"; exit 1; fi
