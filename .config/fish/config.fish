#!/opt/homebrew/bin/fish

if status is-login
    source $HOME/dotfiles/.config/fish/config_secret.fish

    # ----------------------------- tools ----------------------------- #
    eval "$(/opt/homebrew/bin/brew shellenv)"
    set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml

    set -gx EDITOR hx

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

    function fish_prompt_anybar --on-event fish_prompt
        set -l last_status $status
        if test $last_status -eq 0
            anybar green
        else
            anybar red
        end
    end

    # Zoxide
    zoxide init fish | source

    # ----------------------- dev framework / languages ----------------------- #
    source "$HOME/.cargo/env.fish"

    # set NVM_DIR "$HOME/.nvm"
    # [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    # [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    set ASEPRITE_HOME "$HOME/tools/aseprite"

    # set JAVA_HOME "$(/usr/libexec/java_home)"

    set PATH $PATH ~/go/bin

    set PYENV_ROOT "$HOME/.pyenv"

    command -v pyenv >/dev/null || set PATH $PYENV_ROOT/bin $PATH
    eval "$(pyenv init -)"

    # export DOTNET_ROOT /usr/local/share/dotnet
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
    starship init fish | source
end
