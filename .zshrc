# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
alias bi="brew install"
alias bic="brew install --cask"
alias bs="brew search"
alias bup="brew upgrade"
alias vim="nvim"


bindkey -s "^f" "search\n"


source ~/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Load the theme.
antigen theme awesomepanda

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle tmux

#external package
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions


antigen apply


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=red,bold"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

source $HOME/.env.local.sh

export PATH=$HOME/.local/bin:$PATH
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

PATH=~/.console-ninja/.bin:$PATH