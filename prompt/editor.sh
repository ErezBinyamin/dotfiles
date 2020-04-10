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
	printf "
+---------+---------------+-------------+
| COMMAND |    EFFECT	  |   STATUS	|
+---------+---------------+-------------+
|    B    |    Battery    |	${PROMPT_BATTERY}	|
|    D    |  Date & Time  |	${PROMPT_DATE_TIME}	|
|    I    |   IP address  |	${PROMPT_IP_ADDR}	|
|    W    |  Working Dir  |	${PROMPT_WRK_DIR}	|
|    G    | Git Repo Name |	${PROMPT_GIT_REPO}	|
|    P    | Git Push/Pull |	${PROMPT_GIT_REMOTE}	|
|    R    |  Git Branch   |	${PROMPT_GIT_BRANCH}	|
|    C    |   Caps Lock	  |	${PROMPT_CAPS_LOCK}	|
|    S    |  SSH Ending	  |	${PROMPT_SSH_ENDING}	|
|    Q    |  Quit_Editor  |	-	|
+---------+---------------+-------------+
	" | grep -C 100 -e '0' -e ' ' 2>/dev/null
}

print_command_line_demo() {
	printf "\n"

	echo "${PS1}" | sed 's#\\\[##g; s#\\\]##g; s/`\\033/printf "\\033/; s/192m`/192m"/; s/00m`/00m"/; /``/d; s#1m`#1m"\n#; s/`:/\nprintf "/; s/m`/m"/g; s/m"/m"\n/' | tail +2 | head -n -1 | bash 2>/dev/null | tr -d '\n'

	printf "\e[0m\n"
}

CHOICE='a'
while [[ ! ${CHOICE^^} == 'Q' ]]
do
	clear
	print_menu
	print_command_line_demo
	printf "\n\tCOMMAND> "
	read CHOICE
	case "${CHOICE^^}" in
		"B")
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
		"G")
			PROMPT_GIT_REPO=$(( (${PROMPT_GIT_REPO} + 1) % 2))
			;;
		"P")
			PROMPT_GIT_REMOTE=$(( (${PROMPT_GIT_REMOTE} + 1) % 2))
			;;
		"R")
			PROMPT_GIT_BRANCH=$(( (${PROMPT_GIT_BRANCH} + 1) % 2))
			;;
		"C")
			PROMPT_CAPS_LOCK=$(( (${PROMPT_CAPS_LOCK} + 1) % 2))
			;;
		"S")
			PROMPT_SSH_ENDING=$(( (${PROMPT_SSH_ENDING} + 1) % 2))
			;;
		"*")
			echo "Invalid command"
			;;
	esac
done
clear
