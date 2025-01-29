#!/bin/bash

# Get other prompt tools
PROMPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TOOLS=( 'battery.sh' 'coloring.sh' 'datetime.sh' 'default.sh' 'git.sh' 'ipaddr.sh' 'wrkdir.sh' )
source "${PROMPT_DIR}/config.sh"
for prompt_tool in ${TOOLS[@]}
do
	source "${PROMPT_DIR}/${prompt_tool}"
done

# CAPS LOCK notification symbol
export __prompt_caps_lock='`
PROMPT_CAPS_LOCK_SYMBOL="©"
if [ ${PROMPT_CAPS_LOCK:-0} -eq 1 ]
then
	if [ ${PROMPT_CAPS_LOCK:-0} -eq 1 ] && xset -h &>/dev/null
	then
		xset q | grep -q "00: Caps Lock:   off" || printf "${PROMPT_CAPS_LOCK_SYMBOL}"
	fi
fi
`'

# Define ending symbol
#	ssh    = §
#	docker = {
#	else   = $
export __prompt_ending='`
PROMPT_SSH_SYMBOL="§ "
PROMPT_DOCKER_SYMBOL="{ "
PROMPT_DEFAULT_SYMBOL="\$ "
if [ ${PROMPT_ENV_ENDING:-0} -eq 1 ]
then
	if [ ! -x ${SSH_CLIENT+x} ]
	then
		printf "${PROMPT_SSH_SYMBOL}"
	elif grep -q docker /proc/1/cgroup || [ -f /.dockerenv ]
	then
		printf "${PROMPT_DOCKER_SYMBOL}"
	else
		printf "${PROMPT_DEFAULT_SYMBOL}"
	fi
else
	printf "${PROMPT_DEFAULT_SYMBOL}"
fi
`'

#################################################
#			                        #
#	----ACTUALLY SET THE PS1----		#
#			                        #
#################################################
if [ ${PROMPT_DEFAULT:-0} -ne 1 ]
then
	unset PS1
	PS1="${__prompt_battery}"				# Battery life
	PS1+='\033[0m'
	PS1+="${__prompt_COLOR_1}${__prompt_datetime}"		# Date and time
	PS1+='\033[0m'
	PS1+="${__prompt_COLOR_2}${USER:-SUPERUSER}"		# Username
	PS1+='\033[0m'
	PS1+="${__prompt_COLOR_3}${__prompt_ipaddr}"		# IP address
	PS1+='\033[0m'
	PS1+="${__prompt_COLOR_4}${__prompt_wrkdir}"		# Working directory
	PS1+='\033[0m'
	PS1+="${__prompt_git_repo}"				# Repo name
	PS1+='\033[0m'
	PS1+="${__prompt_git_pull}${__prompt_git_push}"		# Push pull arrows
	PS1+='\033[0m'
	PS1+="${__prompt_git_color}${__prompt_git_branch}"	# Colored git branch/status
	PS1+='\033[0m'
	PS1+="${__prompt_caps_lock}"				# Caps lock notification
	PS1+='\033[0m'
	PS1+="${__prompt_ending}"				# End with: "${__prompt_ending}"
	PS1+='\033[0m'

	unset PS1_noDir
	PS1_noDir="${__prompt_battery}"			 # Battery life
	PS1_noDir+="${__prompt_datetime}"			 # Date and time
	PS1_noDir+="${USER:-SUPERUSER}"				 # Username
	PS1_noDir+="${__prompt_ipaddr}"			 # IP address
	PS1_noDir+="${__prompt_git_repo}"			 # Repo name
	PS1_noDir+="${__prompt_git_pull}${__prompt_git_push}"	 # Push pull arrows
	PS1_noDir+="${__prompt_git_color}${__prompt_git_branch}" # Colored git branch/status
	PS1_noDir+="${__prompt_caps_lock}"			 # Caps lock notification
	PS1_noDir+="${__prompt_ending}"				 # End with: "${__prompt_ending}"
fi
