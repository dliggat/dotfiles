#!/bin/zsh

function aws-set {
  export AWS=$1
  export AWS_DEFAULT_PROFILE=$AWS
  export AWS_PROFILE=$AWS

  export AWS_REGION=$(grep --after-context=2 "\[profile ${AWS}\]" ~/.aws/config |
                      grep 'region'                                             |
                      sed -e 's#.*=\(\)#\1#'                                    |
                      xargs)
  export AWS_DEFAULT_REGION="${AWS_REGION}"

  if [[ "${2:-true}" = "true" ]]; then
    echo "AWS_PROFILE         : ${AWS_PROFILE}"
    echo "AWS_DEFAULT_PROFILE : ${AWS_DEFAULT_PROFILE}"
    echo "AWS_REGION          : ${AWS_REGION}"
    echo "AWS_DEFAULT_REGION  : ${AWS_DEFAULT_REGION}"
    echo
  fi
}

function aws-login {
  echo $(aws-vault login $AWS_DEFAULT_PROFILE -s)
}

aws-set 'dliggat' 'false'

alias awsv="aws-vault"
export PATH="$DOTFILES/scripts:$PATH"
