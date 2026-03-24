-- 定義一個監聽 Heptabase 的過濾器
local heptaFilter = hs.window.filter.new('Heptabase')

-- 當 Heptabase 視窗獲得焦點 (Focused) 時觸發
heptaFilter:subscribe(hs.window.filter.windowFocused, function(window, appName)
    print("Heptabase Focused! 正在自動調整縮放...")

    -- 建議加入微小的延遲，確保 App 已經完全準備好接收指令
    hs.timer.doAfter(0.01, function()
        -- 這裡模擬按下 Cmd + + (等於 Cmd 和 =)
        -- 如果你想先重置再縮放，可以先送一個 {"cmd"}, "0"
        hs.eventtap.keyStroke({"cmd"}, "0", 0) 
        hs.eventtap.keyStroke({"cmd"}, "-", 0) 
        hs.eventtap.keyStroke({"cmd"}, "-", 0)
    end)
end)
