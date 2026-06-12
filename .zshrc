#!/bin/zsh

source $HOME/dotfiles/scripts/load_api_keys.zsh

# revised with eza
# alias ls="exa"
alias l="ls"
# alias ll="l -lah"
alias cls="clear"
alias q="exit"
alias ipy="ipython"
alias lg="lazygit"
alias pping="prettyping"

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
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gpf='git push -f'
alias gr='git reset'
alias gss='git status --short'
alias gu='git pull'

# ---                     dev framework / languages                        --- #

. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export ASEPRITE_HOME="$HOME/tools/aseprite"

export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export JAVA_HOME="$(/usr/libexec/java_home)"

export PATH=$PATH:~/go/bin

export DOTNET_ROOT=/usr/local/share/dotnet

# ---                     zsh extensions                        --- #

# Set up fzf key bindings and fuzzy completion
# eval "$(fzf --zsh --color=16)"

# -- Use fd instead of fzf --

# export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
# _fzf_compgen_path() {
#   fd --hidden --exclude .git . "$1"
# }

# # Use fd to generate the list for directory completion
# _fzf_compgen_dir() {
#   fd --type=d --hidden --exclude .git . "$1"
# }

# # fzf-git setup
# source /etc/fzf-git.sh

# starship
eval "$(starship init zsh)"

# ---- Eza (better ls) -----
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza --color=always --long --git --icons=always --all"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
# alias cd="z"

# ------ Yazi (file manager) ------
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

export PATH=$PATH:~/tools

# ----------- Lazygit -------------
# use nvim as default editor
# if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
#     export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
#     export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
# else
#     export VISUAL="nvim"
#     export EDITOR="nvim"
# fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/chunhua/.sdkman"
[[ -s "/Users/chunhua/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/chunhua/.sdkman/bin/sdkman-init.sh"

# Amp CLI
export PATH="$HOME/.local/bin:$PATH"
