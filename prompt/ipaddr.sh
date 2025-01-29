#!/bin/bash

__prompt_ipaddr_func() {
    local ERRVAL
		if [ ${PROMPT_IPADDR:-0} -eq 1 ]
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

export PROMPT_LOCALIP=$(__prompt_ipaddr_func)
__prompt_ipaddr_func2() {
  [ ${PROMPT_IPADDR} -eq 1 ] && printf ":${PROMPT_LOCALIP}"
}

# IP address definition, either live or on source define
if [ ${PROMPT_SLOW_NETWORK:-0} -eq 0 ]
then
	export __prompt_ipaddr='`__prompt_ipaddr_func`'
else
	export __prompt_ipaddr='`__prompt_ipaddr_func2`'
fi
