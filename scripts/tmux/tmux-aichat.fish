#!/usr/bin/env fish

set SESSION aichat

# 如果 session 已存在就直接 attach
if tmux has-session -t $SESSION 2>/dev/null
    tmux attach-session -t $SESSION
    exit 0
end

# 建立新 session
tmux new-session -d -s $SESSION

# 左右分割
tmux split-window -h -t $SESSION

sleep 0.3

# 左邊 pane（pane 0）
tmux send-keys -t $SESSION:1.1 "aichat -r program-agent" Enter

# 右邊 pane（pane 1）
tmux send-keys -t $SESSION:1.2 "aichat -r english-translator" Enter

# attach
tmux attach-session -t $SESSION
