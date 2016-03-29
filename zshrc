#!/bin/zsh

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

export DOTFILES=$HOME/git/me/dotfiles
for zsh_config in `ls $DOTFILES/zsh/*.zsh | sort`
do
  source $zsh_config
done

# export PYENV_VERSION="2.7.9"  # Instead of this, use ~/.pyenv/version file
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# added by travis gem
[ -f /Users/dliggat/.travis/travis.sh ] && source /Users/dliggat/.travis/travis.sh

