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

-- 滑鼠移到螢幕最上緣、系統自動隱藏的選單列要彈出時，先把 sketchybar 藏起來，
-- 避免兩條 bar 疊在一起；滑鼠離開 sketchybar 的區域後再把它顯示回來。
local SKETCHYBAR_BIN = "/opt/homebrew/bin/sketchybar"
local REVEAL_Y = 2    -- 滑鼠 y <= 這個值，視為正在觸發系統選單列彈出
local RESTORE_Y = 34  -- sketchybar 的 y_offset(6) + height(28)，滑鼠離開這個範圍才恢復顯示

local sketchybarHiddenByUs = false
local menuBarAutoHideEnabled = true

local function setSketchybarHidden(hidden)
    if hidden == sketchybarHiddenByUs then return end
    sketchybarHiddenByUs = hidden
    hs.execute(SKETCHYBAR_BIN .. " --bar hidden=" .. (hidden and "on" or "off"))
end

-- 找出全域座標系裡 y 最小（也就是實際擺在最上面）的那個螢幕，
-- 不依賴系統「主螢幕」設定——這樣就算選單列不是設在主螢幕上，
-- 邏輯仍然對應到你真正用滑鼠頂上去的那台螢幕。
local function getTopmostScreen()
    local screens = hs.screen.allScreens()
    local top = screens[1]
    for i = 2, #screens do
        if screens[i]:fullFrame().y < top:fullFrame().y then
            top = screens[i]
        end
    end
    return top
end

-- 每 100ms 檢查一次滑鼠位置，決定要不要藏 sketchybar
--
-- 注意：多螢幕上下疊放時，其他螢幕的座標在全域座標系裡可能跟最上面那台
-- 螢幕的頂緣座標很接近，所以一定要先確認滑鼠真的落在最上面那台螢幕的
-- x/y 範圍內，才去判斷是不是在頂緣，否則滑鼠移到別台螢幕也可能誤判。
menubarRevealWatcher = hs.timer.doEvery(0.1, function()
    if not menuBarAutoHideEnabled then return end

    local screen = getTopmostScreen()
    if not screen then return end
    local frame = screen:fullFrame()

    local pos = hs.mouse.absolutePosition()
    local onTopScreen = pos.x >= frame.x and pos.x < frame.x + frame.w
        and pos.y >= frame.y and pos.y < frame.y + frame.h

    if not onTopScreen then
        -- 滑鼠不在最上面那台螢幕上，沒有理由繼續藏著
        setSketchybarHidden(false)
        return
    end

    local relY = pos.y - frame.y
    if relY <= REVEAL_Y then
        setSketchybarHidden(true)
    elseif relY > RESTORE_Y then
        setSketchybarHidden(false)
    end
end)

-- 每 2 秒確認一次系統「自動隱藏/顯示選單列」設定是否還開著，
-- 如果使用者把它關掉了，就不要再亂藏 sketchybar
menuBarSettingWatcher = hs.timer.doEvery(2, function()
    local ok, out = pcall(hs.execute, "defaults read -g _HIHideMenuBar 2>/dev/null")
    local enabled = ok and out ~= nil and out:match("1") ~= nil
    menuBarAutoHideEnabled = enabled
    if not enabled and sketchybarHiddenByUs then
        setSketchybarHidden(false)
    end
end)
