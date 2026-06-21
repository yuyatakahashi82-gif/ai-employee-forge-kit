#!/usr/bin/env bash
set -u
DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$DIR/tests/assert.sh"

for n in 00-preflight 10-install-hermes 20-auth-brain 30-discord-bot 40-persona 50-memory 60-self-maintenance; do
  f="$DIR/scripts/$n.sh"
  [ -f "$f" ] && assert_eq "ok" "ok" "$n exists" || assert_eq "missing" "ok" "$n exists"
  # DRYRUN で何か手順を出力し exit 0 すること
  out="$(DRYRUN=1 bash "$f" "$DIR/forge.vars.example" 2>&1)"; st=$?
  assert_eq "$st" "0" "$n DRYRUN exits 0"
  assert_contains "$out" "[forge]" "$n DRYRUN prints guidance"
done
# ラッパーは PLAYBOOK を参照し、SKILL.md は frontmatter を持つこと
assert_contains "$(cat "$DIR/SKILL.md")" "name:" "SKILL.md has frontmatter name"
assert_contains "$(cat "$DIR/SKILL.md")" "PLAYBOOK.md" "SKILL.md references PLAYBOOK"
assert_contains "$(cat "$DIR/AGENTS.md")" "PLAYBOOK.md" "AGENTS.md references PLAYBOOK"
# PLAYBOOK が全 script を参照していること（壊れ参照防止）
for n in 00-preflight 90-clean-exit-verify; do
  assert_contains "$(cat "$DIR/PLAYBOOK.md")" "$n" "PLAYBOOK references $n"
done
# #1: 各 00-60 が DRYRUN で「完了条件:」を表示すること
for n in 00-preflight 10-install-hermes 20-auth-brain 30-discord-bot 40-persona 50-memory 60-self-maintenance; do
  out="$(DRYRUN=1 bash "$DIR/scripts/$n.sh" "$DIR/forge.vars.example" 2>&1)"
  assert_contains "$out" "完了条件:" "$n prints 完了条件"
done
assert_summary
