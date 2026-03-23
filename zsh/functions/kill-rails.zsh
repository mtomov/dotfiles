kill-rails() {
  echo "Killing Rails development processes (ports 3000, 28080, 3036)..."
  kill-port 3000 # rails
  kill-port 28080 # wss
  kill-port 3036 # websocket
  kill-port 6006 # Storybook
  kill-port 11434 # Ollama
  echo "Done."
}
