# Print a clickable Linear issue link for Ghostty and other OSC 8-aware terminals.
linear_issue() {
  if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: linear_issue ISSUE-ID [label]" >&2
    return 1
  fi

  local issue_id="$1"
  local label="${2:-$issue_id}"
  local upper_id="${(U)issue_id}"
  local url="https://linear.app/beamazing/issue/$upper_id"

  printf '\e]8;;%s\e\\%s\e]8;;\e\\\n' "$url" "$label"
}

alias li='linear_issue'
