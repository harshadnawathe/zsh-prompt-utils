#!/bin/zsh


source colors-definations.sh

function battery_percentage {
  $(uname)/battery-percentage.sh
}

function external_power_connected {
  $(uname)/external-power-connected.sh
}

function is_git_repo {
  ls -a ./.git 2> /dev/null
}

function git_curr_branch {
  git branch 2> /dev/null | grep -e"^\*" | cut -d" " -f2
}

function git_untracked_files_count {
  git status --porcelain 2> /dev/null | grep -e"^??" | wc -l
}

function git_modified_files_count {
  git status --porcelain 2> /dev/null | grep -e"^.M" | wc -l
}

function git_deleted_files_count {
  git status --porcelain 2> /dev/null | grep -e"^.D" | wc -l
}

function git_staged_files_count {
  git status --porcelain 2> /dev/null | grep -e"^[ADM]." | wc -l
}

function battery_percentage_colored {
  BATTERY_PERC=$(battery_percentage)
  if   [[ $(bc <<< "$BATTERY_PERC >= 75") -eq 1 ]]; then
    echo "$GREEN$BATTERY_PERC%%$COLOR_RESET"
  elif [[ $(bc <<< "$BATTERY_PERC >= 50") -eq 1 ]]; then
    echo "$YELLOW$BATTERY_PERC%%$COLOR_RESET"
  elif [[ $(bc <<< "$BATTERY_PERC >= 25") -eq 1 ]]; then
    echo "$ORANGE$BATTERY_PERC%%$COLOR_RESET"
  else
    echo "$RED$BATTERY_PERC%%$COLOR_RESET"
  fi
}

function charging_status {
  if [[ $(external_power_connected) -eq 1 ]]; then
    echo '\033[48;5;118m\xF0\x9F\x94\x8C \033[m'
  else
    echo '\033[48;5;196m\xF0\x9F\x94\x8B \033[m'
  fi
}

function modified_files_status {
  if [[ $N_MODIFIED -ne 0 ]]; then
    echo "$ORANGE\u25CB$N_MODIFIED$COLOR_RESET "
  fi
}

function deleted_files_status {
  if [[ $N_DELETED -ne 0 ]]; then
    echo "$RED\u2717$N_DELETED$COLOR_RESET "
  fi
}

function staged_files_status {
  if [[ $N_STAGED -ne 0 ]]; then
    echo "$GREEN\u25CF$N_STAGED$COLOR_RESET "
  fi
}

function untracked_files_status {
  if [[ $N_UNTRACKED -ne 0 ]]; then
    echo "$YELLOW?$N_UNTRACKED$COLOR_RESET "
  fi
}

function git_status {

  N_MODIFIED=$(git_modified_files_count)
  N_DELETED=$(git_deleted_files_count)
  N_UNTRACKED=$(git_untracked_files_count)
  N_STAGED=$(git_staged_files_count)

  if [[ -n $(is_git_repo) ]]; then
    GIT_BRANCH=$(git_curr_branch)
    if [[ -n $GIT_BRANCH ]]; then            
      if [[ $(bc <<< "$N_MODIFIED + $N_DELETED + $N_UNTRACKED + $N_STAGED") == "0" ]]; then
        echo "$AQUA($GIT_BRANCH$COLOR_RESET|$GREEN\u2713 $COLOR_RESET$AQUA)$COLOR_RESET"
      else
        echo "$AQUA($GIT_BRANCH$COLOR_RESET|$(staged_files_status)$(modified_files_status)$(deleted_files_status)$(untracked_files_status)$AQUA)$COLOR_RESET"
      fi
    fi
  fi
}

function battery_status {
 echo "$(charging_status)$(battery_percentage_colored)"
}

setopt promptsubst
export PS1='$(battery_status) [%1d] $(git_status) ~> '
