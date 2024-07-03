#!/bin/zsh

. ~/dotfiles/gypsum/scripts/fzf_dirs.sh

dirs=$(python3 << EOF
import os
dirs = '''${FZF_DIRS[@]}'''.strip().split('\n')
dirs = [os.path.realpath(i) for i in dirs]
print('\n'.join(dirs), end='')
EOF
)

printf "%s\n" "${dirs[@]}" | fzf --prompt="Select a directory: " --preview='rg --max-depth=5 --files {} | sed "s|^"{}"/||" | tree --fromfile -L 5 -C | sed "1i"{}' --ansi
