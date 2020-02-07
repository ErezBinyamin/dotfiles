#!/bin/bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# set variable identifying this machines ip address (used in the prompt below)
# Color the command line according to the IP, sed away the bad colors
# Helper function for generating IP-color string
# Replaces hard to see colors with highlighed backgrounds
_assign_color() {
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

# IP address definition, either live or on source define
if [ $SLOW_NETWORK -eq 0 ]
then
__ip_addr='`
if [ ${PROMPT_IP_COLORING} -eq 1 ]
then
	if whereis nc &>/dev/null && hostname -I &>/dev/null
	then
		nc -w 3 -z 8.8.8.8 53 && hostname -I | cut -d" " -f1 || echo OFFLINE
	else
		ip addr | grep inet | grep global | head -n1 | tr " " "\t" | tr "//" "\t"| cut -f6 || echo OFFLINE
	fi
fi
`'
else
__ip_addr="`
if [ ${PROMPT_IP_COLORING} -eq 1 ]
then
	if whereis nc &>/dev/null && hostname -I &>/dev/null
	then
		nc -w 3 -z 8.8.8.8 53 && hostname -I | cut -d' ' -f1 || echo OFFLINE
	else
		ip addr | grep inet | grep global | head -n1 | tr ' ' '\t' | tr '//' '\t'| cut -f6 || echo OFFLINE
	fi
fi
`"
fi


if [ $IP_COLORING -eq 1 ]
then
    # IF OFFLINE then print gray else color
	if [ $SLOW_NETWORK -eq 1 ]
	then
		if nc -w 3 -z 8.8.8.8 53
		then
			__COLOR_1="$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f1))"
			__COLOR_2="$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f2))"
			__COLOR_3="$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f3))"
			__COLOR_4="$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f4))"
		else
			__COLOR_1="$(_assign_color '0')"
			__COLOR_2="$(_assign_color '0')"
			__COLOR_3="$(_assign_color '0')"
			__COLOR_4="$(_assign_color '0')"
		fi
	else
		__COLOR_1='$(net_check && _assign_color $(hostname -I | tr "." " " | cut -d" " -f1) || $(_assign_color "0"))'
		__COLOR_2='$(net_check && _assign_color $(hostname -I | tr "." " " | cut -d" " -f2) || $(_assign_color "0"))'
		__COLOR_3='$(net_check && _assign_color $(hostname -I | tr "." " " | cut -d" " -f3) || $(_assign_color "0"))'
		__COLOR_4='$(net_check && _assign_color $(hostname -I | tr "." " " | cut -d" " -f4) || $(_assign_color "0"))'
	fi

    # Poll google servers for each color
    if [ $SLOW_NETWORK -eq 0 ]
    then
         __COLOR_1='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f1)"m\]" || echo "\[\033[48;5;m\]"`'
         __COLOR_2='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f2)"m\]" || echo "\[\033[48;5;m\]"`'
         __COLOR_3='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f3)"m\]" || echo "\[\033[48;5;m\]"`'
         __COLOR_4='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f4)"m\]" || echo "\[\033[48;5;m\]"`'
    fi
fi

