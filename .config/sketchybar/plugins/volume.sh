#!/bin/sh

# 支援兩種觸發方式：
# 1. volume_change 事件：音量百分比會透過 $INFO 傳入
# 2. update_freq 定時輪詢：用 osascript 直接查詢目前音量/靜音狀態

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
  MUTED="false"
else
  VOLUME="$(osascript -e 'output volume of (get volume settings)')"
  MUTED="$(osascript -e 'output muted of (get volume settings)')"
fi

if [ "$MUTED" = "true" ] || [ "$VOLUME" = "0" ]; then
  ICON=""
else
  case "$VOLUME" in
    [6-9][0-9]|100) ICON=""
    ;;
    [3-5][0-9]) ICON=""
    ;;
    [1-9]|[1-2][0-9]) ICON=""
    ;;
    *) ICON=""
  esac
fi

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
