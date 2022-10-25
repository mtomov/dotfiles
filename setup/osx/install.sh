#!/bin/bash
# vim: tw=0

# Take inspiration from
# https://github.com/devm33/dotfiles/tree/master/install

set -eo pipefail

color() {
  local colornumber="$1"
  shift
  tput setaf "$colornumber"
  echo "$*"
  tput sgr0
}

# blue = 4
# magenta = 5
red(){ color 1 "$*"; }
green(){ color 2 "$*"; }
yellow(){ color 3 "$*"; }

info(){
  green "=== $@"
}

error(){
  red "!! $@"
}

stay_awake_while(){
  caffeinate -dims "$@"
}

quietly_brew_bundle(){
  local brewfile=$1
  shift
  local regex='(^Using )|Homebrew Bundle complete|Skipping install of|It is not currently installed|Verifying SHA-256|==> (Downloading|Purging)|Already downloaded:|No SHA-256'
  stay_awake_while brew bundle --no-lock --file="$brewfile" "$@" | (grep -vE "$regex" || true)
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
brew tap homebrew/bundle
brew install mas 2>/dev/null
for brewfile in Brewfile */Brewfile; do
  quietly_brew_bundle "$brewfile" --verbose
done

# Brewfile.casks exits 1 sometimes but didn't actually fail
quietly_brew_bundle Brewfile.casks || true
# Pin postgresql since I use Postgres.app and we only need it as a dependency
brew pin postgresql

if ! echo "$SHELL" | grep -Fq zsh; then
  info "Your shell is not Zsh. Changing it to Zsh..."
  chsh -s /bin/zsh
fi

info "Linking dotfiles into ~..."
# Before `rcup` runs, there is no ~/.rcrc, so we must tell `rcup` where to look.
# We need the rcrc because it tells `rcup` to ignore thousands of useless Vim
# backup files that slow it down significantly.
export RCRC=rcrc
stay_awake_while rcup -d .

info "Creating ~/Pictures/screenshots so screenshots can be saved there..."
mkdir -p ~/Pictures/screenshots

stay_awake_while ./system/osx-settings.sh
stay_awake_while ./system/terminal-settings.sh

info "Running all setup scripts..."
for setup in tag-*/setup vscode/setup; do
  dir=$(basename "$(dirname "$setup")")
  info "Running setup for ${dir#tag-}..."
  . "$setup"
done

mkdir -p ~/code/work
mkdir -p ~/code/personal

green "== Success!"

yellow "== Post-install instructions =="
yellow "1. Install Postgres.app manually https://postgresapp.com/downloads.html"
