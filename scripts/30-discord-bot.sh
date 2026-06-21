#!/usr/bin/env bash
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"; . "$DIR/scripts/lib.sh"
load_vars "${1:?usage: <forge.vars>}" || exit 1
HERMES_BIN="$HERMES_HOME/hermes-agent/venv/bin/hermes"
VENV_PY="$HERMES_HOME/hermes-agent/venv/bin/python"
log "30 discord: bot 配線（$DISCORD_SERVER_VISIBILITY サーバー）"
log " - discord.py(messaging extra)を venv 導入 → owner が bot+server 作成(web) → hermes gateway setup(token)"
log " - ★許可は ~/.hermes/.env の DISCORD_ALLOWED_USERS に owner の【数値ID】(username は解決不可で未認可のまま)"
log " - require_mention=false(個人copilot) → hermes gateway install(launchd)"
log "完了条件: gateway.log に '✓ discord connected'、owner のプレーン送信に bot が応答"
[ "${DRYRUN:-0}" = "1" ] && exit 0
require_var HERMES_HOME || exit 1
# discord.py（messaging extra）を venv に導入（uv 製 venv は pip 無し→uv pip）
UV=""; for c in "$HOME/.local/bin/uv" "$HOME/.cargo/bin/uv" "$(command -v uv 2>/dev/null)"; do [ -x "$c" ] && UV="$c" && break; done
[ -z "$UV" ] && { log "→ 次にやること: 先に 10-install-hermes.sh を完了（uv は setup で導入される）"; log "FAIL: uv が見つからない"; exit 1; }
if ! "$VENV_PY" -c "import discord" >/dev/null 2>&1; then
  log "discord.py 導入中..."
  "$UV" pip install --python "$VENV_PY" -q "discord.py[voice]==2.7.1" "aiohttp==3.13.4" "brotlicffi==1.2.0.1" || { log "→ 次にやること: 'uv pip install --python $VENV_PY discord.py[voice]==2.7.1' を手動実行"; log "FAIL: discord.py 導入"; exit 1; }
fi
"$VENV_PY" -c "import discord" >/dev/null 2>&1 && log "discord.py OK" || { log "→ 次にやること: 'uv pip install --python $VENV_PY discord.py[voice]==2.7.1' を手動実行"; log "FAIL: discord import"; exit 1; }
log "── ここから owner 対話（自動化不可）──"
log "1) Discord Developer Portal で bot 作成。Bot→Privileged Intents の【MESSAGE CONTENT INTENT を ON】。token をコピー"
log "2) owner の $DISCORD_SERVER_VISIBILITY サーバー作成→OAuth2 URL Generator(scope=bot)で招待"
log "3) '$HERMES_BIN gateway setup' → Discord 選択 → token 貼付"
log "4) '$HERMES_BIN gateway install' で起動 → owner が一度サーバーで送信"
log "5) ★数値ID取得: 'tail ~/.hermes/logs/gateway.log' の【Unauthorized user: <ID>】の <ID> をコピー"
log "6) '~/.hermes/.env' に DISCORD_ALLOWED_USERS=<ID> を追記"
log "7) '$HERMES_BIN config set discord.require_mention false' → '$HERMES_BIN gateway restart'"
# 検証（可能な範囲）
"$HERMES_BIN" gateway status >/dev/null 2>&1 && log "gateway 設定あり（最終完了条件は owner の実応答で目視確認）"
