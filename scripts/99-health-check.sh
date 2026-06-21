#!/usr/bin/env bash
# 健全性セルフチェック — 構築後の運用で随時実行（不調時/定期）。読み取り専用。
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"; . "$DIR/scripts/lib.sh"
load_vars "${1:?usage: $0 <forge.vars>}" || exit 1
HERMES_BIN="$HERMES_HOME/hermes-agent/venv/bin/hermes"
issues=0
ok() { log "  ✓ $1"; }
ng() { log "  ✗ $1"; issues=$((issues+1)); }
log "health-check: AI社員の健全性を確認"
[ -x "$HERMES_BIN" ] && ok "hermes 実行可能" || ng "hermes 実行可能（10-install 未完?）"
"$HERMES_BIN" auth list 2>/dev/null | grep -qi "$BRAIN_PROVIDER" && ok "脳($BRAIN_PROVIDER)の credential" || ng "脳の credential（20-auth 未完?）"
pgrep -f "gateway run" >/dev/null 2>&1 && ok "gateway 稼働" || ng "gateway 停止（再起動.command 推奨）"
tail -50 "$HERMES_HOME/logs/gateway.log" 2>/dev/null | grep -q "discord connected" && ok "Discord 接続" || ng "Discord 未接続"
[ -f "$HERMES_HOME/SOUL.md" ] && ok "SOUL.md(人格) 配置" || ng "SOUL.md 未配置（40-persona 未完?）"
v="$(grep '^DISCORD_ALLOWED_USERS=' "$HERMES_HOME/.env" 2>/dev/null | head -1 | cut -d= -f2-)"
if [ -z "$v" ]; then ng "DISCORD_ALLOWED_USERS 未設定（未認可になる）"
elif printf '%s' "$v" | grep -qE '[^0-9,[:space:]]'; then ng "DISCORD_ALLOWED_USERS が数値IDでない($v)→未認可"
else ok "DISCORD_ALLOWED_USERS 数値ID"; fi
log "（詳細診断は '$HERMES_BIN doctor' を実行）"
if [ "$issues" = 0 ]; then log "health-check OK（問題なし）"; exit 0; else log "health-check: $issues 件の ✗。↑を確認（デスクトップの『Hermes不調サポート.md』も参照）"; exit 1; fi
