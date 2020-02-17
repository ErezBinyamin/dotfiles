#!/bin/bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Battery life colored and charging status
__prompt_bat_life='`
BATTERY_CHARGING="»"
if [ -d /sys/class/power_supply/ ] && ls /sys/class/power_supply/ | grep -q BAT && [ $(echo $(find /sys/class/power_supply/BAT*/ -name status -exec cat {} \;) | wc -c) -gt 3 ]
then
	[[ $(find /sys/class/power_supply/BAT*/ -name status -exec cat {} \;) != "Discharging" ]] && printf "${BATTERY_CHARGING}"
	BAT=$(find /sys/class/power_supply/BAT*/ -name capacity -exec cat {} \;)
	[ $BAT -ge 75 -a $BAT -lt 101 ] && printf "\[\033[38;5;10m\][||${BAT}||]"
	[ $BAT -ge 50 -a $BAT -lt 75 ] && printf "\[\033[38;5;11m\][||${BAT}| ]"
	[ $BAT -ge 25 -a $BAT -lt 50 ] && printf "\[\033[38;5;202m\][||${BAT}  ]"
	[ $BAT -ge 10 -a $BAT -lt 25 ] && printf "\[\033[38;5;9m\][| ${BAT}  ]"
	[ $BAT -lt 10 ] && printf "\[\033[38;5;9m\]\[\033[5m\][| ${BAT}  ]"
fi
printf "\[\033[0m\]"
`'
