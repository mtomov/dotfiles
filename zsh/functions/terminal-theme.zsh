# macOS appearance hooks - runs on every new shell
#
# Terminal.app: switch window profile (osascript only applies there).

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
