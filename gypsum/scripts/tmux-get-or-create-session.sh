#!/bin/zsh

sessions=$(tmux list-sessions -F "#S")
selected_session=$(echo "$sessions" | fzf --prompt="select or create session: " --print-query)
selected_status=$?

name=$(python3 << EOF
status='''$selected_status'''
status = int(status.strip())
session='''$selected_session'''
if status == 1:
    if '\n' not in session and len(session) > 0:
        print(session) # create new session
        exit(0)
if status != 0:
    exit(status)
print(session.split('\n')[-1])
EOF
)

if [ $? -ne 0 ]; then
    return 1
fi

if ! tmux has-session -t=$name 2> /dev/null; then
    tmux new-session -ds $name -c ~
fi

if [[ -z $TMUX ]]; then
    tmux attach-session -t $name
else
    tmux switch-client -t $name
fi
