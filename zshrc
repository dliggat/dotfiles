#!/bin/zsh
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export DOTFILES=$HOME/git/me/dotfiles

#### oh-my-zsh settings.
# ZSH_THEME="gallois"
COMPLETION_WAITING_DOTS="true"  # Display red dots whilst waiting for completion.
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew ruby bundler)
source $ZSH/oh-my-zsh.sh

#### oh-my-zsh done; regular config below this line.

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$PATH:/usr/local/lib/node_modules"
source $(brew --prefix nvm)/nvm.sh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh --no-rehash)"

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

for zsh_config in `ls $DOTFILES/zsh/*.zsh | sort`
do
  source $zsh_config
done
