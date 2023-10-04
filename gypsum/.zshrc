## zsh setup ##
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="haondt"
plugins=()
source $ZSH/oh-my-zsh.sh
export ZLE_RPROMPT_INDENT=0

## vim everywhere ##
set -o vi
export FCEDIT=nvim
export EDITOR=nvim

## path addendums ##
. "$HOME/.cargo/env"
export PATH=$PATH:~/.local/share/bob/nvim-bin
export PATH=$PATH:~/.local/bin

## aliases ##
alias sz='. ~/.zshrc'

alias md='medea'
alias clip='xclip -selection clipboard'
alias vim=nvim

alias gs='git status --short -b'
alias ga='git add'
alias gcm='git commit -m'
alias gr='git reset'

alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'