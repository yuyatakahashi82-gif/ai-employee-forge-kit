#!/usr/bin/env bash
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$DIR/tests/assert.sh"

run() { bash "$DIR/scripts/90-clean-exit-verify.sh" "$1" >/dev/null 2>&1; echo $?; }

# クリーンな環境: HERMES_HOME に構築者痕跡なし → status 0
clean="$(mktemp -d)"; mkdir -p "$clean/.hermes"
cat > "$clean/forge.vars" <<EOF
OWNER_NAME=Owner
BUILDER_FORBIDDEN_PATTERNS='builderx|buildercorp'
HERMES_HOME=$clean/.hermes
EOF
printf '{"providers":{"xai-oauth":{}}}' > "$clean/.hermes/auth.json"
assert_eq "$(run "$clean/forge.vars")" "0" "clean env passes"

# 汚染環境: 構築者の痕跡が残存 → status 2
dirty="$(mktemp -d)"; mkdir -p "$dirty/.hermes"
cat > "$dirty/forge.vars" <<EOF
OWNER_NAME=Owner
BUILDER_FORBIDDEN_PATTERNS='builderx|buildercorp'
HERMES_HOME=$dirty/.hermes
EOF
printf 'token=builderx-secret\n' > "$dirty/.hermes/.env"
assert_eq "$(run "$dirty/forge.vars")" "2" "leftover builder credential detected"

rm -rf "$clean" "$dirty"

# #3: .env はクリーンでも auth.json に構築者痕跡があれば exit 2
a="$(mktemp -d)"; mkdir -p "$a/.hermes"
cat > "$a/forge.vars" <<EOF
OWNER_NAME=Owner
BUILDER_FORBIDDEN_PATTERNS='builderx|buildercorp'
HERMES_HOME=$a/.hermes
EOF
printf '{"credential_pool":{"openai-codex":[{"access_token":"x","label":"builderx-leftover"}]}}' > "$a/.hermes/auth.json"
assert_eq "$(run "$a/forge.vars")" "2" "builder trace in auth.json detected"
rm -rf "$a"
assert_summary
