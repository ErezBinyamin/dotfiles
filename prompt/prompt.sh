#!/bin/bash

# Get other prompt tools
WRK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TOOLS=( 'battery.sh' 'coloring.sh' 'date_time.sh' 'default.sh' 'git.sh' 'ip_addr.sh' 'wrk_dir.sh' )
source "${WRK_DIR}/config.sh"
for prompt_tool in ${TOOLS[@]}
do
	source "${WRK_DIR}/${prompt_tool}"
done


# CAPS LOCK notification symbol
__prompt_caps_lock='`
PROMPT_CAPS_LOCK_SYMBOL="🆑"
if [ ${PROMPT_CAPS_LOCK} -eq 1 ]
then
	if [ ${PROMPT_CAPS_LOCK} -eq 1 ] && xset -h &>/dev/null
	then
		xset q | grep -q "00: Caps Lock:   off" || printf "${PROMPT_CAPS_LOCK_SYMBOL}"
	fi
fi
`'

# Define ending symbol
#	ssh  = 🔒🐚
#	root = #
#	else = 🐚
__prompt_ending='`
PROMPT_SSH_SYMBOL="🔒🐚"
if [ ${PROMPT_SSH_ENDING} -eq 1 ]
then
	if [ ! -x ${SSH_CLIENT+x} ]
	then
		printf "${PROMPT_SSH_SYMBOL} "
	else
		printf "🐚 "
	fi
else
	printf "🐚 "
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
	PS1+="${__prompt_COLOR_2}${USER}@"			# Username '@'
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
