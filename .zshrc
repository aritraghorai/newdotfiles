ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi


source "$ZINIT_HOME/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

zinit load starship/starship



eval "$(starship init zsh)"
eval "$(fzf --zsh)"

# Add in Snippid
zinit snippet OMZP::git
zinit snippet OMZP::docker
zinit snippet OMZP::archlinux
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found




# History
HISTSIZE=100000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt histignorealldups
setopt histignoredups

bindkey -s "^f" "search\n"

# Complatetion Style
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no



# Load completion
autoload -U compinit && compinit

zinit cdreplay -q


alias vim="nvim"
alias ls="ls --color"

source $HOME/.env.local.sh

export PATH=$HOME/.local/bin:$PATH
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools


