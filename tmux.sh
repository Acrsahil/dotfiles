#!/bin/bash

SESSION_NAME="CPP"

# Check if the session exists
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? != 0 ]; then
    # Session does not exist, launch a regular tmux session
    tmux
else
    # Session exists, attach to it
    tmux attach-session -t $SESSION_NAME
fi
