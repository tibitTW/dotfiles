#!/opt/homebrew/bin/fish
if status is-login
    source $HOME/dotfiles/scripts/load_api_keys.fish

    # ----------------------------- tools ----------------------------- #
    eval "$(/opt/homebrew/bin/brew shellenv)"

    set -gx EDITOR vim

    # TODO: replace to fish version
    # bindkey '^I^I' autosuggest-accept

    # Yazi (file manager)
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    # Zoxide
    zoxide init fish | source

    # Set up fzf key bindings
    fzf --fish | source

    # ----------------------- dev framework / languages ----------------------- #
    source "$HOME/.cargo/env.fish"

    # fundle plugin FabioAntunes/fish-nvm
    # fundle plugin edc/bass
    # fundle init

    set ASEPRITE_HOME "$HOME/tools/aseprite"

    # set JAVA_HOME "$(/usr/libexec/java_home)"
    # set -x PATH $JAVA_HOME/bin $PATH

    set PATH $PATH ~/go/bin

    # export DOTNET_ROOT /usr/local/share/dotnet
end

if test "$TERM_PROGRAM" = ghostty
    set -x TERM xterm-256color
end

if status is-interactive
    # Commands to run in interactive sessions can go here

    alias python="python3"
    alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
    alias l="ls"
    alias ll="eza --color=always --long --git --icons=always --all"
    alias cls="clear"
    alias q="exit"
    alias ipy="ipython"
    alias lg="lazygit"
    alias pping="prettyping"
    alias zlj="zellij"

    alias vercel="vercel -t $VERCEL_KEY"

    # --- git alias --- #
    alias ga='git add'
    alias gap='ga --patch'
    alias gb='git branch'
    alias gba='gb --all'
    alias gc='git commit'
    alias gca='gc --amend --no-edit'
    alias gce='gc --amend'
    alias gco='git checkout'
    alias gcl='git clone --recursive'
    alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
    alias gds='gd --staged'
    alias gi='git init'
    alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
    alias gm='git merge'
    alias gn='git checkout -b' # new branch
    alias gp='git push'
    alias gpf='git push -f'
    alias gr='git reset'
    alias gss='git status --short'
    alias gu='git pull'

    # -------------------- tools -------------------- #
    # use starship for prompt customize
    set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
    starship init fish | source
end
