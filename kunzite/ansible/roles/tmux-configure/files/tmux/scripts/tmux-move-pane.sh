#!/bin/bash
TARGET="$1"
SOURCE=$(tmux display-message -p '#{window_index}')

if tmux select-window -t ":$TARGET" 2>/dev/null; then
  tmux move-pane -s ":$SOURCE" -t ":$TARGET"
else
  tmux break-pane -t ":$TARGET"
fi
