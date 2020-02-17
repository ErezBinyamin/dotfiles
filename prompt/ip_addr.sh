#!/bin/bash

# IP address definition, either live or on source define
if [ $PROMPT_SLOW_NETWORK -eq 0 ]
then
	export __prompt_ip_addr='`
	if [ ${PROMPT_IP_ADDR} -eq 1 ]
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
	__prompt_ip_addr='`
	[ ${PROMPT_IP_ADDR} -eq 1 ] && printf
	`'
	__prompt_ip_addr_local_ip="`
		if whereis nc &>/dev/null && hostname -I &>/dev/null
		then
			nc -w 3 -z 8.8.8.8 53 && hostname -I | cut -d' ' -f1 || echo OFFLINE
		else
			ip addr | grep inet | grep global | head -n1 | tr ' ' '\t' | tr '//' '\t'| cut -f6 || echo OFFLINE
		fi
	`"
	export __prompt_ip_addr=$(echo $__prompt_ip_addr | sed "s/printf/printf \"${__prompt_ip_addr_local_ip}\"/")
fi

