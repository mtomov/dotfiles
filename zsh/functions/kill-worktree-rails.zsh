# kill-worktree-rails: stop the current worktree's dev stack, scoped to the
# ports allocated in ./.env by mn-allocate-port. Safe to run alongside other
# worktrees' bin/dev — it does not touch shared services like Storybook (6006)
# or the LaunchDarkly dev server (8765). For global cleanup, use kill-rails.
kill-worktree-rails() {
  local PORT WSS_PORT VITE_PORT
  if [ -f .env ]; then
    PORT=$(awk -F= '/^PORT=/{print $2; exit}' .env)
    WSS_PORT=$(awk -F= '/^WSS_PORT=/{print $2; exit}' .env)
    VITE_PORT=$(awk -F= '/^VITE_PORT=/{print $2; exit}' .env)
  fi
  PORT="${PORT:-3000}"
  WSS_PORT="${WSS_PORT:-28080}"
  VITE_PORT="${VITE_PORT:-3036}"

  echo "🔪 Killing $(basename "$PWD") ports ($PORT/$WSS_PORT/$VITE_PORT)..."
  kill-port "$PORT"     2>/dev/null
  kill-port "$WSS_PORT" 2>/dev/null
  kill-port "$VITE_PORT" 2>/dev/null
  echo "Done."
}
