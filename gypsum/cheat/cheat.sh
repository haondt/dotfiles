#!/bin/bash

files=$(ls "${HOME}/dotfiles/gypsum/cheat" | grep yml | sed 's/\.yml$//')
submenu=$(echo  "$files" | rofi -dmenu -format s -p '[help]')
if [ -e "${HOME}/dotfiles/gypsum/cheat/$submenu.yml" ]; then
	cat "${HOME}/dotfiles/gypsum/cheat/$submenu.yml" \
		| yq  -r '.[] | "\(.description)#\(.command)#tags:\(.tags // [] | join(","))"' \
		| column -t -s "#" \
		| rofi -dmenu -i -p "[$submenu]"
fi
