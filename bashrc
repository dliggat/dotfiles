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
  echo "All raked."
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

# What to display as prompt suffix in Bash. Most sensibly represented as '$'.
function _prompt_suffix {
  # hour=`date +%k`  # Get current hour in 24-hr format.
  # if ((0<=$hour && $hour<=6))
  # then
  #   message="🌙"  # Crescent moon.
  # elif ((7<=$hour && $hour<=11))
  # then
  #   message="☕"  # Coffee cup.
  # elif ((12<=$hour && $hour<=13))
  # then
  #   message="🍴"  # Knife and fork.
  # elif ((14<=$hour && $hour<=17))
  # then
  #   message="💡"  # Lightbulb.
  # elif ((18<=$hour && $hour<=23))
  # then
  #   message="🍺"  # Beer mug.
  # else
  #   message="something wrong"  # Should never happen.
  # fi
  echo "$ "
}

function _shortpath {
  #   How many characters of the $PWD should be kept
  local pwd_length=30
  local lpwd="${PWD/#$HOME/~}"
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
export PROMPT_COMMAND='PS1="$START$YELLOW\u@\h:$STOP $START$WHITE\$(_shortpath)$STOP$START$RED\$(_git_branch_ps1)$STOP $START$YELLOW$(_prompt_suffix)$STOP"'

# Putting /usr/local/bin in front of other paths in $PATH as suggested by `brew doctor`.
export NODE_PATH=/usr/local/lib/node_modules:$NODE_PATH

# How to set ls colors: http://www.napolitopia.com/2010/03/lscolors-in-osx-snow-leopard-for-dummies/
# This DOES NOT work in linux (at least not Fedora). In Linux, need to change /etc/DIR_COLORS.
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS='GxHxxxxxBxxxxxxxxxgxgx'

# My custom environment variables and aliases.
alias beg='bundle exec guard'
alias drb='bundle exec spork'
alias be='bundle exec'
alias fd='find . -type d | sort'
alias ff='find . -type f | sort'
alias grep='grep --color=auto'
alias rc='rails console'
alias rr='rails server'
alias sha1sum='openssl sha1'
alias spec='rspec -b -c -f s'
alias ts='date +"%Y-%m-%d %H:%M:%S" | perl -ne "chomp and print" | pbcopy'

# Enable the ability to prevent addition to .bash_history with prepended space.
export HISTCONTROL=ignorespace

# Bring in any local, machine specific variables that should not be committed to github.
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi


[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
