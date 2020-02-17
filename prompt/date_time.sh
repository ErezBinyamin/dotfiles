#!/bin/bash
#Date and time
#export __prompt_date_time='[`[ $PROMPT_DATE_TIME -eq 1 ] && date "+%m/%d/%y %l:%M:%S"`]'
export __prompt_date_time='`
if [ $PROMPT_DATE_TIME -eq 1 ]
then
	printf "["
	date "+%m/%d/%y %l:%M:%S" | tr -d "\n"
	printf "]"
fi
`'
