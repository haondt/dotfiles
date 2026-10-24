#!/bin/bash
HEIGHT=$(swaymsg -t get_tree | jq '.. | select(.focused? == true) | .window_rect.height')
WIDTH=$(( (HEIGHT * 16 + 4) / 9 ))   # +4 rounds to nearest instead of truncating
swaymsg "resize set width ${WIDTH} px"
