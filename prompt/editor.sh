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
|    L    |   Bat Life    |	${PROMPT_BATTERY}	|
|    D    |  Date & Time  |	${PROMPT_DATE_TIME}	|
|    I    |   IP address  |	${PROMPT_IP_ADDR}	|
|    W    |  Working Dir  |	${PROMPT_WRK_DIR}	|
|    N    | Git Repo Name |	${PROMPT_GIT_REPO}	|
|    S    |  Git Symbols  |	${PROMPT_GIT_SYMBOLS}	|
|    B    |  Git Branch   |	${PROMPT_GIT_BRANCH}	|
|    P    | Git Push/Pull |	${PROMPT_GIT_REMOTE}	|
|    H    |  SSH Ending	  |	${PROMPT_SSH_ENDING}	|
|    C    |   Caps Lock	  |	${PROMPT_CAPS_LOCK}	|
|    Q    |  Quit_Editor  |	-	|
+---------+---------------+-------------+
	" | grep -C 100 -e '0' -e ' ' 2>/dev/null
}

print_command_line_demo() {
	RST="\033[00m"
	printf "\n"
	echo "$__prompt_bat_life"          | sed 's/`//g; s#\\\[##g; s#\\\]##g' | bash
	printf "${RST}${__prompt_COLOR_1}" | sed 's#\\\[##g; s#\\\]##g'
	echo "$__prompt_date_time"         | sed 's/`//g; s#\\\[##g; s#\\\]##g' | bash
	printf "${RST}${__prompt_COLOR_2}" | sed 's#\\\[##g; s#\\\]##g'
	printf "${USER}"
	printf "${RST}${__prompt_COLOR_3}" | sed 's#\\\[##g; s#\\\]##g'
	echo "$__prompt_ip_addr"           | sed 's/`//g; s#\\\[##g; s#\\\]##g' | bash
	printf "${RST}${__prompt_COLOR_4}" | sed 's#\\\[##g; s#\\\]##g'
	echo "$__prompt_wrk_dir"           | sed 's/`//g; s#\\\[##g; s#\\\]##g' | bash
	echo "$__prompt_git_repo"          | sed 's/`//g; s#\\\[##g; s#\\\]##g' | bash
	echo "$__prompt_git_color"         | sed 's/`//g; s#\\\[##g; s#\\\]##g' | bash
	echo "$__prompt_git_branch"        | sed 's/`//g; s#\\\[##g; s#\\\]##g' | bash | tr -d '\n'
	printf "${RST}"
	echo "$__prompt_git_push"          | sed 's/`//g; s#\\\[##g; s#\\\]##g' | bash
	echo "$__prompt_git_pull"          | sed 's/`//g; s#\\\[##g; s#\\\]##g' | bash
	printf "${RST}"
	echo "$__prompt_caps_lock"         | sed 's/`//g; s#\\\[##g; s#\\\]##g' | bash
	printf "${RST}"
	echo "$__prompt_ending"            | sed 's/`//g; s#\\\[##g; s#\\\]##g' | bash
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
