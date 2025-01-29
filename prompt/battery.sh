#!/bin/bash
# Battery life colored and charging status
__prompt_battery_func() {
  local BATTERY_CHARGING="»"
  if [ ${PROMPT_BATTERY:-0} -eq 1 ] && [ -d /sys/class/power_supply/ ] && ls /sys/class/power_supply/ | grep -q BAT && [ $(echo $(find /sys/class/power_supply/BAT*/ -name status -exec cat {} \;) | wc -c) -gt 3 ]
  then
  	[[ $(find /sys/class/power_supply/BAT*/ -name status -exec cat {} \;) != "Discharging" ]] && printf "${BATTERY_CHARGING}"
  	local BAT=$(find /sys/class/power_supply/BAT*/ -name capacity -exec cat {} \;)
  	[ $BAT -ge 75 -a $BAT -lt 101 ] && printf '\033[38;5;10m'"[||${BAT}||]" # Green  with 4 bars 
  	[ $BAT -ge 50 -a $BAT -lt 75 ]  && printf '\033[38;5;11m'"[||${BAT}| ]" # Yellow with 3 bars
  	[ $BAT -ge 25 -a $BAT -lt 50 ] && printf '\033[38;5;202m'"[||${BAT}  ]" # Orange with 2 bars
  	[ $BAT -ge 10 -a $BAT -lt 25 ]   && printf '\033[38;5;9m'"[| ${BAT}  ]" # Red    with 1 bar
  	[ $BAT -lt 10 ]           && printf '\033[38;5;9m\033[5m'"[| ${BAT}  ]" # Red    with 1 bar and blinking
  fi
}
export __prompt_battery='`__prompt_battery_func`'
