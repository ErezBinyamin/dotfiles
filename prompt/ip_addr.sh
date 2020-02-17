#!/bin/bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# IP address definition, either live or on source define
if [ $SLOW_NETWORK -eq 0 ]
then
__prompt_ip_addr='`
if [ ${PROMPT_IP_COLORING} -eq 1 ]
then
	if whereis nc &>/dev/null && hostname -I &>/dev/null
	then
		nc -w 3 -z 8.8.8.8 53 && hostname -I | cut -d" " -f1 || echo OFFLINE
	else
		ip addr | grep inet | grep global | head -n1 | tr " " "\t" | tr "//" "\t"| cut -f6 || echo OFFLINE
	fi
fi
`'
else
__prompt_ip_addr="`
if [ ${PROMPT_IP_COLORING} -eq 1 ]
then
	if whereis nc &>/dev/null && hostname -I &>/dev/null
	then
		nc -w 3 -z 8.8.8.8 53 && hostname -I | cut -d' ' -f1 || echo OFFLINE
	else
		ip addr | grep inet | grep global | head -n1 | tr ' ' '\t' | tr '//' '\t'| cut -f6 || echo OFFLINE
	fi
fi
`"
fi

