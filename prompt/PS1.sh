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
+---------+---------------+-------------+	+---------+---------------+-------------+	+---------+---------------+-------------+
| COMMAND |    EFFECT	  |   STATUS	|	| COMMAND |    EFFECT	  |   STATUS	|	| COMMAND |    EFFECT     |   STATUS    |
+---------+---------------+-------------+	+---------+---------------+-------------+	+---------+---------------+-------------+
|    L    |   Bat Life    |	${PROMPT_BATTERY}	|	|    N    | Git Repo Name |	${PROMPT_GIT_REPO}	|	|    H    |  SSH Ending	  |	${PROMPT_SSH_ENDING}	|
|    D    |  Date & Time  |	${PROMPT_DATE_TIME}	|	|    S    |  Git Symbols  |	${PROMPT_GIT_SYMBOLS}	|	|    C    |   Caps Lock	  |	${PROMPT_CAPS_LOCK}	|
|    I    |   IP address  |	${PROMPT_IP_ADDR}	|	|    B    |  Git Branch   |	${PROMPT_GIT_BRANCH}	|	|	  |		  |		|
|    W    |  Working Dir  |	${PROMPT_WRK_DIR}	|	|    P    | Git Push/Pull |	${PROMPT_GIT_REMOTE}	|	|	  |		  |		|
+---------+---------------+-------------+	+---------+---------------+-------------+	+---------+---------------+-------------+

+---------+---------------+-------------+
|    Q    |  Quit_Editor  |	-	|
+---------+---------------+-------------+
	" | grep -C 100 -e '0' -e ' ' 2>/dev/null
}

# FROM: cheat bash/ print PS1
# sed script removes escape codes ^A and ^B
print_command_line_demo() {
	echo "${PS1@P}" | sed "s#\x1##g; s#\x2##g;"
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
		"L")
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
		"N")
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
