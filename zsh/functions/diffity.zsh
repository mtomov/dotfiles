# Run diffity from the git worktree root. Diffity invokes git without setting cwd;
# if something launches it with a cwd outside the repo (or not the worktree you
# care about), you get wrong diffs or failures. Worktrees use a `.git` file —
# cwd must still be inside that checkout.
# If multiple repos have servers running, `diffity list` shows ports; only one
# binds to 5391, the rest use 5392+.
diffity() {
  local top
  if top=$(git rev-parse --show-toplevel 2>/dev/null); then
    (cd "$top" && command diffity "$@")
  else
    command diffity "$@"
  fi
}
