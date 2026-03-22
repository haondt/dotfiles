#!/bin/bash
TARGET="$1"
tmux select-window -t ":$TARGET" 2>/dev/null || tmux new-window -t "$TARGET"
