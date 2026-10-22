#!/bin/zsh

source $HOME/dotfiles/scripts/load_api_keys.zsh

# ---                     dev framework / languages                        --- #

. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
# export JAVA_HOME="$(/usr/libexec/java_home)"

export PATH=$PATH:~/go/bin

export DOTNET_ROOT=/usr/local/share/dotnet

export PATH=$PATH:~/tools

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/chunhua/.sdkman"
[[ -s "/Users/chunhua/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/chunhua/.sdkman/bin/sdkman-init.sh"

# gib
export GIB_INSTALL=/Users/chunhua/.gib
export PATH=/Users/chunhua/.gib/bin:$PATH

