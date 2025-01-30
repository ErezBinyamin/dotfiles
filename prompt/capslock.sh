#!/bin/bash
# CAPS LOCK notification symbol
__prompt_capslock_func(){
  PROMPT_CAPS_LOCK_SYMBOL="©"
  __prompt_capslock_str=''
  if [ ${PROMPT_CAPS_LOCK:-0} -eq 1 ] && xset -h &>/dev/null
  then
  	xset q | grep -q "00: Caps Lock:   off" || __prompt_capslock_str="${PROMPT_CAPS_LOCK_SYMBOL}"
  fi
  export __prompt_capslock_str
}
