#! /bin/zsh

function battery_percentage {
  $(uname)/battery-percentage.sh
}

function external_power_connected {
  $(uname)/external-power-connected.sh
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


