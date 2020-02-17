#!/bin/bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# CONTROLS
#--##############################
PROMPT_DEFAULT=0		# Ignore all prompt customizations and use ubuntu default
PROMPT_SLOW_NETWORK=1		# If you have a slow network, set to a '1' to stop all slow network items

PROMPT_IP_COLORING=1		# Use IP octets to color command line
PROMPT_RANDOM_COLORING=0	# Randomize prompt colors (override IP coloring)

PROMPT_BATTERY=1		# Battery life status
PROMPT_DATE_TIME=1		# date/time
PROMPT_IP_ADDR=1		# Local IP address
PROMPT_WRK_DIR=1		# Current working dir
PROMPT_GIT_REPO=1		# Git Repo name
PROMPT_GIT_REMOTE=1		# Git Push/Pull status
PROMPT_GIT_BRANCH=1		# Git branch name / commit status
PROMPT_CAPS_LOCK=1		# Caps lock awareness symbol
PROMPT_SSH_ENDING=1		# SSH awareness symbol
#--##############################

# Get other prompt tools
for prompt_tool in $( ls *.sh )
do
	source $prompt_tool
done

# TODO: actually calculate size of prompt instead of hardcoding
# Always leave room for at least 20 chars of command
# 55 is the stated length of the nonDir_part of the prompt
# TERM_WIDTH - 55 - (length of pwd)
__prompt_wrk_dir='`
[ $(( $(tput cols) - 55 - $(pwd | wc -c) )) -lt 20 ] && printf \W || printf \w
`'

# CAPS LOCK notification symbol
__prompt_caps_lock='`
PROMPT_CAPS_LOCK_SYMBOL="©"
if [ ${PROMPT_CAPS_LOCK} -eq 1 ]
then
	if [ ${PROMPT_CAPS_LOCK} -eq 1 ] && xset -h &>/dev/null
	then
		xset q | grep -q "00: Caps Lock:   off" || printf "${PROMPT_CAPS_LOCK_SYMBOL}"
	fi
fi
`'

# Define ending symbol
#	ssh  = §
#	root = #
#	else = $
__prompt_ending='`
PROMPT_SSH_SYMBOL="§"
if [ ${PROMPT_SSH_ENDING} -eq 1 ]
then
	if [ ! -x ${SSH_CLIENT+x} ]
	then
		printf "${PROMPT_SSH_SYMBOL} "
	else
		printf "\$ "
	fi
else
	printf "\$ "
fi
`'

# Define reset formatting string
RST="\[\033[00m\]"

#################################################
#			                        #
#	----ACTUALLY SET THE PS1----		#
#			                        #
#################################################
if [ ${PROMPT_DEFAULT} -ne 1 ]
then
	unset PS1
	PS1="${__prompt_bat_life}"				# Battery life
	PS1+="${RST}"
	PS1+="${__prompt_COLOR_1}${__prompt_date_time}"		# Date and time
	PS1+="${RST}"
	PS1+="${__prompt_COLOR_2}\u@"				# Username '@'
	PS1+="${RST}"
	PS1+="${__prompt_COLOR_3}${__prompt_ip_addr}:"		# IP address ':'
	PS1+="${RST}"
	PS1+="${__prompt_COLOR_4}${__prompt_wrk_dir}"		# Working directory
	PS1+="${RST}"
	PS1+="${__prompt_git_repo}"				# Repo name
	PS1+="${RST}"
	PS1+="${__prompt_git_pull}${__prompt_git_push}"		# Push pull arrows
	PS1+="${RST}"
	PS1+="${__prompt_git_color}${__prompt_git_branch}"	# Colored git branch/status
	PS1+="${RST}"
	PS1+="${__prompt_caps_lock}"				# Caps lock notification
	PS1+="${RST}"
	PS1+="${__prompt_ending}"				# End with: '$|§' and a space
	PS1+="${RST}"
fi
