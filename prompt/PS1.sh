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
	local RST="\e[0m"
	local ON="\e[7;36m"
	local OFF="\e[7;33m"
	local B D I W G P S R E C
	[ $PROMPT_BATTERY -eq 1 ]     && B="${ON}B${RST}" || B="${OFF}B${RST}"
	[ $PROMPT_DATE_TIME -eq 1 ]   && D="${ON}D${RST}" || D="${OFF}D${RST}"
	[ $PROMPT_IP_ADDR -eq 1 ]     && I="${ON}I${RST}" || I="${OFF}I${RST}"
	[ $PROMPT_WRK_DIR -eq 1 ]     && W="${ON}W${RST}" || W="${OFF}W${RST}"
	[ $PROMPT_GIT_REPO -eq 1 ]    && G="${ON}G${RST}" || G="${OFF}G${RST}"
	[ $PROMPT_GIT_REMOTE -eq 1 ]  && P="${ON}P${RST}" || P="${OFF}P${RST}"
	[ $PROMPT_GIT_SYMBOLS -eq 1 ] && S="${ON}S${RST}" || S="${OFF}S${RST}"
	[ $PROMPT_GIT_BRANCH -eq 1 ]  && R="${ON}R${RST}" || R="${OFF}R${RST}"
	[ $PROMPT_CAPS_LOCK  -eq 1 ]  && C="${ON}C${RST}" || C="${OFF}C${RST}"
	[ $PROMPT_SSH_ENDING -eq 1 ]  && E="${ON}E${RST}" || E="${OFF}E${RST}"
	printf "COMMANDS  :     $B         $D              $I         $W       $G     $P   $S    $R      $C    $E\n"
}

print_components() {
	local RST="\e[0m"
	local ON="\e[38;5;10m"
	local OFF="\e[38;5;9m"
	local B D U I W G P S R E C
	[ $PROMPT_BATTERY -eq 1 ]     && B="${ON}[ BAT ]${RST}"      || B="${OFF}[ BAT ]${RST}"
	[ $PROMPT_DATE_TIME -eq 1 ]   && D="${ON}[DATE  TIME]${RST}" || D="${OFF}[DATE  TIME]${RST}"
	U=$(printf "${__prompt_COLOR_2@P}user\e[0m" | sed "s#\x1##g; s#\x2##g;")
	[ $PROMPT_IP_ADDR -eq 1 ]     && I="${ON}:IP.A.DD.R${RST}"   || I="${OFF}:IP.A.DD.R${RST}"
	[ $PROMPT_WRK_DIR -eq 1 ]     && W="${ON}:/wrk/dir${RST}"    || W="${OFF}:/wrk/dir${RST}"
	[ $PROMPT_GIT_REPO -eq 1 ]    && G="${ON} | Repo | ${RST}"   || G="${OFF} | Repo | ${RST}"
	[ $PROMPT_GIT_REMOTE -eq 1 ]  && P="${ON}v^ ${RST}"          || P="${OFF}v^ ${RST}"
	[ $PROMPT_GIT_SYMBOLS -eq 1 ] && S="${ON}@*+${RST}"          || S="${OFF}@*+${RST}"
	[ $PROMPT_GIT_BRANCH -eq 1 ]  && R="${ON} branch ${RST}"     || R="${OFF} branch ${RST}"
	[ $PROMPT_SSH_ENDING -eq 1 ]  && E="${ON} \$§H ${RST}"       || E="${OFF} \$§H ${RST}"
	[ $PROMPT_CAPS_LOCK  -eq 1 ]  && C="${ON}©CAP©${RST}"        || C="${OFF}©CAP©${RST}"
	printf "COMPONENTS:  $B$D$U$I$W$G$P$S$R$C$E\n\n"
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
