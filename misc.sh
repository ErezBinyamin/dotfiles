#!/bin/bash
#################################################
#						#
#		----ALIASES----			#
#						#
#################################################
# Simple
alias local_ip='hostname -I | sed "s/ .*//"'
alias hgrep='history | grep -e'
alias bashrc='source ~/.bashrc'
alias PS1="source ${INIT_DIR}/prompt/PS1.sh"
alias ps1="source ${INIT_DIR}/prompt/PS1.sh"
alias rez_update='pushd .; cd $INIT_DIR; git pull; popd'

# Aggressive clear
alias CLEAR='printf "\ec"'

# Renames
alias hi='history'
alias jo='jobs'
alias less='less -R'
alias nmap='nmap -T5 --min-parallelism=50 -n --min-rate=300'

#Fix mistakes / defence against trains
alias sl='ls'
alias sL='ls'
alias Sl='ls'
alias SL='ls'
alias lS='ls'
alias Ls='ls'
alias LS='[ which tree &> /dev/null ] && tree || ls_tree' # Big ls is a tree
#################################################
#						#
#	       ----FUNCTIONS----	        #
#						#
#################################################
# Make a tree with ls
ls_tree(){
	LS_ARGS=${@:-.}
	ls -R ${LS_ARGS} | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}

# Swap two files
swap()
{
    local TMPFILE=tmp.$$
    [[ $# -ne 2 || ! -f $1 || ! -f $2 ]] && return 1
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE "$2"
}

# Check network connectivity the fastest way this system supports
net_check() {
	TEST='www.google.com'
	which ip   &>/dev/null && return $(ip addr | grep inet | grep -q global && echo 0 || echo 1)
	which ping &>/dev/null && return $(ping -q -w 1 -c 1 ${TEST} &> /dev/null && echo 0 || echo 1)
	which wget &>/dev/null && return $(wget -q --spider ${TEST} && echo 0 || echo 1) 
	which nc   &>/dev/null && return $(nc -w 3 -z ${TEST} 80 && echo 0 || echo 1)
	echo "ERROR: Cannot detect network connection status!"
	return 1
}

public_ip() {
	which curl &>/dev/null && curl ipinfo.io/ip && return 0
	which wget &>/dev/null && wget -q -O - ipinfo.io/ip && return 0
	MAINIF=$( route -n | grep '^0\.0\.0\.0' | head -n 1 | awk '{print $NF}' )
	IP=$( ifconfig $MAINIF | { IFS=' :';read r;read r r a r;echo $a; } )
	echo $IP
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
	rez_docker	-	list of docker aliases/tools
	rez_git		-	list of git aliases/tools
	rez_update	-	update this project
	share		-	quick share a file
	share_get	-	quick recieve shared file
	swap		-	swap two files
	swb		-	toggle PS1 prompt bar
	up		-	go up n directories
	weather		-	the weather

'
"
