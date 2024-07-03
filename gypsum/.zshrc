## zsh setup ##
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="haondt"
plugins=(vi-mode)
zstyle ':omz:alpha:lib:git' async-prompt no # disable async, it messed with git prompt
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
# workaround because something is broken that causes grep (<leader>ps) to not preview files correctly
vimcd() {
    if [ -n "$1" ]; then # called with arg
        if [ -d "$1" ]; then # arg is dir
            RETURN_PATH=$(pwd); cd $1 && \nvim && cd $RETURN_PATH
        else # arg is file
            local file_dir=$(dirname "$1")
            RETURN_PATH=$(pwd); cd $file_dir && \nvim -c "edit $1" && cd $RETURN_PATH
        fi
    else # no arg
        \nvim
    fi
}


cheat() {
    BUFFER=""

    local markdown_dir="$HOME/dotfiles/gypsum/cheat"
    local cheat="$HOME/dotfiles/gypsum/cheat/cheat.sh"

    # Use grep to search for tags in Markdown files
    #tags=$(grep -h -r -o -E '#\w+' "$markdown_dir" | sort -u)
    local tags=$("$cheat" -d "$markdown_dir" | sed 's/:/\t/g' | sed 's/<COLON>/:/g')

    # Use fzf to select a tag interactively
    local selected=$(echo -e "$tags" | fzf -d "\t" --with-nth=1 --ansi --preview "batcat  -pp --color=always --highlight-line {2} {-1} --theme=Dracula" --preview-window '+{2}/2')
    if [[ -n $selected ]]; then
        local selected_path=$(echo -e "$selected" | awk -F'\t' '{print $4}')
        local selected_line=$(echo -e "$selected" | awk -F'\t' '{print $2}')
        batcat --theme=Dracula --highlight-line $selected_line --color=always -p --pager="less +"$selected_line"G -j.5" $selected_path 
    fi

    zle accept-line
}

FZF_DIRS=(
    "$HOME/syncthing/notes/The Vault v2"
    "$HOME/dotfiles/gypsum"
)
FZF_DIRS+=($HOME/projects/*)

fzf_dir() {
    dirs=$(python3 << EOF
import os
dirs = '''$(printf "%s\n" "${FZF_DIRS[@]}")'''.strip().split('\n')
dirs = [os.path.realpath(i) for i in dirs]
print('\n'.join(dirs), end='')
EOF
)
    printf "%s\n" "${dirs[@]}" | fzf --prompt="Select a directory: " --preview='rg --max-depth=5 --files {} | sed "s|^"{}"/||" | tree --fromfile -L 5 -C | sed "1i"{}' --ansi
}

jd() { dir=$(fzf_dir); [ $? -eq 0 ] && cd $dir }

jt() {
    dir=$(fzf_dir)
    if [ $? -ne 0 ]; then
        return 1
    fi

    base_name=$(basename $dir | tr . _)
    name="~ $base_name" 

    if ! tmux has-session -t=$name 2> /dev/null; then
        tmux new-session -ds $name -c $dir "nvim; zsh" \; split-window -v -p 20 \; select-pane -t 0
    fi

    if [[ -z $TMUX ]]; then
        tmux attach-session -t $name
    else
        tmux switch-client -t $name
    fi
}

jv() {
    dir=$(fzf_dir)
    if [ $? -ne 0 ]; then
        return 1
    fi

    base_name=$(basename $dir | tr . _)
    name="~ $base_name" 

    if ! tmux has-session -t=$name 2> /dev/null; then
        tmux new-session -ds $name -c $dir "nvim; zsh"
    fi

    if [[ -z $TMUX ]]; then
        tmux attach-session -t $name
    else
        tmux switch-client -t $name
    fi
}

jm() {
    dir=$(fzf_dir)
    if [ $? -ne 0 ]; then
        return 1
    fi

    base_name=$(basename $dir | tr . _)
    name="~ $base_name" 

    if ! tmux has-session -t=$name 2> /dev/null; then
        tmux new-session -ds $name -c $dir
    fi

    if [[ -z $TMUX ]]; then
        tmux attach-session -t $name
    else
        tmux switch-client -t $name
    fi
}

# temporarily source an env file
# xenv ./.env ./script.sh
xenv() { (set -a && source "$1" && shift && "$@" ); }

## aliases ##
alias sz='. ~/.zshrc'
alias ez='vim ~/.zshrc'
alias ec='vim ~/dotfiles/gypsum/cheat'
alias ev='vim ~/dotfiles/gypsum/.config/nvim'
alias v=vimcd

alias md='medea --trim'
alias clip='xclip -selection clipboard'
alias sclip="scrot -s -e 'xclip -selection clipboard -t image/png -i $f'"
alias vim=vimcd
alias nvim=vimcd
alias tv=tvim
alias py='python3'
alias notes="vim $HOME/syncthing/notes/The\ Vault\ v2"

alias gs='git status --short -b'
alias ga='git add'
alias gcm='git commit -m'
alias gr='git reset'
alias gd='git difftool --dir-diff'
alias gm='git mergetool'

alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

hash -d vs="$HOME/dotfiles/gypsum/.config/nvim"
hash -d vl="$HOME/.local/state/nvim"
hash -d p="$HOME/projects"

alias gcloud="docker run --rm \
    -v $(pwd):/app \
    -it \
    --user $(id -u):$(id -g) \
    -v ~/gcloud/config/:/config/mygcloud \
    -e CLOUDSDK_CONFIG=/config/mygcloud \
    -v ~/gcloud/certs/:/certs \
    -w /app \
    --entrypoint gcloud \
    gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine"


## bindings ##

zle -N cheat

KEYTIMEOUT=1 # 10 ms key timeout
bindkey -M vicmd '  ' cheat # <leader><leader>
# map <leader> to circumvent 10ms timeout when activating cheat
bindkey -M vicmd ' ' undefined-key 

## python ##
VIRTUAL_ENV_DISABLE_PROMPT=1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f "/home/noah/.ghcup/env" ] && . "/home/noah/.ghcup/env" # ghcup-env

