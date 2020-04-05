#!/bin/bash
#Date and time
export __prompt_date_time='`
if [ $PROMPT_DATE_TIME -eq 1 ]
then
	printf "[$(date +%m/%d/%y) "
	HR=$(date "+%l" | tr -d " ")
	MN=$(date "+%M" | tr -d " ")
	case "${HR}" in
	  "1")
		[ $MN -lt 15 ] && printf "🕐" || printf "🕜";;
	  "2")
		[ $MN -lt 15 ] && printf "🕑" || printf "🕝";;
	  "3")
		[ $MN -lt 15 ] && printf "🕒" || printf "🕞";;
	  "4")
		[ $MN -lt 15 ] && printf "🕓" || printf "🕟";;
	  "5")
		[ $MN -lt 15 ] && printf "🕔" || printf "🕠";;
	  "6")
		[ $MN -lt 15 ] && printf "🕕" || printf "🕡";;
	  "7")
		[ $MN -lt 15 ] && printf "🕖" || printf "🕢";;
	  "8")
		[ $MN -lt 15 ] && printf "🕗" || printf "🕣";;
	  "9")
		[ $MN -lt 15 ] && printf "🕘" || printf "🕤";;
	  "10")
		[ $MN -lt 15 ] && printf "🕙" || printf "🕥";;
	  "11")
		[ $MN -lt 15 ] && printf "🕚" || printf "🕦";;
	  "12")
		[ $MN -lt 15 ] && printf "🕛" || printf "🕧";;
	  *)
		echo foo > /dev/null ;;
	esac

	HR_24=$(date "+%H")
	if [ ${HR_24} -lt 6 ]
	then
		printf "🌚"
	elif [ ${HR_24} -lt 17 ]
	then
		printf "🌞"
	elif [ ${HR_24} -ge 17 ]
	then
		printf "🌚"
	fi
fi
`'
