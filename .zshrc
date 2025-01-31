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


zinit light starship/starship



eval "$(starship init zsh)"
eval "$(fzf --zsh)"


export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#dde4ce,fg+:#65ff05,bg:#10110f,bg+:#262626
  --color=hl:#00db0f,hl+:#00ff08,info:#afaf87,marker:#87ff00
  --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf
  --color=gutter:#2d2929,border:#3c6941,separator:#264a31,preview-fg:#40ff00
  --color=label:#aeaeae,query:#d9d9d9
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt=">"
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'

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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'tree -C $realpath'



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

export App="app"

export Editor="nvim"


PATH=~/.console-ninja/.bin:$PATH
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Set-up icons for files/folders in terminal using eza
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=1 --icons'

# bun completions
[ -s "/home/aritra/.bun/_bun" ] && source "/home/aritra/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
