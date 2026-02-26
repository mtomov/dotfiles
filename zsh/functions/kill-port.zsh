kill-port() {
  local port=${1:-3000}

  if ! lsof -ti tcp:$port >/dev/null 2>&1; then
    echo "❌ No process found running on port $port"
    return 1
  fi

  echo "🔪 Killing process on port $port..."
  lsof -ti tcp:$port | xargs kill -9
  echo "✅ Process killed"
}
