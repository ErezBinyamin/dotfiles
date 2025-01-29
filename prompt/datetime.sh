#!/bin/bash
#Date and time
__prompt_datetime_func() {
  if [ ${PROMPT_DATETIME:-0} -eq 1 ]
  then
  	printf "["
  	date "+%m/%d/%y %l:%M:%S" | tr -d "\n"
  	printf "]"
  fi
}
export __prompt_datetime='`__prompt_datetime_func`'

