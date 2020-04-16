#!/bin/bash

# TODO: actually calculate size of prompt instead of hardcoding
# Always leave room for at least 20 chars of command
# 55 is the stated length of the nonDir_part of the prompt
# TERM_WIDTH - 55 - (length of pwd)
export __prompt_wrk_dir='`
if [ $PROMPT_WRK_DIR -eq 1 ] && printf ":"
then
	[ $(( $(tput cols) - 55 - ${#PWD} )) -lt 20 ] && printf $(printf ${PWD} | sed "s#.*/##") || printf ${PWD}
fi
`'
