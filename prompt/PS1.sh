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

print_commands() {
	# B D I W G P S R E C
	printf "COMMANDS  :  "

	[ $PROMPT_BATTERY -eq 1 ]     && printf "     \e[0m\e[1;7;36mB\e[0m     "       || printf "     \e[0m\e[1;7;33mB\e[0m     " 
	[ $PROMPT_DATE_TIME -eq 1 ]   && printf "        \e[0m\e[1;7;36mD\e[0m        " || printf "        \e[0m\e[1;7;33mD\e[0m        "
	printf "     "
	[ $PROMPT_IP_ADDR -eq 1 ]     && printf "      \e[0m\e[1;7;36mI\e[0m      "     || printf "      \e[0m\e[1;7;33mI\e[0m      "
	[ $PROMPT_WRK_DIR -eq 1 ]     && printf "      \e[0m\e[1;7;36mW\e[0m      "     || printf "      \e[0m\e[1;7;33mW\e[0m      "
	[ $PROMPT_GIT_REPO -eq 1 ]    && printf "   \e[0m\e[1;7;36mG\e[0m    "          || printf "   \e[0m\e[1;7;33mG\e[0m    "
	[ $PROMPT_GIT_REMOTE -eq 1 ]  && printf " \e[0m\e[1;7;36mP\e[0m  "              || printf " \e[0m\e[1;7;33mP\e[0m  "
	[ $PROMPT_GIT_SYMBOLS -eq 1 ] && printf " \e[0m\e[1;7;36mS\e[0m "               || printf " \e[0m\e[1;7;33mS\e[0m "
	[ $PROMPT_GIT_BRANCH -eq 1 ]  && printf "  \e[0m\e[1;7;36mR\e[0m   "            || printf "  \e[0m\e[1;7;33mR\e[0m   "
	[ $PROMPT_CAPS_LOCK  -eq 1 ]  && printf "   \e[0m\e[1;7;36mC\e[0m   "           || printf "   \e[0m\e[1;7;33mC\e[0m   "
	[ $PROMPT_SSH_ENDING -eq 1 ]  && printf " \e[0m\e[1;7;36mE\e[0m"                || printf " \e[0m\e[1;7;33mE\e[0m"
	printf "\n"
}

print_components() {
	printf "COMPONENTS:  "
	[ $PROMPT_BATTERY -eq 0 ] && printf "\e[38;5;9m" || printf "\e[38;5;10m"
	printf "[ BATTERY ]\e[0m"

	[ $PROMPT_DATE_TIME -eq 0 ] && printf "\e[38;5;9m" || printf "\e[38;5;10m"
	printf "[ DATE    TIME ]\e[0m"

	printf "${__prompt_COLOR_2@P}user\e[0m" | sed "s#\x1##g; s#\x2##g;"

	printf ":"
	[ $PROMPT_IP_ADDR -eq 0 ] && printf "\e[38;5;9m" || printf "\e[38;5;10m"
	printf "IP.ADD.RE.SS\e[0m"
	printf ":"

	[ $PROMPT_WRK_DIR -eq 0 ] && printf "\e[38;5;9m" || printf "\e[38;5;10m"
	printf "/wrk/ing/dir\e[0m"

	[ $PROMPT_GIT_REPO -eq 0 ] && printf "\e[38;5;9m" || printf "\e[38;5;10m"
	printf " | Repo | \e[0m"

	[ $PROMPT_GIT_REMOTE -eq 0 ] && printf "\e[38;5;9m" || printf "\e[38;5;10m"
	printf "v^ \e[0m"

	[ $PROMPT_GIT_SYMBOLS -eq 0 ] && printf "\e[38;5;9m" || printf "\e[38;5;10m"
	printf "*+ \e[0m"

	[ $PROMPT_GIT_BRANCH -eq 0 ] && printf "\e[38;5;9m" || printf "\e[38;5;10m"
	printf "branch\e[0m"

	[ $PROMPT_CAPS_LOCK  -eq 0 ] && printf "\e[38;5;9m" || printf "\e[38;5;10m"
	printf " ©CAPS©\e[0m"

	[ $PROMPT_SSH_ENDING -eq 0 ] && printf "\e[38;5;9m" || printf "\e[38;5;10m"
	printf ' $#\e[0m'

	printf "\n\n"
}

# FROM: cheat bash/ print PS1
# sed script removes escape codes ^A and ^B
print_preview() {
	printf "PREVIEW   :  "
	echo "${PS1@P@P}"  | sed "s#\x1##g; s#\x2##g;"
}
CHOICE='a'
while [[ ! ${CHOICE^^} == 'Q' ]]
do
	clear
	print_commands
	print_components
	print_preview
	printf "\n\tCOMMAND> "
	read CHOICE
	case "${CHOICE^^}"  in
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
		"S")
			PROMPT_GIT_SYMBOLS=$(( (${PROMPT_GIT_SYMBOLS} + 1) % 2))
			;;
		"R")
			PROMPT_GIT_BRANCH=$(( (${PROMPT_GIT_BRANCH} + 1) % 2))
			;;
		"E")
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
