#!/usr/bin/env bash
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"; . "$DIR/scripts/lib.sh"
load_vars "${1:?usage: <forge.vars>}" || exit 1
HERMES_BIN="$HERMES_HOME/hermes-agent/venv/bin/hermes"
log "10 install: Hermes(Nous OSS) を $HERMES_HOME に導入"
log " - 前提: Xcode CLT（無ければ xcode-select --install を先に）"
log " - git clone https://github.com/NousResearch/hermes-agent → ./setup-hermes.sh（uvでPython3.11 venv）"
log "完了条件: hermes version が返る（\$HERMES_HOME/hermes-agent/venv/bin/hermes version）"
[ "${DRYRUN:-0}" = "1" ] && exit 0
require_var HERMES_HOME || exit 1
xcode-select -p >/dev/null 2>&1 || { log "FAIL: Xcode CLT 未導入。先に 'xcode-select --install' を実行"; exit 1; }
if [ ! -d "$HERMES_HOME/hermes-agent/.git" ]; then
  mkdir -p "$HERMES_HOME"
  git clone --depth 1 https://github.com/NousResearch/hermes-agent "$HERMES_HOME/hermes-agent" || { log "FAIL: clone"; exit 1; }
else
  log "既に clone 済み(skip)"
fi
( cd "$HERMES_HOME/hermes-agent" && yes n | ./setup-hermes.sh ) || log "WARN: setup 非ゼロ終了→version で確認"
if "$HERMES_BIN" version >/dev/null 2>&1; then
  log "完了: $("$HERMES_BIN" version 2>/dev/null | head -1)"
else
  log "FAIL: hermes version が返らない"; exit 1
fi
