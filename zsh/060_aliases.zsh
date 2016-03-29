#!/bin/zsh

alias fd='find . -type d | sort'
alias ff='find . -type f | sort'
alias grep='grep --color=auto'
alias pgen='pwgen -sy 20'
alias pass1="pwgen -1 -sy 20 | tr -d '\n' | pbcopy"
alias k9='kill -9'
alias embergo='npm install && bower install && ember build --watch'
alias bandwidth="wget --output-document=/dev/null --report-speed=bits http://speedtest.wdc01.softlayer.com/downloads/test10.zip 2>&1 | grep ') -'"
alias dotfiles="st ~/git/me/dotfiles"
alias purgebranch='git branch --merged | grep -v "\*" | grep -v "master" | xargs -n 1 git branch -d'
alias jqq="jq '.'"
alias nrg="npm run grunt --"

# Rails aliases.
alias beg='bundle exec guard'
alias drb='bundle exec spork'
alias spec='bundle exec rspec -b -c'
alias be='bundle exec'
alias redisstart='sudo launchctl start io.redis.redis-server'
alias redisstop='sudo launchctl stop io.redis.redis-server'
alias taild='tail -f log/development.log'
alias ll='ls -lha'
