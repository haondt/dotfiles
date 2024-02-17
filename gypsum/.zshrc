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

## custom vim startup ##
vimcd() {
    if [ -n "$1" ]; then # called with arg
        if [ -d "$1" ]; then # arg is dir
            \nvim -c "cd $1"
        else # arg is file
            local file_dir=$(dirname "$1")
            \nvim -c "cd $file_dir" -c "edit $1"
        fi
    else # no arg
        \nvim
    fi
}

## custom tmux startup ##
tvim() {
    if [ "$#" -ne 1 ]; then
        tmux
    else
        cwd=$(pwd)
        target="$1"

        # ensure target exists
        if [ ! -e "$target" ]; then
            echo "Error: '$target' does not exist"
            exit 1
        fi

        # arg is dir
        if [ -d "$target" ]; then
            cd "$target"
            vim_target=""
        else
            cd $(dirname "$target")
            vim_target=$(basename "$target")
        fi

        tmux new-session "nvim $vim_target; zsh" \; split-window -v -p 20 \; select-pane -t 0
        cd $cwd
    fi

}

## aliases ##
alias sz='. ~/.zshrc'
alias ez='vim ~/.zshrc'

alias md='medea --trim'
alias clip='xclip -selection clipboard'
alias sclip="scrot -s -e 'xclip -selection clipboard -t image/png -i $f'"
alias vim=vimcd
alias nvim=vimcd
alias tv=tvim
alias py='python3'

alias gs='git status --short -b'
alias ga='git add'
alias gcm='git commit -m'
alias gr='git reset'

alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

hash -d vs="$HOME/dotfiles/gypsum/.config/nvim"
hash -d vl="$HOME/.local/state/nvim"
hash -d p="$HOME/projects"


## python ##
VIRTUAL_ENV_DISABLE_PROMPT=1
