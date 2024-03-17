## zsh setup ##
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="haondt"
plugins=(vi-mode)
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
            RETURN_PATH=$(pwd); cd $1 && \nvim -c "cd $1" && cd $RETURN_PATH
        else # arg is file
            local file_dir=$(dirname "$1")
            RETURN_PATH=$(pwd); cd $file_dir && \nvim -c "edit $1" && cd $RETURN_PATH
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
        local cwd=$(pwd)
        local target="$1"

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

fzf_dir() {
  local dirs=()
  local command_to_run="$1"
  shift

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -p|--parent)
        shift
        if [ -d "$1" ]; then
          while IFS= read -r -d '' dir; do
              dirs+=("$dir")
          done < <(find "$1" -maxdepth 1 -type d -not -name "$(basename "$1")" -print0)
        fi
        ;;
      -d|--directory)
        shift
        if [ -d "$1" ]; then
          dirs+=( "$1" )
        fi
        ;;
      *)
        echo "Unknown option: $1"
        return 1
        ;;
    esac
    shift
  done

  if [ "${#dirs[@]}" -eq 0 ]; then
    echo "No valid directories found."
    return 1
  fi

  local selected_dir
  selected_dir=$(printf "%s\n" "${dirs[@]}" | fzf --prompt="Select a directory: " --preview='rg --max-depth=5 --files {} | sed "s|^"{}"/||" | tree --fromfile -L 5 -C | sed "1i"{}' --ansi)

  if [ -n "$selected_dir" ]; then
    $command_to_run "$selected_dir"
  else
    echo "No directory selected."
    return 1
  fi
}



FZF_RUN_ARGS=(
    "-d" "$HOME/syncthing/notes/The Vault v2"
    "-p" "$HOME/projects"
    "-d" "$HOME/dotfiles/gypsum"
)

jt() { fzf_dir tvim "${FZF_RUN_ARGS[@]}" }
jv() { fzf_dir vimcd "${FZF_RUN_ARGS[@]}" }
jd() { fzf_dir cd "${FZF_RUN_ARGS[@]}" }

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
