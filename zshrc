#!/bin/zsh
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export DOTFILES=$HOME/git/me/dotfiles

# ZSH_THEME="gallois"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew ruby bundler)
source $ZSH/oh-my-zsh.sh

# Path configuration.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$PATH:/usr/local/lib/node_modules"
source $(brew --prefix nvm)/nvm.sh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh --no-rehash)"

# User Configuration Below This Line:
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE
source $DOTFILES/zsh_prompt
source $DOTFILES/shell_common
