#!/bin/bash
# set variable identifying this machines ip address (used in the prompt below)
# Color the command line according to the IP, sed away the bad colors
# Helper function for generating IP-color string
# Replaces hard to see colors with highlighed backgrounds
__assign_color() {
    case "$1" in
     "")
        echo '\[\033[48;5;m\]'
        ;;
     "0" | "8" | "17" | "18" | "16" | "232" | "233" | "234" | "235" | "236" | "237")
        echo '\[\033[48;5;'"$1"'m\]'
        ;;
     *)
        echo '\[\033[38;5;'"$1"'m\]'
        ;;
    esac
}
export __assign_color

if [ $PROMPT_IP_COLORING -eq 1 ]
then
    # IF OFFLINE then print gray else color
	if [ $PROMPT_SLOW_NETWORK -eq 1 ]
	then
		if nc -w 3 -z 8.8.8.8 53
		then
			export __prompt_COLOR_1="$(__assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f1))"
			export __prompt_COLOR_2="$(__assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f2))"
			export __prompt_COLOR_3="$(__assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f3))"
			export __prompt_COLOR_4="$(__assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f4))"
		else
			export __prompt_COLOR_1="$(__assign_color '0')"
			export __prompt_COLOR_2="$(__assign_color '0')"
			export __prompt_COLOR_3="$(__assign_color '0')"
			export __prompt_COLOR_4="$(__assign_color '0')"
		fi
	else
		export __prompt_COLOR_1='$(net_check && _assign_color $(hostname -I | tr "." " " | cut -d" " -f1) || $(__assign_color "0"))'
		export __prompt_COLOR_2='$(net_check && _assign_color $(hostname -I | tr "." " " | cut -d" " -f2) || $(__assign_color "0"))'
		export __prompt_COLOR_3='$(net_check && _assign_color $(hostname -I | tr "." " " | cut -d" " -f3) || $(__assign_color "0"))'
		export __prompt_COLOR_4='$(net_check && _assign_color $(hostname -I | tr "." " " | cut -d" " -f4) || $(__assign_color "0"))'
	fi

    # Poll google servers for each color
    if [ $PROMPT_SLOW_NETWORK -eq 0 ]
    then
         export __prompt_COLOR_1='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f1)"m\]" || echo "\[\033[48;5;m\]"`'
         export __prompt_COLOR_2='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f2)"m\]" || echo "\[\033[48;5;m\]"`'
         export __prompt_COLOR_3='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f3)"m\]" || echo "\[\033[48;5;m\]"`'
         export __prompt_COLOR_4='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f4)"m\]" || echo "\[\033[48;5;m\]"`'
    elif [ ${PROMPT_RANDOM_COLORING} -eq 1 ]
    then
	    export __prompt_COLOR_1="$(__assign_color $(( ${RANDOM} % 255 )) )"
	    export __prompt_COLOR_2="$(__assign_color $(( ${RANDOM} % 255 )) )"
	    export __prompt_COLOR_3="$(__assign_color $(( ${RANDOM} % 255 )) )"
	    export __prompt_COLOR_4="$(__assign_color $(( ${RANDOM} % 255 )) )"
    fi
fi

