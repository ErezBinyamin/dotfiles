#!/bin/bash

# CONTROLS
#--##############################
#     PROMPT_BATTERY		# Battery life status
#     PROMPT_DATETIME		# date/time
#     PROMPT_IPADDR		# Local IP address
#     PROMPT_WRK_DIR		# Current working dir
#     PROMPT_GIT_REPO		# Git Repo name
#     PROMPT_GIT_REMOTE		# Git Push/Pull status
#     PROMPT_GIT_SYMBOLS	# Git change-file/add-file symbols
#     PROMPT_GIT_BRANCH		# Git branch name / commit status
#     PROMPT_CAPS_LOCK		# Caps lock awareness symbol
#     PROMPT_ENV_ENDING		# SSH awareness symbol
#--##############################

# Print each command char highlighted with the ON(blue) or OFF(yellow) color
print_commands() {
	local RST="\e[0m"
	local ON="\e[7;36m"	# Highlight Blue
	local OFF="\e[7;33m"	# Highlight Yellow
	local B D I W G P S R E C
	[ $PROMPT_BATTERY -eq 1 ]     && B="${ON}B${RST}" || B="${OFF}B${RST}"
	[ $PROMPT_DATETIME -eq 1 ]   && D="${ON}D${RST}" || D="${OFF}D${RST}"
	[ $PROMPT_IPADDR -eq 1 ]     && I="${ON}I${RST}" || I="${OFF}I${RST}"
	[ $PROMPT_WRK_DIR -eq 1 ]     && W="${ON}W${RST}" || W="${OFF}W${RST}"
	[ $PROMPT_GIT_REPO -eq 1 ]    && G="${ON}G${RST}" || G="${OFF}G${RST}"
	[ $PROMPT_GIT_REMOTE -eq 1 ]  && P="${ON}P${RST}" || P="${OFF}P${RST}"
	[ $PROMPT_GIT_SYMBOLS -eq 1 ] && S="${ON}S${RST}" || S="${OFF}S${RST}"
	[ $PROMPT_GIT_BRANCH -eq 1 ]  && R="${ON}R${RST}" || R="${OFF}R${RST}"
	[ $PROMPT_CAPS_LOCK  -eq 1 ]  && C="${ON}C${RST}" || C="${OFF}C${RST}"
	[ $PROMPT_ENV_ENDING -eq 1 ]  && E="${ON}E${RST}" || E="${OFF}E${RST}"
	printf "COMMANDS  :     $B         $D              $I         $W       $G     $P   $S    $R      $C    $E\n"
}

# Print each command component with the ON(green) or OFF(red) color
print_components() {
	local RST="\e[0m"
	local ON="\e[38;5;10m"	# Green
	local OFF="\e[38;5;9m"	# Red
	local B D U I W G P S R E C
	[ $PROMPT_BATTERY -eq 1 ]     && B="${ON}[ BAT ]${RST}"      || B="${OFF}[ BAT ]${RST}"
	[ $PROMPT_DATETIME -eq 1 ]   && D="${ON}[DATE  TIME]${RST}" || D="${OFF}[DATE  TIME]${RST}"
	U=$(printf "${__prompt_COLOR_2@P}user\e[0m" | sed "s#\x1##g; s#\x2##g;")
	[ $PROMPT_IPADDR -eq 1 ]     && I="${ON}:IP.A.DD.R${RST}"   || I="${OFF}:IP.A.DD.R${RST}"
	[ $PROMPT_WRK_DIR -eq 1 ]     && W="${ON}:/wrk/dir${RST}"    || W="${OFF}:/wrk/dir${RST}"
	[ $PROMPT_GIT_REPO -eq 1 ]    && G="${ON} | Repo | ${RST}"   || G="${OFF} | Repo | ${RST}"
	[ $PROMPT_GIT_REMOTE -eq 1 ]  && P="${ON}v^ ${RST}"          || P="${OFF}v^ ${RST}"
	[ $PROMPT_GIT_SYMBOLS -eq 1 ] && S="${ON}@*+${RST}"          || S="${OFF}@*+${RST}"
	[ $PROMPT_GIT_BRANCH -eq 1 ]  && R="${ON} branch ${RST}"     || R="${OFF} branch ${RST}"
	[ $PROMPT_ENV_ENDING -eq 1 ]  && E="${ON} \$§H ${RST}"       || E="${OFF} \$§H ${RST}"
	[ $PROMPT_CAPS_LOCK  -eq 1 ]  && C="${ON}©CAP©${RST}"        || C="${OFF}©CAP©${RST}"
	printf "COMPONENTS:  $B$D$U$I$W$G$P$S$R$C$E\n\n"
}

# FROM: cheat bash/ print PS1
# sed script removes escape codes ^A and ^B
print_preview() {
	printf "PREVIEW   :\n"
	#echo "${PS1@P@P}"  | sed "s#\x1##g; s#\x2##g;"
	bash -c "echo \"${PS1@P}\""
}
CHOICE='-'
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
			PROMPT_DATETIME=$(( (${PROMPT_DATETIME} + 1) % 2))
			;;
		"I")
			PROMPT_IPADDR=$(( (${PROMPT_IPADDR} + 1) % 2))
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
			PROMPT_ENV_ENDING=$(( (${PROMPT_ENV_ENDING} + 1) % 2))
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
