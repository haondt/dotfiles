#!/bin/bash

# Get the focused workspace and all leaf window IDs
TREE=$(swaymsg -t get_tree)

FOCUSED_ID=$(echo "$TREE" | jq '.. | select(.focused? == true) | .id')

# Collect all leaf window IDs
WINDOW_IDS=($(echo "$TREE" | jq "
  first(.. | select(.type? == \"workspace\" and
    (any(recurse(.nodes[]?, .floating_nodes[]?); .focused? == true)))) |
  [recurse(.nodes[]?, .floating_nodes[]?) | select(.pid? and .id?)] | map(.id) | sort | .[]
"))

N=${#WINDOW_IDS[@]}

if [ "$N" -le 1 ]; then
    exit 0
fi

# Define columns as arrays of row counts
case $N in
    2)  COLS=(1 1) ;;
    3)  COLS=(1 1 1) ;;
    4)  COLS=(2 2) ;;
    5)  COLS=(2 2 1) ;;
    6)  COLS=(2 2 2) ;;
    7)  COLS=(2 2 2 1) ;;
    8)  COLS=(2 2 2 2) ;;
    9)  COLS=(3 2 2 2) ;;
    10) COLS=(3 3 2 2) ;;
    11) COLS=(3 3 3 2) ;;
    12) COLS=(3 3 3 3) ;;
    *)
        MAX_ROWS=$(echo "scale=0; sqrt($N) + 0.999" | bc | cut -d. -f1)
        NUM_COLS=$(( (N + MAX_ROWS - 1) / MAX_ROWS ))
        REMAINDER=$(( N % NUM_COLS ))
        BASE=$(( N / NUM_COLS ))
        COLS=()
        for ((i=0; i<NUM_COLS; i++)); do
            if [ "$REMAINDER" -gt 0 ] && [ "$i" -lt "$REMAINDER" ]; then
                COLS+=($((BASE + 1)))
            else
                COLS+=($BASE)
            fi
        done
        ;;
esac

# Calculate the index of the first window in each column
COL_STARTS=(0)
for ((COL=0; COL<${#COLS[@]}-1; COL++)); do
    COL_STARTS+=($(( COL_STARTS[$COL] + COLS[$COL] )))
done

# Get monitor width
MONITOR_WIDTH=$(swaymsg -t get_outputs | jq '.[] | select(.focused) | .current_mode.width')

# Unfloat all windows
for ID in "${WINDOW_IDS[@]}"; do
    swaymsg "[con_id=$ID] floating disable" 2>/dev/null
done

# Move all windows to temp workspace to reset nesting
for ID in "${WINDOW_IDS[@]}"; do
    swaymsg "[con_id=$ID] move to workspace 99" 2>/dev/null
done

# Move first window to workspace and set layout splith
FIRST_ID=${WINDOW_IDS[0]}
swaymsg "[con_id=$FIRST_ID] move to workspace current"
swaymsg "[con_id=$FIRST_ID] focus"
swaymsg "layout splith"

# Move the first window of each column — all land as flat siblings
for ((COL=1; COL<${#COLS[@]}; COL++)); do
    ID=${WINDOW_IDS[${COL_STARTS[$COL]}]}
    swaymsg "[con_id=$ID] move to workspace current"
done

# Stack remaining windows vertically within each column
for ((COL=0; COL<${#COLS[@]}; COL++)); do
    START=${COL_STARTS[$COL]}
    ROWS=${COLS[$COL]}
    TOP_ID=${WINDOW_IDS[$START]}

    if [ "$ROWS" -gt 1 ]; then
        swaymsg "[con_id=$TOP_ID] focus"
        swaymsg "split v"
        # Move second window to create the splitv container
        ID=${WINDOW_IDS[$((START + 1))]}
        swaymsg "[con_id=$ID] move to workspace current"
        swaymsg "[con_id=$TOP_ID] focus"
        swaymsg "layout splitv"

        # Now move remaining windows — they should land flat in the splitv
        for ((ROW=2; ROW<ROWS; ROW++)); do
            ID=${WINDOW_IDS[$((START + ROW))]}
            swaymsg "[con_id=$ID] move to workspace current"
        done
    fi
done

# Equalize column widths in px
NUM_COLS=${#COLS[@]}
COL_WIDTH=$(( MONITOR_WIDTH / NUM_COLS ))
for ((COL=0; COL<NUM_COLS; COL++)); do
    ID=${WINDOW_IDS[${COL_STARTS[$COL]}]}
    swaymsg "[con_id=$ID] resize set width ${COL_WIDTH} px"
done

# Switch back from temp workspace
swaymsg "workspace 99" 2>/dev/null && swaymsg "workspace back_and_forth" 2>/dev/null

swaymsg "[con_id=$FOCUSED_ID] focus"
