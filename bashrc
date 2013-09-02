#!/bin/bash

# Current git branch or nothing.
function br {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

# Strip out goddamn rich text formatting from text.
function clean {
  echo 'Formatting be gone with you!'
  pbpaste | pbcopy
}

# Rails development - drop, create and re-seed development database.
function rakeall {
  echo "Rake rake rake..."
  time bundle exec rake db:drop db:create db:migrate db:seed db:test:prepare resque:clear
  if [ $? -ne 0 ]; then
    echo "FAIL."
  else
    echo "All raked!"
  fi
}

# Get current timestamp. Use option '-c' to copy to clipboard.
function ts {
  iso_stamp=`date +"%Y-%m-%d %H:%M:%S"`
  if [ "$1" == "-c" ]; then
    echo -n $iso_stamp | pbcopy
    echo "[$iso_stamp] copied to clipboard."
  else
    echo $iso_stamp
  fi
}

# A consistent title for 'paperless' documents.
# Usage:
#    $ title Apple ipod Receipt
#    $ [2013-07-08 => apple ipod receipt (Paperless)] copied to clipboard.
# Then paste directly into Evernote, etc.
function title {
  title_str=`date '+%Y-%m-%d'`
  title_str="$title_str =>"
  while [ $1 ]
  do
    lower=`echo $1 | awk '{print tolower($0)}'`  # Lower() the string, purely for consistency.
    title_str="$title_str $lower"
    shift
  done
  title_str="$title_str (Paperless)"
  echo $title_str | pbcopy
  echo "[$title_str] copied to clipboard."
}


# Display a little time-of-day indicator as the first character of the PS1.
function _prompt_prefix {
  hour=`date +%k`  # Get current hour in 24-hr format.
  if ((0<=$hour && $hour<=6))
  then
    message="🌙"  # Crescent moon.
  elif ((7<=$hour && $hour<=11))
  then
    message="☕"  # Coffee cup.
  elif ((12<=$hour && $hour<=13))
  then
    message="🍴"  # Knife and fork.
  elif ((14<=$hour && $hour<=17))
  then
    message="💡"  # Lightbulb.
  elif ((18<=$hour && $hour<=23))
  then
    message="🍺"  # Beer mug.
  else
    message="something wrong"  # Should never happen.
  fi
  echo "$message  "
}

# What to display as prompt suffix in Bash. Most sensibly represented as '$'.
function _prompt_suffix {
  echo '$ '
}

function _shortpath {
  #   How many characters of the $PWD should be kept
  local pwd_length=30
  local canonical=`pwd -P`
  local lpwd="${canonical/#$HOME/~}"
  if [ $(echo -n $lpwd | wc -c | tr -d " ") -gt $pwd_length ]
    then newPWD="...$(echo -n $lpwd | sed -e "s/.*\(.\{$pwd_length\}\)/\1/")"
    else newPWD="$(echo -n $lpwd)"
  fi
  echo $newPWD
}

# Display current branch in PS1.
function _git_branch_ps1 {
  branch_name=`br`
  if [ -n "$branch_name" ]; then
    echo "($branch_name)"
  else
    return  # Not a git repo.
  fi
}

# Taken from http://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
# Also read this: http://superuser.com/questions/246625/bash-command-prompt-overwrites-the-current-line
# Use the start and stop tokens to define a period of time for color to be activated.
WHITE="0;37m\]"
YELLOW="0;33m\]"
GREEN="0;32m\]"
RED="0;31m\]"
START="\[\e["
STOP="\[\e[m\]"
PROMPT_COMMAND='RET=$?;'
RET_VALUE='$(echo $RET)'
# export PROMPT_COMMAND='PS1="\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\!] $START$YELLOW\u@\h:$STOP $START$WHITE\$(shortpath)$STOP$START$RED\$(parse_git_branch)$STOP $(prompt_suffix)"'
export PROMPT_COMMAND='PS1="$(_prompt_prefix)$START$YELLOW\u@\h:$STOP $START$WHITE\$(_shortpath)$STOP$START$RED\$(_git_branch_ps1)$STOP $START$YELLOW$(_prompt_suffix)$STOP"'

# Putting /usr/local/bin in front of other paths in $PATH as suggested by `brew doctor`.
export NODE_PATH=/usr/local/lib/node_modules:$NODE_PATH

# How to set ls colors: http://www.napolitopia.com/2010/03/lscolors-in-osx-snow-leopard-for-dummies/
# This DOES NOT work in linux (at least not Fedora). In Linux, need to change /etc/DIR_COLORS.
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS='GxHxxxxxBxxxxxxxxxgxgx'

# Rails aliases.
alias rc='rails console'
alias beg='bundle exec guard'
alias drb='bundle exec spork'
alias spec='rspec -b -c -f s'
alias be='bundle exec'

# My custom aliases.
alias fd='find . -type d | sort'
alias ff='find . -type f | sort'
alias grep='grep --color=auto'
alias pgen='pwgen -sy 20'

# Enable the ability to prevent addition to .bash_history with prepended space.
export HISTCONTROL=ignorespace

# Bring in any local, machine specific variables that should not be committed to github.
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

# Source the boxen environment definitions.
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
