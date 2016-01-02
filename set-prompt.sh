#!/bin/zsh

source colors-definations.sh

source battery-status-functions.sh

source git-status-functions.sh

function battery_status {
 echo "$(charging_status)$(battery_percentage_colored)"
}

setopt promptsubst
export PS1='$(battery_status) [%1d] $(git_status) ~> '
