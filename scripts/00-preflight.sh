#!/usr/bin/env bash
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"; . "$DIR/scripts/lib.sh"
load_vars "${1:?usage: <forge.vars>}" || exit 1
log "00 preflight: OS/ネットワーク/前提を確認"
log " - macOS とネット接続を確認、対象機のローカル名/IP を控える"
log " - Hermes 入手元（repo/pkg）と対象バージョンを確認"
log "完了条件: ネット疎通OK＋対象機のローカル名/IPを控えた"
[ "${DRYRUN:-0}" = "1" ] && exit 0
require_var HERMES_HOME || exit 1
uname -a; ping -c1 -t2 1.1.1.1 >/dev/null 2>&1 && log "network OK" || log "WARN: network未確認"
