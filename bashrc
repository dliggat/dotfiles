## Personal bashrc file for OS X machines. Contains aliases, env vars, etc.

function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

function prompt_suffix {
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

function shortpath {
  #   How many characters of the $PWD should be kept
  local pwd_length=30
  local lpwd="${PWD/#$HOME/~}"
  if [ $(echo -n $lpwd | wc -c | tr -d " ") -gt $pwd_length ]
    then newPWD="...$(echo -n $lpwd | sed -e "s/.*\(.\{$pwd_length\}\)/\1/")"
    else newPWD="$(echo -n $lpwd)"
  fi
  echo $newPWD
}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

#if [ -f `brew --prefix`/etc/bash_completion ]; then
#    . `brew --prefix`/etc/bash_completion
#fi

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
export PROMPT_COMMAND='PS1="\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\!] $START$YELLOW\u@\h:$STOP $START$WHITE\$(shortpath)$STOP$START$RED\$(parse_git_branch)$STOP $(prompt_suffix)"'

# Putting /usr/local/bin in front of other paths in $PATH as suggested by `brew doctor`.
export PATH=/usr/local/bin:$PATH
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
alias clean='pbpaste | pbcopy'
alias fd='find . -type d | sort'
alias ff='find . -type f | sort'
alias gs='git status'
alias gcm='git checkout master'
alias gch='git checkout'
alias gco='git commit'
alias gb='git branch'
alias gd='git diff'
alias gpom='git push origin master'
alias gphm='git push heroku master'
alias grep='grep --color=auto'
alias grepi='grep -i'
alias rakeall='time bundle exec rake db:drop db:create db:migrate db:seed db:test:prepare resque:clear; echo "DONE ALL THE RAKES"'
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

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
