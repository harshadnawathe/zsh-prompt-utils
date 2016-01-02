#!/bin/zsh

E_NOW='/sys/class/power_supply/BAT0/energy_now'
E_FULL='/sys/class/power_supply/BAT0/energy_full'

echo $(bc -l <<< "$(cat $E_NOW)*100/$(cat $E_FULL)" | cut -d. -f1)

