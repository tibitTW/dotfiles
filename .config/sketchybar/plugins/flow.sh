#!/bin/sh

# 更新番茄鐘（Flow App）倒數顯示
# Flow 有 AppleScript 字典（Flow.sdef），getTime 會直接回傳 "MM:SS" 格式的倒數字串
#
# Flow 沒有提供「是否正在倒數」的查詢，所以順便用「這秒跟上一秒的時間有沒有變化」
# 記錄執行狀態到 STATE_FILE，讓 flow_click.sh 點擊時可以直接讀，不用自己再等一秒判斷

STATE_FILE="/tmp/sketchybar_flow_state"
LAST_TIME=$(cat "$STATE_FILE" 2>/dev/null)

TIME=$(osascript -e 'tell application "Flow" to getTime' 2>/dev/null)

# 目前這輪（sessionCount 個一輪）第幾個：Flow 自己的 dailyCount/lastCompletedFlows
# 是今天累積的總數，不等於目前這輪的進度（而且會被手動 skip 等操作弄亂），所以改成
# 自己在本機追蹤：每次偵測到「從專注切到休息」就代表完成一個，進度 +1（滿一輪歸零），
# 用 nf-md-circle_slice_2/4/6/8 這組「圓圈每次多填 1/4」的圖示表示
ROUND_STATE_FILE="/tmp/sketchybar_flow_round_count"
PREV_PHASE_FILE="/tmp/sketchybar_flow_prev_phase"

SESSION_COUNT=$(defaults read design.yugen.Flow sessionCount 2>/dev/null)
[ -z "$SESSION_COUNT" ] || [ "$SESSION_COUNT" -le 0 ] 2>/dev/null && SESSION_COUNT=4

PHASE=$(osascript -e 'tell application "Flow" to getPhase' 2>/dev/null)
PREV_PHASE=$(cat "$PREV_PHASE_FILE" 2>/dev/null)
ROUND_COUNT=$(cat "$ROUND_STATE_FILE" 2>/dev/null)
case "$ROUND_COUNT" in '' | *[!0-9]*) ROUND_COUNT=0 ;; esac

case "$PHASE" in
  *休息*) IS_BREAK=1 ;;
  *) IS_BREAK=0 ;;
esac
case "$PREV_PHASE" in
  *休息*) PREV_WAS_BREAK=1 ;;
  *) PREV_WAS_BREAK=0 ;;
esac

# 剛從專注切到休息：代表完成了這輪的下一個，進度 +1（滿一輪就歸零開始新的一輪）
if [ "$IS_BREAK" = 1 ] && [ "$PREV_WAS_BREAK" = 0 ] && [ -n "$PREV_PHASE" ]; then
  ROUND_COUNT=$(((ROUND_COUNT + 1) % SESSION_COUNT))
fi
echo "$PHASE" >"$PREV_PHASE_FILE"
echo "$ROUND_COUNT" >"$ROUND_STATE_FILE"

case "$ROUND_COUNT" in
  0) ICON=$'󰝦' ;; # circle_slice_2 (U+F0A9F)，第 1 個
  1) ICON=$'󰪟' ;; # circle_slice_4 (U+F0AA1)，第 2 個
  2) ICON=$'󰪡' ;; # circle_slice_6 (U+F0AA3)，第 3 個
  *) ICON=$'󰪥' ;; # circle_slice_8 (U+F0AA5)，第 4 個
esac

# 休息時間把 icon/label 改成綠色，其餘時間維持預設白色
if [ "$IS_BREAK" = 1 ]; then
  COLOR=0xff5ed91a
else
  COLOR=$FOREGROUND
fi
sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label.color="$COLOR"

if [ -z "$TIME" ]; then
  sketchybar --set "$NAME" label="--:--"
else
  sketchybar --set "$NAME" label="$TIME"
  if [ -n "$LAST_TIME" ] && [ "$LAST_TIME" != "$TIME" ]; then
    echo "running" >"${STATE_FILE}.running"
  else
    echo "paused" >"${STATE_FILE}.running"
  fi
  echo "$TIME" >"$STATE_FILE"
fi
