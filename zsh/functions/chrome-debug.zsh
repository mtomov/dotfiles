chrome-debug() {
  local DEBUG_PORT=9222
  local CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  local PROFILE_DIR="$HOME/.chrome-debug"

  # If debug port is already open, assume debug Chrome is running
  if lsof -i TCP:$DEBUG_PORT -sTCP:LISTEN >/dev/null 2>&1; then
    echo "✅ Chrome debug already running on port $DEBUG_PORT"
    return 0
  fi

  echo "🚀 Starting Chrome with remote debugging on port $DEBUG_PORT..."

  "$CHROME_BIN" \
    --remote-debugging-port=$DEBUG_PORT \
    --user-data-dir="$PROFILE_DIR" \
    --no-first-run \
    --remote-allow-origins='*' \
    --no-default-browser-check \
    >/dev/null 2>&1 &

  disown
}
