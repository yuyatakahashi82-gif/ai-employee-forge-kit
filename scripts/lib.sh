#!/usr/bin/env bash
# ai-employee-forge 共有ヘルパー
log() { printf '[forge] %s\n' "$*"; }
require_var() { # $1=var name; 未設定/空なら 1
  local name="$1"; local val="${!name:-}"
  if [ -z "$val" ]; then log "missing required var: $name"; return 1; fi
}
load_vars() { # $1=path to forge.vars
  local f="$1"; [ -f "$f" ] || { log "vars file not found: $f"; return 1; }
  set -a; . "$f"; set +a
}
idempotent_guard() { # $1=marker file; 既に在れば 1（=スキップせよ）
  local m="$1"; if [ -e "$m" ]; then return 1; fi
  mkdir -p "$(dirname "$m")"; : > "$m"; return 0
}
