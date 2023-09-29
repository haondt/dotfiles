#!/bin/bash

files=$(ls "${HOME}/dotfiles/gypsum/cheat" | grep json | sed 's/\.json$//')
submenu=$(echo  "$files" | rofi -dmenu -format s -p '[help]')
if [ -e "${HOME}/dotfiles/gypsum/cheat/$submenu.json" ]; then
	cat "${HOME}/dotfiles/gypsum/cheat/$submenu.json" \
		| jq  -r '.[] | "\(.description)#\(.command)#tags:\(.tags | join(","))"' \
		| column -t -s "#" \
		| rofi -dmenu -i -p "[$submenu]"
fi
