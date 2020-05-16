#!/bin/bash

# If [available space] - [width of the prompt (wihthout PWD)] - [width of PWD] < MIN_SPACE
#	then print a short wrk_dir
#	else print the full wrk_dir
export __prompt_wrk_dir='`
MIN_SPACE=10
WID=0
if [ $PROMPT_WRK_DIR -eq 1 ]
then
	printf ":"
	WID=$(printf "${PS1_noDir@P}" | sed "s#\x1##g; s#\x2##g; s/\x1B\\[[0-9;]\\+[A-Za-z]//g;" | wc -c)
	[ $( bc <<< "$(tput cols) - ${WID} - ${#PWD}" ) -lt ${MIN_SPACE} ] && printf ${PWD##*/} || printf ${PWD}
fi
`'
