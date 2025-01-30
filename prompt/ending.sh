#!/bin/bash

# Define ending symbol
#	ssh    = §
#	docker = {
#	else   = $
__prompt_ending_func(){
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
  		__prompt_ending_str="${PROMPT_DOCKER_SYMBOL}"
  	else
  		__prompt_ending_str="${PROMPT_DEFAULT_SYMBOL}"
  	fi
  else
  	__prompt_ending_str="${PROMPT_DEFAULT_SYMBOL}"
  fi
  export __prompt_ending_str
}
