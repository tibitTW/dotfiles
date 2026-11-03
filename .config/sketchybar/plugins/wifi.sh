#!/bin/sh

# 偵測 Wi-Fi (en0) 是否已取得 IP，藉此判斷連線狀態
IP="$(ipconfig getifaddr en0 2>/dev/null)"

if [ -n "$IP" ]; then
  ICON="󰤨"
else
  ICON="󰤭"
fi

sketchybar --set "$NAME" icon="$ICON"
