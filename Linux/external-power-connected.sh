#!/bin/zsh

STATUS_FILE='/sys/class/power_supply/BAT0/status'

if [[ $(cat $STATUS_FILE) == "Discharging" ]]; then
  echo "0"
else
  echo "1"
fi

