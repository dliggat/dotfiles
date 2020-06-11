#!/bin/zsh

#### OPTIONS ##################################################################
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
unsetopt inc_append_history
unsetopt share_history

#### VARIABLES ################################################################
export DOTFILES=$HOME/git/me/dotfiles
export EDITOR="st"
export SYNC_DIR="/Users/${USER}/appsync"


#### ALIASES ##################################################################
alias fd='find . -type d | sort'
alias ff='find . -type f | sort'
alias grep='grep --color=auto'
alias k9='kill -9'
alias ll='ls -lha'
alias pass1="pwgen -1 -sy 20 | tr -d '\n' | pbcopy"
alias pgen='pwgen -sy 20'
alias sha1sum='shasum'
alias sublime='"/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" -n'
alias tf='terraform'

alias pynew='pyenv virtualenv'
alias pyact='pyenv activate'
alias pydeact='pyenv deactivate'

alias dotfiles="st ~/git/me/dotfiles"
alias work="cd ~/git/proserve; st ."

alias nb="jupyter notebook"

#### FUNCTIONS ################################################################
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


#### OH MY ZSH ################################################################
export ZSH=$HOME/.oh-my-zsh  # Path to your oh-my-zsh installation.
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git)
source $ZSH/oh-my-zsh.sh


eval "$(starship init zsh)"


#### PROMPT ###################################################################
# PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
# PROMPT_SUFFIX="]%{$reset_color%}"
# PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
# PROMPT_CLEAN=""

git_custom_status() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)%{$fg_bold[yellow]%}$(work_in_progress)%{$reset_color%}$PROMPT_PREFIX$(current_branch)$PROMPT_SUFFIX"
  fi
}

# Display an abbreviated version of the `pwd`.
display_path() {
  local pwd_length=22
  local canonical="`pwd -P`"
  local lpwd="${canonical/#$HOME/~}"
  if [ $(echo -n $lpwd | wc -c | tr -d " ") -gt $pwd_length ]
    then newPWD="...$(echo -n $lpwd | sed -e "s/.*\(.\{$pwd_length\}\)/\1/")"
    else newPWD="$(echo -n $lpwd)"
  fi
  echo $newPWD
}

aws_profile() {
  if [[ -z "$AWS" ]]; then
    echo 'none'
  else
    echo "$AWS"
  fi
}

python_virtualenv() {
  echo $(pyenv version | cut -f 1 -d' ')
}

# RPROMPT='$(git_custom_status)%{$reset_color%}'
# PROMPT='%{$fg[yellow]%}[$(aws_profile)] %(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '




#### PYTHON ###################################################################
export PYENV_ROOT="${HOME}/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv virtualenv-init -)"



#### RUBY #####################################################################
eval "$(rbenv init -)"


#### AWS ######################################################################
function aws-set {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  export AWS=$1
  export AWS_DEFAULT_PROFILE=$AWS
  export AWS_PROFILE=$AWS

  # export AWS_REGION=$(grep --after-context=2 "\[profile ${AWS}\]" ~/.aws/config |
  #                     grep 'region'                                             |
  #                     sed -e 's#.*=\(\)#\1#'                                    |
  #                     xargs)
  # export AWS_DEFAULT_REGION="${AWS_REGION}"

  if [[ "${2:-true}" = "true" ]]; then
    echo "AWS_PROFILE         : ${AWS_PROFILE}"
    echo "AWS_DEFAULT_PROFILE : ${AWS_DEFAULT_PROFILE}"
    # echo "AWS_REGION          : ${AWS_REGION}"
    # echo "AWS_DEFAULT_REGION  : ${AWS_DEFAULT_REGION}"
    echo
  fi
}

function aws-login {
  echo $(aws-vault login $AWS_DEFAULT_PROFILE -s)
}

function aws-assume {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  RoleName=${1:-Admin}
  RoleSessionName=${2:-$(echo "CliRoleAssumption-${RANDOM}")}
  AccountNumber=$(aws sts get-caller-identity --output text --query 'Account')
  creds=$(aws sts assume-role --role-arn arn:aws:iam::${AccountNumber}:role/${RoleName}  --role-session-name ${RoleSessionName})

  if [ $? -eq 0 ]; then
    export AWS_ACCESS_KEY_ID=$(echo $creds | jq '.Credentials.AccessKeyId' --raw-output)
    export AWS_SECRET_ACCESS_KEY=$(echo $creds | jq '.Credentials.SecretAccessKey' --raw-output)
    export AWS_SESSION_TOKEN=$(echo $creds | jq '.Credentials.SessionToken' --raw-output)
    expiry=$(echo $creds | jq '.Credentials.Expiration' --raw-output)
    unset creds
    echo "Assumed ${RoleName} IAM role in ${AccountNumber}; expires ${expiry}."
  else
    echo "Failed to assume ${RoleName}."
  fi
}


alias AWS="/Users/${USER}/.pyenv/shims/aws"
alias awsv="aws-vault"
export PATH="$DOTFILES/scripts:$PATH"


#### PATH #####################################################################
export PATH="/usr/local/opt/php@7.2/bin:$PATH"

#### FINAL: LOCAL FILES #######################################################
for zsh_config in $(ls $DOTFILES/*.local.zsh 2>/dev/null | sort)
do
  source $zsh_config
done
