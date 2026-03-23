# Remove Last login prompt from MacOS
printf '\33c\e[3J'

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

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
[[ -f ~/.aliases.local ]] && source ~/.aliases.local
[[ -f ~/.projects ]] && source ~/.projects


export PATH="$HOME/bin:$HOME/code/tools/bin/:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$PATH"

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


# Configure BAT & RIPGREP
if [[ -r ~/.rgrc ]]; then
  export RIPGREP_CONFIG_PATH=~/.rgrc
fi
export BAT_CONFIG_PATH="~/.config/bat/config"
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

gw(){
  if [[ $# == 0 ]]; then
    local path=$(select-git-worktree)
    if [[ -n "$path" ]]; then
      cd "$path"
    fi
    true
  else
    cd "$1"
  fi
}




# eval $(ssh-agent -s) &> /dev/null

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"

export PATH=".git/safe/../../bin:$PATH"


#export OAUTH_DEBUG=true
[ -f "$HOME/bin/kubectl" ] && source <(kubectl completion zsh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export PATH=/opt/homebrew/opt/python@3.10/libexec/bin:$PATH
# export PATH=/Users/martin/Library/Python/3.10/bin:$PATH
# export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# mise must run after Homebrew is on PATH (Apple Silicon: /opt/homebrew/bin/mise)
command -v mise &>/dev/null && eval "$(mise activate zsh)"

# Google Cloud SDK (optional)
[[ -f /opt/homebrew/share/google-cloud-sdk/path.zsh.inc ]] && source /opt/homebrew/share/google-cloud-sdk/path.zsh.inc
[[ -f /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc ]] && source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
eval "$(atuin init zsh --disable-up-arrow)"



[[ -f ~/.secrets ]] && source ~/.secrets

export LDFLAGS="-L$(brew --prefix libpq)/lib"
export CPPFLAGS="-I$(brew --prefix libpq)/include"
export PKG_CONFIG_PATH="$(brew --prefix libpq)/lib/pkgconfig"



# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# export LD_DEV_SERVER=true

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
