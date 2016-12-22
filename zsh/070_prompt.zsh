#!/bin/zsh

PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
PROMPT_SUFFIX="]%{$reset_color%}"
PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
PROMPT_CLEAN=""

# Customized git status, oh-my-zsh currently does not allow render dirty status before branch.
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

ruby_rbenv() {
  echo $(rbenv version 2> /dev/null | sed -e "s/ (set.*$//")
}

RPROMPT='$(git_custom_status)%{$fg[yellow]%}[$(aws_profile)]%{$fg_bold[blue]%}[$(python_virtualenv)]%{$reset_color%}%{$fg[red]%}[$(ruby_rbenv)]%{$reset_color%}'
PROMPT='%{$fg[cyan]%}[$(display_path)]%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '

