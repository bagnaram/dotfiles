#! /usr/bin/env zsh
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
setopt complete_aliases # tab complete on aliases

# Aliases
function setalias() {
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

source /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-ohmyzsh-SLASH-ohmyzsh/oh-my-zsh.sh
fpath+=( /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-ohmyzsh-SLASH-ohmyzsh )
source /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-ohmyzsh-SLASH-ohmyzsh/plugins/git/git.plugin.zsh
fpath+=( /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-ohmyzsh-SLASH-ohmyzsh/plugins/git )
source /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-ohmyzsh-SLASH-ohmyzsh/plugins/colored-man-pages/colored-man-pages.plugin.zsh
fpath+=( /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-ohmyzsh-SLASH-ohmyzsh/plugins/colored-man-pages )
source /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fpath+=( /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-syntax-highlighting )
source /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-completions/zsh-completions.plugin.zsh
fpath+=( /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-completions )
source /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
fpath+=( /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-autosuggestions )
source /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-dracula-SLASH-zsh/dracula.zsh-theme
fpath+=( /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-dracula-SLASH-zsh )
source /home/mbagnara/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-b4b4r07-SLASH-emoji-cli/emoji-cli.zsh

#source <(antibody init)
#
#antibody bundle << EOF
#
## empty lines are skipped
#
#ohmyzsh/ohmyzsh
#ohmyzsh/ohmyzsh path:plugins/git
#ohmyzsh/ohmyzsh path:plugins/colored-man-pages
#
#zsh-users/zsh-syntax-highlighting
#zsh-users/zsh-completions
#zsh-users/zsh-autosuggestions
#
#dracula/zsh
#
#b4b4r07/emoji-cli path:emoji-cli.zsh
#
#EOF

LS_COLORS="$(vivid generate solarized-light)"

# Obtain color scheme being set
#
#scheme=`yq eval '.colors | alias' ${HOME}/dotfiles/alacritty/dracula-pro.yml`

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
bindkey "$EMOJI_CLI_KEYBIND" emoji::cli

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
    \kubecolor -n $KUBESPACE "$@"
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
    \kubecolor -n $KUBESPACE "$@"
    return 0
  fi
}

# Emit OSC7 (current working directory)
function _urlencode() {
  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:$i:1}"
    case $c in
      %) printf '%%%02X' "'$c" ;;
      *) printf "%s" "$c" ;;
    esac
  done
}


function osc7_cwd() {
  printf '\e]7;file://%s%s\e\\' "$HOSTNAME" "$(_urlencode "$PWD")"
}

autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd osc7_cwd

source <(kubectl completion zsh)
compdef kubecolor=kubectl

function day_night_cycle() {
  scheme=$(<~/DAY)
  if [ "$scheme" = "0" ];then
    theme.sh "Dracula Pro (Van Helsing)"
    export LS_COLORS="$(vivid generate solarized-dark)"
  elif [ "$scheme" = "1" ]; then
    theme.sh earl-grey-theme
    export LS_COLORS="$(vivid generate solarized-light)"
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
