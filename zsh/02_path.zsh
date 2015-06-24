#!/bin/zsh

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$PATH:/usr/local/opt/nvm/v0.10.32/bin"
source $(brew --prefix nvm)/nvm.sh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh --no-rehash)"
