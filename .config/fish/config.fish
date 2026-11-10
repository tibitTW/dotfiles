#!/opt/homebrew/bin/fish

if status is-login
    source $HOME/dotfiles/scripts/load_api_keys.fish || echo "load api keys failed!"

    # ----------------------------- tools ----------------------------- #
    if test (uname) = Darwin
        eval "$(/opt/homebrew/bin/brew shellenv)"
    end

    set -gx EDITOR hx

    # ----------------------- dev framework / languages ----------------------- #
    if test -f "$HOME/.cargo/env.fish":
        source "$HOME/.cargo/env.fish"
    end

    # zvm 本體由 nix 提供，這裡只需要 zvm 安裝的 zig
    set PATH $PATH $HOME/.zvm/bin

    # fundle plugin FabioAntunes/fish-nvm
    # fundle plugin edc/bass
    # fundle init

    set -gx ASEPRITE_HOME "$HOME/tools/aseprite"

    set PATH $PATH ~/go/bin

    # amp / pi
    set PATH $PATH ~/.local/bin

    # bun
    set PATH $PATH ~/.bun/bin
end

if status is-interactive
    # Commands to run in interactive sessions can go here

    # alias python="python3"
    abbr -a l "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
    abbr -a ls "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
    abbr -a ll "eza --color=always --long --git --icons=always --all"
    abbr -a cls clear
    abbr -a q exit
    abbr -a ipy ipython
    abbr -a lg lazygit
    abbr -a pping prettyping
    abbr -a zlj zellij

    alias vercel='npx --yes vercel -t $VERCEL_KEY'

    # --- git alias --- #
    abbr -a ga 'git add'
    abbr -a gap 'ga --patch'
    abbr -a gb 'git branch'
    abbr -a gba 'gb --all'
    abbr -a gc 'git commit'
    abbr -a gca 'gc --amend --no-edit'
    abbr -a gce 'gc --amend'
    abbr -a gco 'git checkout'
    abbr -a gcl 'git clone --recursive'
    abbr -a gd 'git diff'
    abbr -a gds 'gd --staged'
    abbr -a gi 'git init'
    abbr -a gl 'git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
    abbr -a gm 'git merge'
    abbr -a gn 'git checkout -b' # new branch
    abbr -a gp 'git push'
    abbr -a gpf 'git push -f'
    abbr -a gr 'git reset'
    abbr -a gss 'git status --short'
    abbr -a gu 'git pull'

    # -------------------- tools -------------------- #
    # use starship for prompt customize
    set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
    starship init fish | source
    zoxide init fish | source
    fzf --fish | source
    direnv hook fish | source

    function python_venv --on-variable PWD
        set myvenv ./.venv
        if test -d $myvenv
            source $myvenv/bin/activate.fish
        else if type -q deactivate
            deactivate
        end
    end
end

if test "$TERM_PROGRAM" = ghostty
    set -x TERM xterm-256color
end
