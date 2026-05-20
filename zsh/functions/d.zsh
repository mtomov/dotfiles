d() {
  local restart=false

  if [[ "${1:-}" == "--restart" ]]; then
    restart=true
    shift
  fi

  if [[ "$restart" == false && -e .overmind.sock ]] && overmind status >/dev/null 2>&1; then
    echo "✅ Overmind already running for $(basename "$PWD")"
    overmind status
    overmind connect
    return
  fi

  if [[ "$restart" == true && -e .overmind.sock ]] && overmind status >/dev/null 2>&1; then
    echo "🔪 Stopping Overmind for $(basename "$PWD")..."
    overmind quit || return $?
  fi

  if [[ -e .overmind.sock ]]; then
    echo "🧹 Removing stale .overmind.sock"
    trash .overmind.sock
  fi

  if [[ "$restart" == true ]]; then
    kill-worktree-rails
  fi

  bin/dev "$@"
}
