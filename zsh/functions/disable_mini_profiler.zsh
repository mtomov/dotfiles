disable_mini_profiler() {
  local DEBUG_PORT=9222
  local DOMAIN="localhost"

  # Find first page target (prefer localhost:3000 pages)
  local PAGE_INFO
  PAGE_INFO=$(curl -s "http://localhost:${DEBUG_PORT}/json" \
    | jq -r '.[] | select(.type=="page") | "\(.id)|\(.webSocketDebuggerUrl)|\(.url)"' \
    | grep -E "localhost:3000" | head -n 1)
  
  # If no localhost:3000 page, get any page
  if [[ -z "$PAGE_INFO" ]]; then
    PAGE_INFO=$(curl -s "http://localhost:${DEBUG_PORT}/json" \
      | jq -r '.[] | select(.type=="page") | "\(.id)|\(.webSocketDebuggerUrl)|\(.url)"' \
      | head -n 1)
  fi

  if [[ -z "$PAGE_INFO" ]]; then
    echo "❌ No Chrome page found (is Chrome running with --remote-debugging-port=${DEBUG_PORT}?)"
    return 1
  fi

  local WS_URL
  WS_URL=$(echo "$PAGE_INFO" | cut -d'|' -f2)
  
  if [[ -z "$WS_URL" ]]; then
    echo "❌ Could not get WebSocket URL"
    return 1
  fi

  # Send CDP command via Python websocket-client
  python3 - "$WS_URL" "$DOMAIN" <<'PYTHONSCRIPT'
import json
import websocket
import sys
import threading
import time
from datetime import datetime, timedelta

ws_url = sys.argv[1]
domain = sys.argv[2]
command_sent = False
response_received = False
error_occurred = False

def on_message(ws, message):
    global response_received, error_occurred
    try:
        response = json.loads(message)
        # Handle Runtime.enable response (id: 0)
        if response.get('id') == 0:
            if 'error' in response:
                print(f"❌ Failed to enable Runtime domain: {response['error'].get('message', 'Unknown error')}", file=sys.stderr)
                error_occurred = True
                ws.close()
        # Handle Runtime.evaluate response (id: 1)
        elif response.get('id') == 1:
            if 'error' in response:
                print(f"❌ CDP error: {response['error'].get('message', 'Unknown error')}", file=sys.stderr)
                error_occurred = True
            else:
                response_received = True
            ws.close()
        # Ignore other messages (like Runtime.executionContextCreated)
    except Exception as e:
        print(f"❌ Error parsing response: {e}", file=sys.stderr)
        error_occurred = True
        ws.close()

def on_error(ws, error):
    global error_occurred
    error_str = str(error)
    if "403" in error_str or "Forbidden" in error_str or "remote-allow-origins" in error_str:
        print("❌ Chrome WebSocket connection rejected.", file=sys.stderr)
        print("", file=sys.stderr)
        print("   Chrome needs to be restarted with --remote-allow-origins=*", file=sys.stderr)
        print("", file=sys.stderr)
        print("   On macOS, close Chrome and run:", file=sys.stderr)
        chrome_cmd = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome --remote-debugging-port=9222 --remote-allow-origins=*"
        print(f"   {chrome_cmd}", file=sys.stderr)
        print("", file=sys.stderr)
    else:
        print(f"❌ WebSocket error: {error}", file=sys.stderr)
    error_occurred = True

def on_open(ws):
    global command_sent
    if command_sent:
        return
    command_sent = True
    
    # First enable Runtime domain (required for Runtime.evaluate)
    enable_cmd = {"id": 0, "method": "Runtime.enable"}
    ws.send(json.dumps(enable_cmd))
    time.sleep(0.1)
    
    # Use Runtime.evaluate to set cookie via JavaScript
    # Set __profilin cookie with long expiry (1 year from now)
    expiry_date = datetime.now() + timedelta(days=365)
    expiry_str = expiry_date.strftime('%a, %d %b %Y %H:%M:%S GMT')
    cookie_value = "p%3Dt%2Cdp%3Dt"
    command = {
        "id": 1,
        "method": "Runtime.evaluate",
        "params": {
            "expression": f"document.cookie = '__profilin={cookie_value}; domain={domain}; path=/; expires={expiry_str}'"
        }
    }
    ws.send(json.dumps(command))

def on_close(ws, close_status_code, close_msg):
    pass

# Use Runtime.evaluate instead of Network.setCookie to avoid origin issues
# This executes JavaScript directly in the page context
ws = websocket.WebSocketApp(
    ws_url,
    on_open=on_open,
    on_message=on_message,
    on_error=on_error,
    on_close=on_close
)

# Run in a separate thread with timeout
def run_ws():
    ws.run_forever()

thread = threading.Thread(target=run_ws, daemon=True)
thread.start()

# Wait for response or timeout
timeout = 3
start_time = time.time()
while thread.is_alive() and (time.time() - start_time) < timeout:
    if response_received or error_occurred:
        break
    time.sleep(0.1)

if not response_received and not error_occurred:
    if not command_sent:
        print("❌ Connection timeout", file=sys.stderr)
        sys.exit(1)
    else:
        print("❌ Response timeout - no response received", file=sys.stderr)
        sys.exit(1)

sys.exit(0 if response_received and not error_occurred else 1)
PYTHONSCRIPT

  if [[ $? -eq 0 ]]; then
    echo "✅ Rack::MiniProfiler disabled (__profilin cookie set) for ${DOMAIN}"
  else
    echo "❌ Failed to set cookie"
    return 1
  fi
}
