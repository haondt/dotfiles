#!/bin/zsh

dir=$(~/.local/bin/kunzite/fzf_dir.sh)
if [ $? -ne 0 ]; then
    return 1
fi

base_name=$(basename $dir | tr . _)
name="~ $base_name" 

if ! tmux has-session -t=$name 2> /dev/null; then
    eval "tmux new-session -ds \$name -c \$dir " "$1"
fi

if [[ -z $TMUX ]]; then
    tmux attach-session -t $name
else
    tmux switch-client -t $name
fi
