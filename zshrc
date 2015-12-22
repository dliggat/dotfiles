#!/bin/zsh

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

export DOTFILES=$HOME/git/me/dotfiles
for zsh_config in `ls $DOTFILES/zsh/*.zsh | sort`
do
  source $zsh_config
done

# added by travis gem
[ -f /Users/dliggat/.travis/travis.sh ] && source /Users/dliggat/.travis/travis.sh
