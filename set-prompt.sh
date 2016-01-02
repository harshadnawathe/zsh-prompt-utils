#!/bin/zsh

source $ZSH_PROMPT_UTILS_ROOT/colors-definations.sh
source $ZSH_PROMPT_UTILS_ROOT/battery-status-functions.sh
source $ZSH_PROMPT_UTILS_ROOT/git-status-functions.sh

setopt promptsubst
export PS1='$(battery_status) [%1d] $(git_status) ~> '
