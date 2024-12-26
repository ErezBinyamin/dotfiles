#!/bin/bash
#################################################
#						#
#		----ALIASES----			#
#						#
#################################################
# Simple
alias hgrep='history | grep -e'
alias bashrc='source ~/.bashrc'
alias PS1="source ${DOTFILES}/prompt/PS1.sh"
alias ps1="source ${DOTFILES}/prompt/PS1.sh"
alias rez_update='pushd .; cd $DOTFILES; git pull; cd ${HOME}; source .bashrc; popd'

# Aggressive clear
alias CLEAR='command -v tput &>/dev/null && tput reset; printf "\ec"'

# Renames
alias less='less -R'
alias nmap='nmap -T5 --min-parallelism=50 -n --min-rate=300'
lsport() {
	if [ $# -ge 1 ]
	then
		set -x
		sudo lsof -i -P
		sudo netstat -tulnp
		set +x
	else
		set -x
		lsof -i -P
		netstat -tulnp
		set +x
	fi
}
 
# Readelf with better formatting (because readelf normally sucks)
readelf() {
	/usr/bin/readelf $@ | sed '/\[..\]/{N;s/\n//}; /[A-Z][A-Z][A-Z].*[[:space:]]0x/{N;s/\n//}; /Type           Offset/{N;s/\n//}'
}

#Fix mistakes / defence against trains
alias sl='ls'
alias sL='ls'
alias Sl='ls'
alias SL='ls'
alias lS='ls'
alias Ls='ls'
alias LS='[ command -v tree &> /dev/null ] && tree || ls_tree' # Big ls is a tree
#################################################
#						#
#	       ----FUNCTIONS----	        #
#						#
#################################################
# Check that all specified dependncies are installed, error if not
dependency_check() {
	for dep in "$@"
	do
	        if ! command -v ${dep} &>/dev/null
	        then
	                >&2 echo "DependencyError missing package: ${dep}"
	                return 1
	        fi
	done
	return 0
}

# Make a tree with ls
ls_tree() {
	LS_ARGS=${@:-.}
	ls -R ${LS_ARGS} | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}

# Swap two files
swap() {
    local TMPFILE=tmp.$$
    [[ $# -ne 2 || ! -f $1 || ! -f $2 ]] && return 1
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE "$2"
}

# Check network connectivity the fastest way this system supports
net_check() {
	TEST='www.google.com'
	command -v ip   &>/dev/null && return $(ip addr | grep inet | grep global | grep -q noprefixroute && echo 0 || echo 1)
	command -v ping &>/dev/null && return $(ping -q -w 1 -c 1 ${TEST} &> /dev/null && echo 0 || echo 1)
	command -v wget &>/dev/null && return $(wget -q --spider ${TEST} && echo 0 || echo 1)
	command -v nc   &>/dev/null && return $(nc -w 3 -z ${TEST} 80 && echo 0 || echo 1)
	>&2 echo "NetworkError: Cannot detect network connection status"
	return 1
}

public_ip() {
	command -v curl &>/dev/null && curl --silent ipinfo.io/ip && return $?
	command -v wget &>/dev/null && wget -q -O - ipinfo.io/ip && return $?
	MAINIF=$( route -n | grep '^0\.0\.0\.0' | head -n 1 | awk '{print $NF}' )
	IP=$( ifconfig $MAINIF | { IFS=' :';read r;read r r a r;echo $a; } )
	printf "$IP"
}

local_ip() {
	ip -family inet address | grep 'noprefixroute' | grep -Po '(?<=inet[ ])([0-9]{1,3}[.]){3}[0-9]{1,3}'
}

# Print next available port
next_port() {
	local PORT=${1}
	local USED_PORTS=$(echo $(netstat -awlpunt 2>/dev/null | grep -Eo ':[0-9]+ ' | tr -d ':' | sort -un))
	local NEXT_PORT=${PORT:-1024}
	while [[ "${USED_PORTS}" =~ "${NEXT_PORT}" ]]
	do
		let NEXT_PORT++
	done
	echo ${NEXT_PORT}
}

# Switch bash
swb() {
	[ ! -f ~/.bashrc.bak ] && cp ~/.bashrc ~/.bashrc.bak
	cp ~/.bashrc /tmp/bashrc.bak
	cp ~/.bashrc.bak ~/.bashrc
	cp /tmp/bashrc.bak ~/.bashrc.bak
	bashrc
}

# Travel up some number of directories
up() {
	local HEIGHT=''
	for i in `seq 1 $1`
	do
		HEIGHT+="../"
	done
	[[ ! ${HEIGHT} == '' ]] && cd ${HEIGHT} || echo 'up: usage: up [n]'
}

# Get bash dependencies in a specified bash script file
shdeps () (
	[ $# -lt 1 ] && return 0
	PRESENT_DEPS=()
	MISSING_DEPS=()

	# Pass a single file to this function
	fdeps() {
		local NET_CHECK=false
		net_check && NET_CHECK=true

		if ! echo ${1} | grep -q '\.sh'
		then
			if ! head ${1} | grep -q '#.*/*.sh'
			then
				echo "ERROR: ${1} does not seem to be a bash script"
				return 1
			fi
		fi
		for DEP in `sed '/^[ \t]*#/d; s/|/\n/g; s/#/\n#/g; s/\$(/\n/g' ${1} | sed 's/^[ \t]*//; /^#/d' | awk '{print $1}' | sort -u`
		do
			[[ ${#DEP} -gt 20 || ${#DEP} -lt 2 || "${DEP}" =~ '-' || "${DEP}" == "no" ]] && continue
			compgen -b | grep -q "\<${DEP}\>" 2>/dev/null && continue
			echo ${DEP} | grep -q \
				-e '(' \
				-e ')' \
				-e '<' \
				-e '>' \
				-e ':' \
				-e ';' \
				-e '"' \
				-e "'" \
				-e '`' \
				-e '\.' \
				-e '\\' \
				-e '\$' \
				-e '\-' \
				-e '\^' \
				-e '=' \
				-e '@' \
				-e '#' \
				-e '+' \
				-e '%' \
				-e '/' \
				-e '!' \
				-e '?' \
				-e '&' \
				-e '*' && continue
			
			if command -v ${DEP} &>/dev/null
			then
				PRESENT_DEPS+=( ${DEP} )
			elif grep -q "${DEP}()" "${1}"
			then
				continue
			else
				MISSING_DEPS+=( ${DEP} )
			fi
		done
	}

	for arg in $@
	do
		[ ${#arg} -lt 1 ] && continue
		if [ -d $arg ]
		then
			for d in `${arg}/*`
			do
				# @ RECURSE
				shdeps ${d}
			done
		elif [ -f $arg ]
		then
			fdeps ${arg} || return 1
		else
			echo "InvalidArgumentError: ${arg}"
			return 1
		fi
	done

	# Complete
	printf "\nPresent: "
	echo ${PRESENT_DEPS[@]} | tr ' ' '\n' | sort -u | tr '\n' ' '
	printf "\n\nMissing: \n  > "
	echo ${MISSING_DEPS[@]} | tr ' ' '\n' | sort -u | tr '\n' '#' | sed 's/#/\n  > /g' | head -n -1
	printf '\n'
)

txsms() {
	local PHONE="$1"
	shift
	local MESSAGE="$@"
	if [ $(echo "${MESSAGE}" | wc -c) -lt 2 ]
	then
		>&2 echo 'USAGE: text <phone-number> "<message>"'
		return 1
	fi
	curl --silent --request POST https://textbelt.com/text \
	       --data-urlencode phone="$PHONE" \
	       --data-urlencode message="$MESSAGE" \
	       -d key=textbelt
}

clip() {
	if [ $# -lt 1 ]
	then
		>&2 echo 'USAGE: clip text to copy to clipboard ...'
		return 1
	fi
	echo $@ | xclip -sel clip
}

getTZ() {
	# Source https://superuser.com/questions/309034/how-to-check-which-timezone-in-linux/1334239#1334239
	#set -euo pipefail
	
	if filename=$(readlink /etc/localtime); then
	    # /etc/localtime is a symlink as expected
	    timezone=${filename#*zoneinfo/}
	    if [[ $timezone = "$filename" || ! $timezone =~ ^[^/]+/[^/]+$ ]]; then
	        # not pointing to expected location or not Region/City
	        >&2 echo "$filename points to an unexpected location"
	        exit 1
	    fi
	    echo "$timezone"
	else  # compare files by contents
	    # https://stackoverflow.com/questions/12521114/getting-the-canonical-time-zone-name-in-shell-script#comment88637393_12523283
	    find /usr/share/zoneinfo -type f ! -regex ".*/Etc/.*" -exec \
	        cmp -s {} /etc/localtime \; -print | sed -e 's@.*/zoneinfo/@@' | head -n1
	fi
}

alias erez="printf '
	bashrc		-	reload bashrc
	CLEAR		-	big boy clear
	cheat		-	room of requirement for the command line
	define		-	define a word
	erez		-	This help menu
	hgrep		-	history | grep <ARG>
	LS		-	big boy ls = tree
	ls_tree		-	ls implementation of tree
	local_ip	-	ya
	map		-	interactive ascii map
	PS1		-	interactive PS1 prompt editor
	public_ip	-	ya
	rez_git		-	list of git aliases/tools
	rez_update	-	update this project
	share		-	quick share a file
	share_get	-	quick recieve shared file
	shdeps		-	list dependencys of a bash script
	swap		-	swap two files
	swb		-	toggle PS1 prompt bar
	up		-	go up n directories
	weather		-	the weather
'
"
