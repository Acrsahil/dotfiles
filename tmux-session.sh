#!/bin/bash

# Check if a tmux session is already running
if tmux ls &>/dev/null; then
    # Attach to the existing session
    tmux attach-session
else
    # Start a new tmux session with the name "my_session"
    tmux new-session -s my_session
fi
