#!/bin/bash

__prompt_ipaddr_func() {
    local ERRVAL
		if [ ${PROMPT_IPADDR} -eq 1 ]
		then
			if net_check
			then
				if hostname -I &>/dev/null
				then
					hostname -I | cut -d" " -f1
				elif ip addr &>/dev/null
				then
					ip addr | grep inet | grep global | head -n1 | tr " " "\t" | tr "//" "\t"| cut -f6
				elif ifconfig &>/dev/null
				then
					ifconfig | grep 'inet ' | grep -ve 'inet.*\.1 .*n' -e 'inet.*\.255 .*n' | grep -o 'inet.*n' | cut -d' ' -f2
				fi
        ERRVAL=0
			else
				echo "OFFLINE"
        ERRVAL=1
			fi
		fi
    return $ERRVAL
}

# IP address definition, either live or on source define
if [ $PROMPT_SLOW_NETWORK -eq 0 ]
then
	export __prompt_ipaddr='`__prompt_ipaddr_func`'
else
  __prompt_ipaddr='`[ ${PROMPT_IPADDR} -eq 1 ] && printf ":" && REPLACE`'
	__prompt_ipaddr_local_ip="`__prompt_ipaddr_func`"
	export __prompt_ipaddr=$(echo $__prompt_ipaddr | sed "s/REPLACE/printf \"${__prompt_ipaddr_local_ip}\"/")
fi
