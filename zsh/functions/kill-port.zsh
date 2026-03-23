kill-port() {
  local port=${1:-3000}
  local pids

  if ! lsof -ti tcp:$port >/dev/null 2>&1; then
    echo "❌ No process found running on port $port"
    return 1
  fi

  pids=$(lsof -ti tcp:$port)
  echo "🔪 Stopping process on port $port (SIGTERM)..."
  echo "$pids" | xargs kill -TERM 2>/dev/null

  # Wait up to 3s for graceful exit, then force if still running
  local waited=0
  while lsof -ti tcp:$port >/dev/null 2>&1 && (( waited < 30 )); do
    sleep 0.1
    (( waited++ ))
  done

  if lsof -ti tcp:$port >/dev/null 2>&1; then
    echo "⚠️ Process still running, sending SIGKILL..."
    lsof -ti tcp:$port | xargs kill -9
  fi
  echo "✅ Process stopped"
}
