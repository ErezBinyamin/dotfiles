#!/bin/bash

# IP address definition, either live or on source define
if [ $PROMPT_SLOW_NETWORK -eq 0 ]
then
	export __prompt_ip_addr='`
	if [ ${PROMPT_IP_ADDR} -eq 1 ] && printf ":"
	then
		if net_check
		then
			if which hostname &>/dev/null
			then
				hostname -I | cut -d" " -f1
			elif which ip &>/dev/null
			then
				ip addr | grep inet | grep global | head -n1 | tr " " "\t" | tr "//" "\t"| cut -f6
			fi
		else
			echo "OFFLINE"
		fi
	fi
	`'
else
       __prompt_ip_addr='`
       [ ${PROMPT_IP_ADDR} -eq 1 ] && printf ":" && REPLACE
       `'
	__prompt_ip_addr_local_ip="`
		if [ ${PROMPT_IP_ADDR} -eq 1 ]
		then
			if net_check
			then
				if which hostname &>/dev/null
				then
					hostname -I | cut -d" " -f1
				elif which ip &>/dev/null
				then
					ip addr | grep inet | grep global | head -n1 | tr " " "\t" | tr "//" "\t"| cut -f6
				fi
			else
				echo "OFFLINE"
			fi
		fi
	`"
	export __prompt_ip_addr=$(echo $__prompt_ip_addr | sed "s/REPLACE/printf \"${__prompt_ip_addr_local_ip}\"/")
fi

