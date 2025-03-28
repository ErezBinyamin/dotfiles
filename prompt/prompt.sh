#!/bin/bash

# Get other prompt tools
PROMPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TOOLS=( 'battery.sh' 'capslock.sh' 'coloring.sh' 'datetime.sh' 'default.sh' 'ending.sh' 'git.sh' 'ipaddr.sh' 'wrkdir.sh' )
source "${PROMPT_DIR}/config.sh"
for prompt_tool in ${TOOLS[@]}
do
	source "${PROMPT_DIR}/${prompt_tool}"
done

# Run some functions to define some more envars
export NC='\[\033[0m\]\[\033[39;49m\]'
__prompt_ending_func
if [ -z ${USER} ]
then
  USER=$(whoami) || USER=SUPERUSER
  export USER
fi

# Define prompt command sequence to run every command
__prompt_command(){
  __prompt_battery_func
  __prompt_capslock_func
  #__prompt_ending_func
}
PROMPT_COMMAND=__prompt_command

#################################################
#	                                              #
#	         ----ACTUALLY SET THE PS1----         #
#                                               #
#################################################
if [ ${PROMPT_DEFAULT:-0} -ne 1 ]
then
	unset PS1
	PS1="\${__prompt_battery_str@P}"
	PS1+="${NC}"
	PS1+="${__prompt_COLOR_1}${__prompt_datetime}"
	PS1+="${NC}"
	PS1+="${__prompt_COLOR_2}${USER}"
	PS1+="${NC}"
	PS1+="${__prompt_COLOR_3}${__prompt_ipaddr}"
	PS1+="${NC}"
	PS1+="${__prompt_COLOR_4}${__prompt_wrkdir}"
	PS1+="${NC}"
	PS1+="${__prompt_git_repo}"
	PS1+="${NC}"
	PS1+="${__prompt_git_pull}${__prompt_git_push}"
	PS1+="${NC}"
	PS1+="${__prompt_git_color}${__prompt_git_branch}"
	PS1+="${NC}"
	PS1+="\${__prompt_capslock_str@P}"
	PS1+="${NC}"
	PS1+="\${__prompt_ending_str@P}"
	PS1+="${NC}"

	unset PS1_noDir
	PS1_noDir="${__prompt_battery}"
	PS1_noDir+="${__prompt_datetime}"
	PS1_noDir+="${USER}"
	PS1_noDir+="${__prompt_ipaddr}"
	PS1_noDir+="${__prompt_git_repo}"
	PS1_noDir+="${__prompt_git_pull}${__prompt_git_push}"
	PS1_noDir+="${__prompt_git_color}${__prompt_git_branch}"
	PS1_noDir+="${__prompt_caps_lock}"
	PS1_noDir+="${__prompt_ending}"
fi
