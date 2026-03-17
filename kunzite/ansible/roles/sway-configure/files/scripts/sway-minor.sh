#!/bin/bash
WIDTH=$(swaymsg -t get_outputs | jq '.[] | select(.focused) | .current_mode.width')
THIRD=$(( WIDTH / 3 ))
swaymsg "resize set width ${THIRD} px"
