# macOS appearance hooks — runs on every new shell
#
# Terminal.app: switch window profile (osascript only applies there).
# Claude Code: set ~/.claude settings "theme" to *-ansi so colors use the
# terminal palette (readable with Ghostty palette=); standard Light/Dark in
# the /theme picker use full UI colors (often true color), not ANSI-only.
#
# If you change macOS appearance without opening a new shell, run
# claude-sync-theme manually before starting Claude Code.

if [[ "$(uname -s)" == Darwin ]]; then
  _claude_sync_theme_bin="$HOME/bin/claude-sync-theme"
  [[ -x "$_claude_sync_theme_bin" ]] || _claude_sync_theme_bin="$HOME/code/dotfiles/bin/claude-sync-theme"
  [[ -x "$_claude_sync_theme_bin" ]] && "$_claude_sync_theme_bin"
  unset _claude_sync_theme_bin
fi

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
