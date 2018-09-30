#!/bin/zsh

alias fd='find . -type d | sort'
alias ff='find . -type f | sort'
alias grep='grep --color=auto'
alias pgen='pwgen -sy 20'
alias pass1="pwgen -1 -sy 20 | tr -d '\n' | pbcopy"
alias k9='kill -9'
alias sha1sum='shasum'

alias pynew='pyenv virtualenv'
alias pyact='pyenv activate'
alias pydeact='pyenv deactivate'

alias beg='bundle exec guard'
alias drb='bundle exec spork'
alias spec='bundle exec rspec -b -c'
alias s='bundle exec rspec -b -c spec'
alias be='bundle exec'
alias taild='tail -f log/development.log'
alias ll='ls -lha'
alias tf='terraform'

alias dotfiles="st ~/git/me/dotfiles"
alias work="cd ~/git/proserve; st ."

alias ghead="git rev-parse HEAD"
