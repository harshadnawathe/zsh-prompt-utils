#!/bin/zsh

source $ZSH_PROMPT_UTILS_ROOT/colors-definations.sh
source $ZSH_PROMPT_UTILS_ROOT/battery-status-functions.sh
#source $ZSH_PROMPT_UTILS_ROOT/git-status-functions.sh

function git_status {
	git status -b --porcelain 2> /dev/null | $ZSH_PROMPT_UTILS_ROOT/parse-and-endcode-git-status.py	
}

setopt promptsubst
export PS1='$(battery_status) [%1d] $(git_status) ~> '
