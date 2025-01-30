#!/bin/bash
export GRN='\[\033[38;5;10m\]'
export YLW='\[\033[38;5;11m\]'
export ORG='\[\033[38;5;202m\]'
export RED='\[\033[38;5;9m\]'
export BNK='\[\033[5m\]'

# Battery life colored and charging status
__prompt_battery_func() {
  local BATTERY_CHARGING="»"
  unset __prompt_battery_str
  if [ ${PROMPT_BATTERY:-0} -eq 1 ] && [ -d /sys/class/power_supply/ ] && ls /sys/class/power_supply/ | grep -q BAT && [ $(echo $(find /sys/class/power_supply/BAT*/ -name status -exec cat {} \;) | wc -c) -gt 3 ]
  then
  	[[ $(find /sys/class/power_supply/BAT*/ -name status -exec cat {} \;) != "Discharging" ]] && __prompt_battery_str="${BATTERY_CHARGING}"
  	local BAT=$(find /sys/class/power_supply/BAT*/ -name capacity -exec cat {} \;)
  	[ $BAT -ge 75 -a $BAT -lt 101 ] && __prompt_battery_str+="${GRN}[||${BAT}||]" # Green  with 4 bars 
  	[ $BAT -ge 50 -a $BAT -lt 75 ]  && __prompt_battery_str+="${YLW}[||${BAT}| ]" # Yellow with 3 bars
  	[ $BAT -ge 25 -a $BAT -lt 50 ]  && __prompt_battery_str+="${ORG}[||${BAT}  ]" # Orange with 2 bars
  	[ $BAT -ge 10 -a $BAT -lt 25 ]  && __prompt_battery_str+="${RED}[| ${BAT}  ]" # Red    with 1 bar
  	[ $BAT -lt 10 ]                 && __prompt_battery_str+="${RED}${BNK}[| ${BAT}  ]" # Red    with 1 bar and blinking
  fi
  export __prompt_battery_str
}
