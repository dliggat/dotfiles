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

function aws-login {
  echo $(aws-vault login $AWS_DEFAULT_PROFILE -s)
}

aws-set 'dliggat' 'false'

alias awsv="aws-vault"
export PATH="$DOTFILES/scripts:$PATH"
