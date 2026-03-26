#!/bin/bash
# vim: tw=0

set -eo pipefail

color() {
  local colornumber="$1"
  shift
  tput setaf "$colornumber"
  echo "$*"
  tput sgr0
}

green(){ color 2 "$*"; }

info(){
  green "=== $@"
}

stay_awake_while(){
  caffeinate -dims "$@"
}

quietly_brew_bundle(){
  local brewfile=$1
  shift
  local regex='(^Using )|Homebrew Bundle complete|Skipping install of|It is not currently installed|Verifying SHA-256|==> (Downloading|Purging)|Already downloaded:|No SHA-256'
  stay_awake_while brew bundle --file="$brewfile" "$@" | (grep -vE "$regex" || true)
}

command_does_not_exist(){
  ! command -v "$1" > /dev/null
}

info "Checking for command-line tools..."
if command_does_not_exist xcodebuild; then
  stay_awake_while xcode-select --install
fi

info "Installing Homebrew (if not already installed)..."
if command_does_not_exist brew; then
  stay_awake_while /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

info "Installing Homebrew packages..."
quietly_brew_bundle tag-macos/Brewfile --verbose

# Brewfile.casks exits 1 sometimes but didn't actually fail
quietly_brew_bundle tag-macos/Brewfile.casks || true

if ! echo "$SHELL" | grep -Fq zsh; then
  info "Your shell is not Zsh. Changing it to Zsh..."
  chsh -s /bin/zsh
fi

info "Linking dotfiles into ~..."
# Before `rcup` runs, there is no ~/.rcrc, so we must tell `rcup` where to look.
export RCRC=tag-macos/rcrc
rcup

info "Creating ~/Pictures/screenshots so screenshots can be saved there..."
mkdir -p ~/Pictures/screenshots

info "Installing global pnpm packages..."
if command_does_not_exist pnpm; then
  green "pnpm not found, skipping global packages"
else
  xargs pnpm add -g < pnpm-globals.txt
fi

stay_awake_while ./tag-macos/system/osx-settings.sh
stay_awake_while ./tag-macos/system/terminal-settings.sh

mkdir -p ~/code

green "== Success!"
