#!/bin/zsh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# Source files
source $ENVCONFIG_PATH/general-aliases.sh
source $ENVCONFIG_PATH/git-aliases.sh
source $ENVCONFIG_PATH/docker-aliases.sh
source $ENVCONFIG_PATH/dockerized-cmds.sh

