#!/usr/bin/env bash
# 純 bash の最小アサーション（外部依存なし）
ASSERT_PASS=0; ASSERT_FAIL=0
assert_eq() { # $1=actual $2=expected $3=msg
  if [ "$1" = "$2" ]; then ASSERT_PASS=$((ASSERT_PASS+1));
  else ASSERT_FAIL=$((ASSERT_FAIL+1)); echo "FAIL: $3 (got='$1' want='$2')"; fi
}
assert_contains() { # $1=haystack $2=needle $3=msg
  case "$1" in *"$2"*) ASSERT_PASS=$((ASSERT_PASS+1));;
  *) ASSERT_FAIL=$((ASSERT_FAIL+1)); echo "FAIL: $3 (missing '$2')";; esac
}
assert_status() { # $1=expected_code; runs after a command, compares $?
  local got=$?; if [ "$got" = "$1" ]; then ASSERT_PASS=$((ASSERT_PASS+1));
  else ASSERT_FAIL=$((ASSERT_FAIL+1)); echo "FAIL: status want=$1 got=$got"; fi
}
assert_summary() { echo "pass=$ASSERT_PASS fail=$ASSERT_FAIL"; [ "$ASSERT_FAIL" = 0 ]; }
