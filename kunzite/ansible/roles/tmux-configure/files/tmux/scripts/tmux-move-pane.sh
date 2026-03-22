# #!/bin/bash
# TARGET="$1"
# tmux select-window -t ":$TARGET" 2>/dev/null || tmux new-window -t "$TARGET"
# tmux move-pane -t ":$TARGET"

# #!/bin/bash
# TARGET="$1"
# PANE=$(tmux display-message -p '#{pane_id}')
# tmux select-window -t ":$TARGET" 2>/dev/null || tmux new-window -t "$TARGET"
# tmux move-pane -s "$PANE" -t ":$TARGET"

# #!/bin/bash
# TARGET="$1"
# if tmux select-window -t ":$TARGET" 2>/dev/null; then
#   tmux move-pane -t ":$TARGET"
# else
#   tmux break-pane -t ":$TARGET"
# fi

#!/bin/bash
TARGET="$1"
SOURCE=$(tmux display-message -p '#{window_index}')

if tmux select-window -t ":$TARGET" 2>/dev/null; then
  tmux move-pane -s ":$SOURCE" -t ":$TARGET"
else
  tmux break-pane -t ":$TARGET"
fi
