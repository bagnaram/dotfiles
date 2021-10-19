#set -ex
export PATH=$HOME/bin:/usr/local/bin:$PATH

export HISTSIZE=55500
export SAVEHIST=10000
setopt append_history # Don't overwrite, append!
setopt INC_APPEND_HISTORY # Write after each command
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history.
setopt hist_fcntl_lock # use OS file locking
setopt hist_ignore_all_dups # Delete old recorded entry if new entry is a duplicate.
setopt hist_lex_words # better word splitting, but more CPU heavy
setopt hist_reduce_blanks # Remove superfluous blanks before recording entry.
setopt hist_save_no_dups # Don't write duplicate entries in the history file.
setopt share_history # share history between multiple shells
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space.

# Aliases
setalias() {
  alias mutt="TERM=screen-256color neomutt"
  alias kubectl='_kcl'
  alias grep='grep --color=auto'
  alias ls='ls --color=auto'
  alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'
}
setalias


# disable Software Flow Control (^s, ^q)
stty -ixon
# convert the CR character to LF on input
stty icrnl

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl

### End of Zinit's installer chunk

zinit ice wait
zinit snippet OMZP::git
zinit snippet OMZP::colored-man-pages
zinit ice wait
zinit light "b4b4r07/emoji-cli"
zinit ice wait
zinit ice as"program" cp"theme.sh -> theme" pick"theme"
zinit light lemnos/theme.sh
source $HOME/.aoeu/aoeu.sh

# Obtain color scheme being set
#
#scheme=`yq eval '.colors | alias' ${HOME}/dotfiles/alacritty/dracula-pro.yml`

zinit wait lucid for \
atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zsh-users/zsh-syntax-highlighting \
blockf \
    zsh-users/zsh-completions \
atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions



zinit ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zinit light trapd00r/LS_COLORS

# Load dracula theme
zinit ice pick"async.zsh" src"dracula.zsh-theme" # with zsh-async library that's bundled with it.
zinit light dracula/zsh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vi'
else
  export EDITOR='emacsclient'
fi

# ZSH DVORAK key bindings
bindkey -v
bindkey -a h backward-char
bindkey -a s forward-char
bindkey -a t down-line-or-history
bindkey -a n up-line-or-history
bindkey -a r vi-repeat-search

# make backspace behave more intuitive in VI mode
bindkey "^?" backward-delete-char

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

export KEYTIMEOUT=1
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export KUBESPACE=default
export EMOJI_CLI_USE_EMOJI=true
export HISTFILE=~/.zsh_history
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"


# Kubectl project plugin
function _kcl() {
  if [[ -z "$1" && -z "$2" ]]; then
    \kubectl -n $KUBESPACE "$@"
    return 0
  fi
  if [[ ! -z "$1" && "$1" == "project" && -z "$2" ]]; then
      echo "Current project: $KUBESPACE"
      echo "Usage: $0 project <namespace>"
      return 1
  fi
  if [[ ! -z "$1"  && "$1" == "project" && ! -z $2 ]]; then
    export KUBESPACE="$2"
    echo "Set current project to $KUBESPACE"
    return 0
  else
    \kubectl -n $KUBESPACE "$@"
    return 0
  fi
}

function day_night_cycle() {
  scheme=$(<~/DAY)
  if [ "$scheme" = "0" ];then
    theme.sh dracula
  elif [ "$scheme" = "1" ]; then
    theme.sh belafonte-day
  fi
}

# toggle the zsh syntax highlightinng theme
TRAPUSR1() {
  day_night_cycle
  setalias
}

day_night_cycle

# Load environment vars into systemd
export $(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)

export CHECKPOINT_DISABLE=ANY_VALUE
export DISABLE_AUTO_UPDATE=true

# load in history last
fc -R $HISTFILE

