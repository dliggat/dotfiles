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
  local pwd_length=30
  local canonical=`pwd -P`
  local lpwd="${canonical/#$HOME/~}"
  if [ $(echo -n $lpwd | wc -c | tr -d " ") -gt $pwd_length ]
    then newPWD="...$(echo -n $lpwd | sed -e "s/.*\(.\{$pwd_length\}\)/\1/")"
    else newPWD="$(echo -n $lpwd)"
  fi
  echo $newPWD
}

# RVM and git settings for the right prompt.
if [[ -s ~/.rvm/scripts/rvm ]] ; then
  RPROMPT='$(git_custom_status)%{$fg[red]%}[`~/.rvm/bin/rvm-prompt`]%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    RPROMPT='$(git_custom_status)%{$fg[red]%}[`rbenv version | sed -e "s/ (set.*$//"`]%{$reset_color%}'
  else
    if [[ -n `which chruby_prompt_info` && -n `chruby_prompt_info` ]]; then
      RPROMPT='$(git_custom_status)%{$fg[red]%}[`chruby_prompt_info`]%{$reset_color%}'
    else
      RPROMPT='$(git_custom_status)'
    fi
  fi
fi

# Set the left prompt.
PROMPT='%{$fg[cyan]%}[$(display_path)]%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '

