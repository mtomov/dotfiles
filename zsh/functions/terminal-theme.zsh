# Auto-switch Terminal.app theme based on macOS appearance
# Runs on every new shell — sets the current tab's profile
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  if defaults read -g AppleInterfaceStyle &>/dev/null; then
    _terminal_profile="Tomorrow Night Custom"
  else
    _terminal_profile="Tomorrow Light Custom"
  fi

  osascript -e "
    tell application \"Terminal\"
      set current settings of front window to settings set \"${_terminal_profile}\"
    end tell
  " &>/dev/null

  unset _terminal_profile
fi
