#!/bin/sh

# 點擊電池 item 時開啟 AlDente 的選單列面板
# AlDente 沒有 CLI/URL scheme，只能先確保它在跑，
# 再用 System Events 點擊它在選單列右側的 status item 來開面板
# （需要給終端機/sketchybar 輔助使用權限才能點擊成功）

if ! pgrep -xq "AlDente"; then
  open -ga "AlDente"
  sleep 1
fi

osascript -e '
tell application "System Events"
	tell process "AlDente"
		set frontmost to true
		click menu bar item 1 of menu bar 2
	end tell
end tell'
