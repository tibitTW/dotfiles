#!/usr/bin/env bash
# 取代 sketchybar 對 type=space item 的預設 highlight script，
# 除了切 icon.highlight（文字顏色）之外，連 icon.background.color 也一起切，
# 因為 background 沒有 highlight_color 這個屬性可以直接用。
# FOREGROUND / BACKGROUND 由 sketchybarrc 透過 script= 字串帶進來，跟 bar 其他地方同一份設定。

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" icon.highlight=on icon.background.color=$FOREGROUND
else
  sketchybar --set "$NAME" icon.highlight=off icon.background.color=$BACKGROUND
fi
