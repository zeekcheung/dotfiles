#!/usr/bin/env fish

set session_name "main"

# check if main session exists
if tmux has-session -t $session_name
    tmux attach-session -t $session_name
else
    tmux new-session -s $session_name
end
