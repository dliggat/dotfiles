#!/bin/zsh

function ts {
  iso_stamp=`date +"%Y-%m-%d %H:%M:%S"`
  echo $iso_stamp
}

function iso {
  iso_stamp=`date +"%Y-%m-%d"`
  echo $iso_stamp
}

function tmpname {
  local name=`date +"%Y-%m-%d_%H-%M-%S"`
  echo "tempfile_$name"
}

SYNC_DIR=/Users/dliggat/appsync
function do_sync {
  set -x
  osascript -e 'quit app "1Password"'
  osascript -e 'quit app "Quiver"'
  cd $SYNC_DIR
  git add .
  git commit -m "Committing from $(hostname) on $(date +%F)"
  git pull origin master -X theirs
  git push origin master
}

function bandwidth {
  echo "$(echo "en$(route get cachefly.cachefly.net | grep interface | sed -n -e 's/^.*en//p')") $(wget http://cachefly.cachefly.net/100mb.test -O /dev/null --report-speed=bits 2>&1 | grep '\([0-9.]\+ [KMG]b/s\)')"
}
