#!/bin/zsh

fzf_dir_array=(
    "$HOME/syncthing/notes/The Vault v2"
    "$HOME/dotfiles/gypsum"
)
fzf_dir_array+=($HOME/projects/*)
FZF_DIRS=$(printf "%s\n" "${fzf_dir_array[@]}")
