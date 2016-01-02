#! /bin/zsh

function is_git_repo {
  git rev-parse --git-dir 2> /dev/null
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

  N_MODIFIED=${$(git_modified_files_count)// /}
  N_DELETED=${$(git_deleted_files_count)// /}
  N_UNTRACKED=${$(git_untracked_files_count)// /}
  N_STAGED=${$(git_staged_files_count)// /}

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
