#!/bin/bash

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

command_does_not_exist(){
  ! command -v "$1" > /dev/null
}

info "Installing DConf configs..."
# dconf dump / > dconf.backup
cat setup/elementary/dconf.txt | dconf load /

info "Installing apt packages..."
grep -vE '^#' setup/elementary/packages.list | xargs sudo apt install -y

info "Installing snap packages..."
# grep -vE '^#' setup/elementary/snap.list | xargs sudo snap install

info "Installing Oh My Zsh..."
[ ! -d ~/.oh-my-zsh ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

if ! echo "$SHELL" | grep -Fq zsh; then
  info "Your shell is not Zsh. Changing it to Zsh..."
  chsh -s /bin/zsh
fi


info "Linking dotfiles into ~..."
# Before `rcup` runs, there is no ~/.rcrc, so we must tell `rcup` where to look.
export RCRC=tag-elementaryos/rcrc
rcup -v -d .

info "Refreshing fonts"
fc-cache -f -v

info "Setting correct permissions for SSH folder"
chmod 0600 ~/.ssh/*

info "Running all setup scripts..."
for setup in tag-*/setup; do
  dir=$(basename "$(dirname "$setup")")
  info "Running setup for ${dir#tag-}..."
  . "$setup"
done

if [ ! -d ~/bin/quicktile ]; then
    info "Installing quicktile"
    curl -L https://api.github.com/repos/ssokolow/quicktile/tarball | tar xz --strip=1 -C ~/bin/quicktile
fi

if ! command -v bat &> /dev/null; then
  info "Installing bat"
  curl https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb -o /tmp/bat.deb && sudo dpkg -i /tmp/bat.deb
fi

if ! command -v google-chrome &> /dev/null; then
  info "Installing chrome"
  curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb && sudo dpkg -i /tmp/chrome.deb
fi

# info "Installing Viber"
# curl https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb -o /tmp/viber.deb && sudo dpkg -i /tmp/viber.deb

if ! command -v jumpapp &> /dev/null; then
  info "Installing jumpapp"
  curl https://github.com/mkropat/jumpapp/releases/download/v1.2/jumpapp_1.2-1_all.deb -o /tmp/jumpapp.deb && sudo dpkg -i /tmp/jumpapp.deb
fi

mkdir -p ~/work

green "== Success!"

yellow "== Post-install instructions =="
yellow "1. Install VSCode https://phoenixnap.com/kb/install-vscode-ubuntu#ftoc-heading-3"
yellow "2. Install docker https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository"
yellow "3. Install jumpapp https://github.com/mkropat/jumpapp#ubuntu-debian-and-friends"
