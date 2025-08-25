# Remove Last login prompt from MacOS
printf '\33c\e[3J'

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(fzf)

# source $ZSH/oh-my-zsh.sh

#
# User configuration

# source "$ZSH/themes/$ZSH_THEME.zsh-theme"

# load our own completion functions

# zstyle ':autocomplete:*' min-input 0
zstyle ':completion:*:*:git:*' script ~/.zsh/completion-scripts/git-completion.bash
fpath=($HOME/.zsh/completion-scripts $fpath)

# Add zsh completions directory to fpath
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# Colorful lists of possible autocompletions for `ls`
# zstyle doesn't understand the BSD-style $LSCOLORS at all, so use Linux-style
# $LS_COLORS
zstyle ':completion:*:ls:*:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'


# completion
autoload -U compinit
compinit

# load custom executable functions
for function in ~/.zsh/functions/*.zsh; do
  source $function
done

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# history settings
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
# bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.projects ]] && source ~/.projects


export PATH="$HOME/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$PATH"

# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='cursor --wait'
fi

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="cursor ~/.zshrc"

# Custom exports
# export PGUSER=postgres

# for QHD display
# if [[ -z `xrandr | grep 2560x1440R` ]]
# then
#     xrandr --newmode "2560x1440R"  241.50  2560 2608 2640 2720  1440 1443 1448 1481 +hsync -vsync
#     xrandr --addmode HDMI-1-1 2560x1440R
# fi

# xrandr --output HDMI-1-1 --mode 2560x1440R

# Configure BAT & RIPGREP
if [[ -r ~/.rgrc ]]; then
  export RIPGREP_CONFIG_PATH=~/.rgrc
fi
export BAT_CONFIG_PATH="~/.config/bat/config"
alias cat=bat
alias less=bat

# Prompt {{{
eval "$(starship init zsh)"
# }}}

# Git
gc(){
  if [[ $# == 0 ]]; then
    local branch=$(select-git-branch)
    if [[ -n "$branch" ]]; then
      git checkout "$branch"
    fi
    true
  else
    git checkout "$@"
  fi
}


# eval $(ssh-agent -s) &> /dev/null

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"

# export ANDROID_HOME=$HOME/Programs/Android/Sdk
# export PATH=$PATH:$ANDROID_HOME/emulator
# export PATH=$PATH:$ANDROID_HOME/tools
# export PATH=$PATH:$ANDROID_HOME/tools/bin
# export PATH=$PATH:$ANDROID_HOME/platform-tools
# export PATH=$PATH:$HOME/Programs/flutter/bin

eval "$(rbenv init - zsh)"

export PATH=".git/safe/../../bin:$PATH"

# Load pyenv automatically by adding
# the following to ~/.zshrc:

# export PATH="$HOME/.pyenv/versions/3.7.2/bin:$PATH"
# export PATH="$HOME/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
# alias python=python3
# eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"
# export PATH=$PATH:/Users/martin/Library/Python/3.9/bin
# export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

# export PATH=$PATH:/usr/local/go/bin
# export PATH=$PATH:$HOME/bin/go/bin

# export GOPATH="$HOME/bin/go/"

#export OAUTH_DEBUG=true
[ -f "$HOME/bin/kubectl" ] && source <(kubectl completion zsh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fnm
export PATH="$HOME/.fnm:$PATH"
eval "`fnm env`"
# export PATH=/opt/homebrew/opt/python@3.10/libexec/bin:$PATH
# export PATH=/Users/martin/Library/Python/3.10/bin:$PATH
# export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
source /opt/homebrew/share/google-cloud-sdk/path.zsh.inc
