#!/bin/bash

# CONTROLS
#--##############################
#     PROMPT_BATTERY		# Battery life status
#     PROMPT_DATE_TIME		# date/time
#     PROMPT_IP_ADDR		# Local IP address
#     PROMPT_WRK_DIR		# Current working dir
#     PROMPT_GIT_REPO		# Git Repo name
#     PROMPT_GIT_REMOTE		# Git Push/Pull status
#     PROMPT_GIT_BRANCH		# Git branch name / commit status
#     PROMPT_CAPS_LOCK		# Caps lock awareness symbol
#     PROMPT_SSH_ENDING		# SSH awareness symbol
#--##############################

print_menu() {
	[ $PROMPT_BATTERY -eq 0 ] && printf "\e[2m[  b" || printf "\e[38;5;11m[  b"
	printf "\e[0m\e[1;7;36mA\e[0m"
	[ $PROMPT_BATTERY -eq 0 ] && printf "\e[2mt  ]" || printf "\e[38;5;11mt  ]"
	printf "\e[0m"

	[ $PROMPT_DATE_TIME -eq 0 ] && printf "\e[2m[date    " || printf "${__prompt_COLOR_1@P}[date    " | sed "s#\x1##g; s#\x2##g;"
	printf "\e[0m\e[1;7;36mD\e[0m"
	[ $PROMPT_DATE_TIME -eq 0 ] && printf "\e[2m    time]" || printf "${__prompt_COLOR_1@P}    time]" | sed "s#\x1##g; s#\x2##g;"
	printf "\e[0m"

	printf "${__prompt_COLOR_2@P}USER" | sed "s#\x1##g; s#\x2##g;"
	printf "\e[0m"

	[ $PROMPT_IP_ADDR -eq 0 ] && printf "\e[2mip.  " || printf "${__prompt_COLOR_3@P}ip.  " | sed "s#\x1##g; s#\x2##g;"
	printf "\e[0m\e[1;7;36mI\e[0m"
	[ $PROMPT_IP_ADDR -eq 0 ] && printf "\e[2m  .addr" || printf "${__prompt_COLOR_3@P}  .addr" | sed "s#\x1##g; s#\x2##g;"
	printf "\e[0m"

	[ $PROMPT_WRK_DIR -eq 0 ] && printf "\e[2m/wrk/ " || printf "${__prompt_COLOR_4@P}/wrk/ " | sed "s#\x1##g; s#\x2##g;"
	printf "\e[0m\e[1;7;36mW\e[0m"
	[ $PROMPT_WRK_DIR -eq 0 ] && printf "\e[2m /dir" || printf "${__prompt_COLOR_4@P} /dir" | sed "s#\x1##g; s#\x2##g;"
	printf "\e[0m"

	REPO_COLOR=$(( $(echo "  N  " | md5sum | tr -d -c 0-9 | cut -c 1-18 | sed "s/^0*//") % 255 ))
        REPO_INV_COLOR="$(( 255 - ${REPO_COLOR} ))"
	if [ $PROMPT_GIT_REPO -eq 0 ]
	then
		printf "\e[0m\e[2m | "
		printf "\e[0m\e[1;7;36mR\e[0m"
		printf "\e[0m\e[2;4mepo\e[0m\e[2m |"
	else
		printf "\e[0m\e[1;38;5;${REPO_INV_COLOR}m | "
		printf "\e[0m\e[1;7;36mR\e[0m"
		printf "\e[0m\e[1;4;38;5;${REPO_COLOR}mepo\e[0m\e[1;38;5;${REPO_INV_COLOR}m |"
	fi

	[ $PROMPT_GIT_REMOTE -eq 0 ] && printf "\e[2m"
	printf "\e[0m"

	printf "\e[0m \e[1;7;36mB\e[0m"
	[ $PROMPT_GIT_BRANCH -eq 0 ] && printf "\e[2mranch" || printf "\e[32mranch" | sed "s#\x1##g; s#\x2##g;"
	printf "\e[0m"

	[ $PROMPT_CAPS_LOCK  -eq 0 ] && printf "\e[2m"
	printf "\e[0m"
	[ $PROMPT_SSH_ENDING -eq 0 ] && printf "\e[2m"
	printf "\e[0m"

	printf "\n\n"
}

# FROM: cheat bash/ print PS1
# sed script removes escape codes ^A and ^B
print_command_line_demo() {
	echo "${PS1@P@P}"  | sed "s#\x1##g; s#\x2##g;"
}
CHOICE='a'
while [[ ! ${CHOICE^^} == 'Q' ]]
do
	clear
	print_menu
	print_command_line_demo
	printf "\n\tCOMMAND> "
	read CHOICE
	case "${CHOICE^^}"  in
		"A")
			PROMPT_BATTERY=$(( (${PROMPT_BATTERY} + 1) % 2))
			;;
		"D")
			PROMPT_DATE_TIME=$(( (${PROMPT_DATE_TIME} + 1) % 2))
			;;
		"I")
			PROMPT_IP_ADDR=$(( (${PROMPT_IP_ADDR} + 1) % 2))
			;;
		"W")
			PROMPT_WRK_DIR=$(( (${PROMPT_WRK_DIR} + 1) % 2))
			;;
		"R")
			PROMPT_GIT_REPO=$(( (${PROMPT_GIT_REPO} + 1) % 2))
			;;
		"S")
			PROMPT_GIT_SYMBOLS=$(( (${PROMPT_GIT_SYMBOLS} + 1) % 2))
			;;
		"B")
			PROMPT_GIT_BRANCH=$(( (${PROMPT_GIT_BRANCH} + 1) % 2))
			;;
		"P")
			PROMPT_GIT_REMOTE=$(( (${PROMPT_GIT_REMOTE} + 1) % 2))
			;;
		"H")
			PROMPT_SSH_ENDING=$(( (${PROMPT_SSH_ENDING} + 1) % 2))
			;;
		"C")
			PROMPT_CAPS_LOCK=$(( (${PROMPT_CAPS_LOCK} + 1) % 2))
			;;
		"*")
			echo "Invalid command"
			;;
	esac
done
clear
