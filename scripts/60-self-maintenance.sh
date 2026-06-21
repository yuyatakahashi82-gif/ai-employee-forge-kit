#!/usr/bin/env bash
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"; . "$DIR/scripts/lib.sh"
load_vars "${1:?usage: <forge.vars>}" || exit 1
HERMES_BIN="$HERMES_HOME/hermes-agent/venv/bin/hermes"
DESK="$HOME/Desktop"
log "60 self-maintenance: $SELF_MAINTENANCE を仕込む"
log " - 層1: hermes gateway install（launchd KeepAlive・Label ai.hermes.gateway）"
log " - 層2: Desktop に 再起動.command / 層3: Desktop に サポートカンペ"
log "完了条件: launchd で gateway loaded ＋ Desktop に2ファイル"
[ "${DRYRUN:-0}" = "1" ] && exit 0
require_var HERMES_HOME || exit 1
"$HERMES_BIN" gateway install >/dev/null 2>&1 || log "WARN: gateway install 非ゼロ（既存かも）"
mkdir -p "$DESK"
sed -e "s/{{OWNER_NAME}}/$OWNER_NAME/g" -e "s#{{HERMES_HOME}}#$HERMES_HOME#g" "$DIR/templates/restart.command.tmpl" > "$DESK/Hermes再起動.command" && chmod +x "$DESK/Hermes再起動.command"
sed -e "s/{{OWNER_NAME}}/$OWNER_NAME/g" -e "s#{{HERMES_HOME}}#$HERMES_HOME#g" "$DIR/templates/support-primer.ja.md.tmpl" > "$DESK/Hermes不調サポート.md"
[ -x "$DESK/Hermes再起動.command" ] && [ -f "$DESK/Hermes不調サポート.md" ] && log "完了: 自己保守3層を設置" || { log "→ 次にやること: $HOME/Desktop の書き込み権限と templates/restart.command.tmpl の存在を確認"; log "FAIL: Desktop ファイル"; exit 1; }
