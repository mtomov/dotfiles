#!/usr/bin/env zsh
set -eu

ROOT="${0:A:h:h}"
TMPDIR="$(mktemp -d)"
LOG="$TMPDIR/calls.log"
export LOG

cleanup() {
  rm -rf "$TMPDIR"
}
trap cleanup EXIT

fail() {
  print -r -- "FAIL: $1" >&2
  exit 1
}

assert_log() {
  local expected="$1"
  local actual=""
  [[ -f "$LOG" ]] && actual="$(cat "$LOG")"
  [[ "$actual" == "$expected" ]] || fail "expected log <$expected>, got <$actual>"
}

run_in_tmp() {
  (
    cd "$TMPDIR"
    mkdir -p bin
    source "$ROOT/zsh/functions/d.zsh"
    "$@"
  )
}

overmind() {
  print -r -- "overmind $*" >> "$LOG"
  case "$1" in
    status)
      [[ "${OVERMIND_STATUS:-fail}" == "ok" ]]
      ;;
    connect)
      return 0
      ;;
    quit)
      [[ "${OVERMIND_QUIT:-ok}" == "ok" ]]
      ;;
  esac
}

trash() {
  print -r -- "trash $*" >> "$LOG"
  rm -f "$@"
}

kill-worktree-rails() {
  print -r -- "kill-worktree-rails" >> "$LOG"
}

test_reuses_running_overmind() {
  : > "$LOG"
  : > "$TMPDIR/.overmind.sock"
  OVERMIND_STATUS=ok run_in_tmp d >/dev/null

  assert_log $'overmind status\novermind status\novermind connect'
}

test_removes_stale_socket_and_starts_dev() {
  : > "$LOG"
  : > "$TMPDIR/.overmind.sock"
  print -r -- '#!/usr/bin/env zsh' > "$TMPDIR/bin/dev"
  print -r -- 'if [[ "$#" -eq 0 ]]; then print -r -- "bin/dev" >> "$LOG"; else print -r -- "bin/dev $*" >> "$LOG"; fi' >> "$TMPDIR/bin/dev"
  chmod +x "$TMPDIR/bin/dev"

  OVERMIND_STATUS=fail run_in_tmp d --foo >/dev/null

  assert_log $'overmind status\ntrash .overmind.sock\nbin/dev --foo'
}

test_restart_quits_overmind_before_port_cleanup() {
  : > "$LOG"
  : > "$TMPDIR/.overmind.sock"
  print -r -- '#!/usr/bin/env zsh' > "$TMPDIR/bin/dev"
  print -r -- 'if [[ "$#" -eq 0 ]]; then print -r -- "bin/dev" >> "$LOG"; else print -r -- "bin/dev $*" >> "$LOG"; fi' >> "$TMPDIR/bin/dev"
  chmod +x "$TMPDIR/bin/dev"

  OVERMIND_STATUS=ok run_in_tmp d --restart >/dev/null

  assert_log $'overmind status\novermind quit\ntrash .overmind.sock\nkill-worktree-rails\nbin/dev'
}

test_reuses_running_overmind
test_removes_stale_socket_and_starts_dev
test_restart_quits_overmind_before_port_cleanup

print -r -- "ok"
