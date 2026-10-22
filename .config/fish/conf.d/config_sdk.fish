if test (uname) = Darwin
    # macOS:使用 Homebrew 安裝的 SDKMAN
    if test -d /opt/homebrew/opt/SDKMAN-cli/libexec
        set -g __sdkman_custom_dir /opt/homebrew/opt/SDKMAN-cli/libexec
    end
end
# Linux:不設定,sdk.fish 會自動 fallback 到 $HOME/.sdkman

# 若繼承到的 SDKMAN_DIR 指向不存在/不完整的安裝(例如從 macOS 同步過來,
# 或上一個 fish 被 sdk.fish 匯出的殘留),先清掉,免得 sdk.fish 噴 WARNING。
# 本檔在 conf.d 內依字母序會比 sdk.fish 更早載入,所以可以在這裡攔截。
if set -q SDKMAN_DIR; and not test -f "$SDKMAN_DIR/bin/sdkman-init.sh"
    set -e SDKMAN_DIR
end
