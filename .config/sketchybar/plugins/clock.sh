#!/bin/sh

# 顯示日期、星期與時間，例如：2026-10-20 二 14:26
# %u：1=星期一 ... 7=星期日

case "$(date +%u)" in
  1) WD=一 ;;
  2) WD=二 ;;
  3) WD=三 ;;
  4) WD=四 ;;
  5) WD=五 ;;
  6) WD=六 ;;
  7) WD=日 ;;
  *) WD= ;;
esac

sketchybar --set "$NAME" label="$(date '+%Y-%m-%d') $WD $(date '+%H:%M')"
