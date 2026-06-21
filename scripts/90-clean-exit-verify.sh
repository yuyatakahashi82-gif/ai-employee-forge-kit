#!/usr/bin/env bash
# owner専属チェック: 構築者の痕跡が HERMES_HOME に残っていないか検査。
# exit 0=clean / 1=設定不備 / 2=痕跡検出
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$DIR/scripts/lib.sh"
load_vars "${1:?usage: 90-clean-exit-verify.sh <forge.vars>}" || exit 1
require_var BUILDER_FORBIDDEN_PATTERNS || exit 1
require_var HERMES_HOME || exit 1

hits="$(grep -rIlE "$BUILDER_FORBIDDEN_PATTERNS" "$HERMES_HOME" 2>/dev/null || true)"
if [ -n "$hits" ]; then
  log "DETECTED builder traces in:"; printf '  %s\n' $hits
  exit 2
fi
# 段階別: auth.json は owner 名義ログインのみか（名前痕跡=hard fail / OAuth以外=要目視）
AUTH="$HERMES_HOME/auth.json"
if [ -f "$AUTH" ]; then
  if grep -IlE "$BUILDER_FORBIDDEN_PATTERNS" "$AUTH" >/dev/null 2>&1; then
    log "DETECTED builder traces in auth.json"; exit 2
  fi
  log "確認(要目視): auth.json の credential が owner 本人のログインか確認してください:"
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$AUTH" <<'PY' 2>/dev/null || log "  (auth.json をパースできません。中身を目視確認)"
import json,sys
d=json.load(open(sys.argv[1]))
cp=d.get("credential_pool",{}) or {}
prov=d.get("providers",{}) or {}
names=set(list(cp.keys()) + (list(prov.keys()) if isinstance(prov,dict) else []))
for n in sorted(names):
    entries=cp.get(n,[]) if isinstance(cp.get(n),list) else []
    oauth=any(isinstance(e,dict) and e.get("access_token") for e in entries)
    print(f"  - {n}: {'OAuthログイン' if oauth else '要確認(非OAuth/APIキーの可能性)'}")
PY
  fi
fi
# 構築者の一時 SSH 鍵チェック（鍵に owner名が無いと grep で拾えないので明示）
AK="$HOME/.ssh/authorized_keys"
if [ -f "$AK" ] && grep -q '[^[:space:]]' "$AK" 2>/dev/null; then
  log "確認(要目視): authorized_keys に構築者の一時鍵が残っていないか:"
  awk '{print "  - "$1" "substr($2,1,16)"..."}' "$AK" 2>/dev/null | head
  log "  構築者の鍵があれば削除し、対象機のリモートログインを OFF にすること"
fi
# DISCORD_ALLOWED_USERS が数値IDか（username だと未認可になる）
HENV="$HERMES_HOME/.env"
if [ -f "$HENV" ]; then
  v="$(grep '^DISCORD_ALLOWED_USERS=' "$HENV" 2>/dev/null | head -1 | cut -d= -f2-)"
  if [ -n "$v" ] && printf '%s' "$v" | grep -qE '[^0-9,[:space:]]'; then
    log "WARN: DISCORD_ALLOWED_USERS が数値IDでない('$v')→ username は未認可になる。数値IDに直す"
  fi
fi
log "clean-exit OK: no builder traces under $HERMES_HOME"
exit 0
