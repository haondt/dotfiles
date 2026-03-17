#!/bin/zsh

fzf_dir_array=(
    "$HOME/projects/dotfiles/gypsum"
    "$HOME/projects/dotfiles/kunzite"
)
fzf_dir_array+=($HOME/projects/*)
FZF_DIRS=$(printf "%s\n" "${fzf_dir_array[@]}")
