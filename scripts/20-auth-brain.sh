#!/usr/bin/env bash
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"; . "$DIR/scripts/lib.sh"
load_vars "${1:?usage: <forge.vars>}" || exit 1
HERMES_BIN="$HERMES_HOME/hermes-agent/venv/bin/hermes"
log "20 auth: 脳($BRAIN_PROVIDER)を owner 本人がログイン"
log " - ★owner が対象機のターミナルで 'hermes model' → 'OpenAI Codex' を選び ChatGPT(Plus) で OAuth ログイン"
log " - 別途 codex CLI は不要（hermes が直接 OAuth する）。fallback(grok等)は 'hermes fallback add'"
log "完了条件: hermes auth list に $BRAIN_PROVIDER credential、status の Model が set"
[ "${DRYRUN:-0}" = "1" ] && exit 0
require_var HERMES_HOME || exit 1
if "$HERMES_BIN" auth list 2>/dev/null | grep -qi "$BRAIN_PROVIDER"; then
  log "完了: $BRAIN_PROVIDER の credential を確認"
else
  log "未完了: owner が 'hermes model' で $BRAIN_PROVIDER のログインを実施（対話のため自動化不可）"; exit 1
fi
