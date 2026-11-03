#!/bin/sh

# 點擊番茄鐘（Flow App）item
# 左鍵：切換開始/暫停，用 flow.sh 每秒更新時記錄的執行狀態判斷，點擊時不用再等待
# 右鍵：開啟 Flow 視窗（App 未啟動的話先啟動它）

STATE_FILE="/tmp/sketchybar_flow_state"

if [ "$BUTTON" = "right" ]; then
  if ! pgrep -xq Flow; then
    open -ga "Flow"
    sleep 1
  fi
  osascript -e 'tell application "Flow" to show' >/dev/null 2>&1
else
  RUNNING=$(cat "${STATE_FILE}.running" 2>/dev/null)
  if [ "$RUNNING" = "running" ]; then
    osascript -e 'tell application "Flow" to stop' >/dev/null 2>&1
  else
    osascript -e 'tell application "Flow" to start' >/dev/null 2>&1
  fi
fi

# 立刻刷新顯示，不用等下一次 update_freq
"$CONFIG_DIR/plugins/flow.sh"
