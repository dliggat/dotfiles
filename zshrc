#!/bin/zsh
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
# Amazon Q pre block. Keep at the top of this file.
#[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

#### OPTIONS ##################################################################
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt inc_append_history
setopt share_history

#### VARIABLES ################################################################
export DOTFILES=$HOME/git/me/dotfiles
export EDITOR="code"
export SYNC_DIR="/Users/${USER}/appsync"
export NOTES_DIR="/Users/${USER}/git/me/text_notes"


#### PATH #####################################################################
#export PATH="/usr/local/opt/php@7.2/bin:$PATH"
#export PATH="$HOME/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$DOTFILES/scripts:$PATH"


#### ALIASES ##################################################################
alias fd='find . -type d | sort'
alias ff='find . -type f | sort'
alias grep='grep --color=auto'
alias k9='kill -9'
alias ll='ls -lha'
alias ls='ls -G'
alias pass1="pwgen -1 -sy 20 | tr -d '\n' | pbcopy"
alias pgen='pwgen -sy 20'
alias sha1sum='shasum'
alias sublime='"/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" -n'
alias tf='terraform'

# alias pynew='pyenv virtualenv'
# alias pyact='pyenv activate'
# alias pydeact='pyenv deactivate'

alias dotfiles="$EDITOR ~/git/me/dotfiles"
alias notes="$EDITOR $NOTES_DIR"

alias ic="isengardcli credentials"
alias stree='open -a SourceTree .'
alias oldcd='cd'

alias be='bundle exec'
alias ber='bundle exec rake'

alias k='/Users/dliggat/.local/bin/kiro-cli'
alias kcli='/Users/dliggat/.local/bin/kiro-cli'

#### FUNCTIONS ################################################################
# function ts {
#   iso_stamp=`date +"%Y-%m-%d %H:%M:%S"`
#   echo $iso_stamp
# }

function iso {
  iso_stamp=`date +"%Y-%m-%d"`
  echo $iso_stamp
}

function tmpname {
  local name=`date +"%Y-%m-%d_%H-%M-%S"`
  echo "tempfile_$name"
}

function uktime {
  TZ='Europe/London' date -Iseconds
}

# function do_sync {
#   set -x
#   osascript -e 'quit app "1Password"'
#   osascript -e 'quit app "Quiver"'
#   cd $SYNC_DIR
#   git add .
#   git commit -m "Committing from $(hostname) on $(date +%F)"
#   git pull origin master -X theirs
#   git push origin master
# }

# function bandwidth {
#   echo "$(echo "en$(route get cachefly.cachefly.net | grep interface | sed -n -e 's/^.*en//p')") $(wget http://cachefly.cachefly.net/100mb.test -O /dev/null --report-speed=bits 2>&1 | grep '\([0-9.]\+ [KMG]b/s\)')"
# }


#### OH MY ZSH ################################################################
# export ZSH=$HOME/.oh-my-zsh  # Path to your oh-my-zsh installation.
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git)
# source $ZSH/oh-my-zsh.sh


eval "$(starship init zsh)"


#### NODE #####################################################################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


#### PYTHON ###################################################################
# python_virtualenv() {
#   echo $(pyenv version | cut -f 1 -d' ')
# }

# export PYENV_ROOT="${HOME}/.pyenv"
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# eval "$(pyenv virtualenv-init -)"


#### RUBY #####################################################################
eval "$(rbenv init - zsh)"


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


#### FINAL: LOCAL FILES #######################################################
for zsh_config in $(ls $DOTFILES/*.local.zsh 2>/dev/null | sort)
do
  source $zsh_config
done

# Amazon Q post block. Keep at the bottom of this file.
#[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export PATH=$PATH:/Users/dliggat/.toolbox/bin

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

# Added by Antigravity
export PATH="/Users/dliggat/.antigravity/antigravity/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
