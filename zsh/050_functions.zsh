#!/bin/zsh

# Rails development - drop, create and re-seed development database.
function rakeall {
  echo "Rake rake rake..."
  time bundle exec rake db:drop db:create db:migrate db:seed db:test:prepare # resque:clear
  if [ $? -ne 0 ]; then
    echo "FAIL."
  else
    echo "All raked!"
  fi
}

function gitgo {
  git add .
  git commit -m "Committing a snapshot: `date`"
  git push origin master
}

function deploy {
  [[ `current_branch` = 'production' ]] || { echo 'Checkout production you idiot' ; return 1; }
  bundle exec rspec || { echo 'Tests should pass you idiot' ; return 1; }
  bundle exec cap deploy || { echo 'Deployment failed. Sigh.' ; return 1; }
}

function pg {
  local project=$(basename `pwd`)
  local psql_str="psql -U $project $project"
  psql_str+="_development"
  echo $psql_str
  echo
  echo '\dt:  data tables'
  echo '\q :  quit'
  echo
  eval ${psql_str}
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

function tmpname {
  local name=`date +"%Y-%m-%d_%H-%M-%S"`
  echo "tempfile_$name"
}

function migrated {
  local result=`bundle exec rake db:abort_if_pending_migrations`
  local _ret=$?
  if [ $_ret -ne 0 ]; then
    echo $result
  else
    echo "Already migrated up!"
  fi
  return $_ret
}

# Do a bandwidth test.
function bwhistory {
  tail -n 8 `ls $HOME/Dropbox/Logging/*-bandwidth.log`
}

# function sss {
#   set -x
#   s3cmd -c "$HOME/.aws/s3cfg/$AWS_DEFAULT_PROFILE" "$@"
# }
