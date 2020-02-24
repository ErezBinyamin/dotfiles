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
COMMAND	|	EFFECT	|	STATUS
--------------------------------------------
   B	|    Battery 	|	${PROMPT_BATTERY}
   D	|  Date & Time	|	${PROMPT_DATE_TIME}
   I	|   IP address	|	${PROMPT_IP_ADDR}
   W	|  Working Dir	|	${PROMPT_WRK_DIR}
   G	| Git Repo Name |	${PROMPT_GIT_REPO}
   P	| Git Push/Pull |	${PROMPT_GIT_REMOTE}
   R	|  Git Branch	|	${PROMPT_GIT_BRANCH}
   C	|   Caps Lock	|	${PROMPT_CAPS_LOCK}
   S	|  SSH Ending	|	${PROMPT_CAPS_LOCK}
	"
}

print_command_line_demo() {
	printf "\n"

	echo "${PS1}" | tr -d '`' | sed 's#\\\[##g; s#\\\]##g;' | sed '/printf/!s/\\033\[00m/\\033\[00m\n/' | sed '/printf/!s/m/m"/; /printf/!s/\\033/printf "\\033/' | sed '/date/s/m"/m/; /IP_ADDR/s/\\033/printf "\\033/; /IP_ADDR/s/86m/86m";/; /IP_ADDR/s/:\\033/;printf ":\\033/; /IP_ADDR/s/89m/89m"/; /=/s/m"/m/; /BAT/s/m"/m/; /REPO_COLOR/s/"s/s/; s#/"#/#' | bash

	printf "\n"

}

CHOICE='a'
while [[ ! ${CHOICE^^} == 'Q' ]]
do
	clear
	print_menu
	print_command_line_demo
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
