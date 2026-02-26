#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_PRIVATE_DIR="$HOME/dotfiles-private"

echo "Setting up Windows dotfiles..."

# --- Symlink .gitconfig ---
if [ -L "$HOME/.gitconfig" ]; then
  echo ".gitconfig symlink already exists, skipping"
elif [ -f "$HOME/.gitconfig" ]; then
  echo "WARNING: ~/.gitconfig exists and is a regular file."
  echo "Back it up and remove it, then re-run this script."
  exit 1
else
  ln -s "$DOTFILES_DIR/tag-git/gitconfig" "$HOME/.gitconfig"
  echo "Symlinked ~/.gitconfig"
fi

# --- Symlink .gitconfig.local ---
if [ -L "$HOME/.gitconfig.local" ]; then
  echo ".gitconfig.local symlink already exists, skipping"
elif [ -f "$HOME/.gitconfig.local" ]; then
  echo "WARNING: ~/.gitconfig.local exists and is a regular file."
  echo "Back it up and remove it, then re-run this script."
  exit 1
else
  ln -s "$DOTFILES_PRIVATE_DIR/gitconfig.local" "$HOME/.gitconfig.local"
  echo "Symlinked ~/.gitconfig.local"
fi

# --- Add g() function to .bashrc ---
if grep -q 'g()' "$HOME/.bashrc" 2>/dev/null; then
  echo "g() function already in .bashrc, skipping"
else
  cat >> "$HOME/.bashrc" << 'FUNC'

# No arguments: `git status`
# With arguments: acts like `git`
g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
  fi
}
FUNC
  echo "Added g() function to ~/.bashrc"
fi

echo "Done! Restart your terminal or run: source ~/.bashrc"
