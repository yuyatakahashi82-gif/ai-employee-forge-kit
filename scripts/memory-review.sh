#!/usr/bin/env bash
# メモリ棚卸し — 分身が学んだ内容(USER.md/MEMORY.md)を owner が確認する儀式。
# 公開(B/C)前 or 定期的に実行。誤り/不要/機微があれば手動編集 or 'hermes memory' で整理。読み取り専用。
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"; . "$DIR/scripts/lib.sh"
load_vars "${1:?usage: $0 <forge.vars>}" || exit 1
MEM="$HERMES_HOME/memories"
log "memory-review: 分身が学んだ内容（公開前/定期の棚卸し用）"
for f in USER.md MEMORY.md; do
  if [ -f "$MEM/$f" ]; then
    log "──── $f （$(wc -l < "$MEM/$f" 2>/dev/null | tr -d ' ') 行）────"
    cat "$MEM/$f"
  else
    log "$f: まだ未生成（数ターン会話後に生成される）"
  fi
done
log "──────"
log "誤り/不要/機微があれば該当ファイルを手動編集、または 'hermes memory' で整理。owner が分身を対外公開(B/C)する前は必ず一度確認すること。"
