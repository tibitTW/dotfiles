#!/bin/zsh

source ~/.zshrc_secret

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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export ASEPRITE_HOME="$HOME/tools/aseprite"

# export JAVA_HOME="$(/usr/libexec/java_home)"

export PATH=$PATH:~/go/bin

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# export DOTNET_ROOT=/usr/local/share/dotnet

# ---                     zsh extensions                        --- #

# use starship for prompt customize
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# zsh syntax hightlighting & auto suggestion
source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244,bold'
bindkey '^I^I' autosuggest-accept

# export ZPLUG_HOME=/opt/homebrew/opt/zplug
# source $ZPLUG_HOME/init.zsh

export PATH=$PATH:~/scripts/:~/music-maker/alda/

# AnyBar script
function anybar { echo -n $1 | nc -4u -w0 localhost ${2:-1738}; }

preexec() {
  anybar yellow
}

precmd() {
  local EXIT_CODE=$?
  if [ $EXIT_CODE -eq 0 ]; then
    anybar green
  else
    anybar red
  fi
}

# fzf code

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh --color=16)"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# fzf-git setup
source /etc/fzf-git.sh

# ---- Eza (better ls) -----
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza --color=always --long --git --icons=always --all"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
# alias cd="z"

# ------ Yazi (file manager) ------
function yy() {
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

