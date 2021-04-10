#!/bin/bash
#################################################
#						#
#		----ALIASES----			#
#						#
#################################################
# Simple
alias public_ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias local_ip='hostname -I | sed "s/ .*//"'
alias hgrep='history | grep -e'
alias bashrc='source ~/.bashrc'
alias PS1="source ${INIT_DIR}/prompt/PS1.sh"
alias ps1="source ${INIT_DIR}/prompt/PS1.sh"

# Aggressive clear
alias CLEAR='printf "\ec"'

# Renames
alias hi='history'
alias jo='jobs'
alias less='less -R'

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

# Check network connectivity
net_check() {
	nc -w 3 -z 8.8.8.8 53 && return 0 || return 1
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
	rez_git		-	list of git aliases/tools
	share		-	quick share a file
	share_get	-	quick recieve shared file
	swb		-	toggle PS1 prompt bar
	up		-	go up n directories
	weather		-	the weather

'
"
