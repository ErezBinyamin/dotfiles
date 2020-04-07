#!/bin/bash
#################################################
#						#
#		        ----ALIASES----         #
#						#
#################################################
# Simple
alias public_ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias local_ip='hostname -I | sed "s/ .*//"'
alias hgrep='history | grep -e'
alias bashrc='cd;source .bashrc; cd -'
alias irc='weechat'
alias prompt="source ${HOME}/Bash_init/prompt/editor.sh"

# Aggressive clear
alias CLEAR='printf "\ec"'

# Renames
alias hi='history'
alias jo='jobs'
alias less='less -R'
alias nano='nano --smooth --softwrap'

#Fix mistakes / defence against trains
alias LS='tree' # Big ls is a tree
alias lS='ls'
alias Ls='ls'
alias sl='ls'
alias sL='ls'
alias Sl='ls'
alias SL='ls'
#################################################
#						#
#		       ----FUNCTIONS----        #
#						#
#################################################
# Check network connectivity
net_check() {
	nc -w 3 -z 8.8.8.8 53 && return 0 || return 1
}

# Switch bash
swb() {
	cd

	[ ! -f .bashrc.bak ] && cp .bashrc .bashrc.bak

	cp .bashrc /tmp/bashrc.bak
	cp .bashrc.bak .bashrc
	cp /tmp/bashrc.bak .bashrc.bak

	cd -
	bashrc
}

# Vulnerability browser
vbrowse() {
	if net_check
	then
		/usr/bin/curl -# 'cve.circl.lu/api/browse/'"$(echo $@ | tr ' ' '/')"
	else
		echo "ERROR: No network connectivity"
		return 1
	fi
	return 0
}

# Travel up some number of directories
up() {
	local HEIGHT=''

	for i in `seq 1 $1`
	do
		HEIGHT+="../"
	done

	[[ ! ${HEIGHT} == '' ]] && cd ${HEIGHT}
}

ls_tree(){
	ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}

inv_img() {
	if [ -z ${1+x} ]
	then
		echo "USAGE: inv_img <input.png>"
		echo "OR"
		echo "USAGE: inv_img <input.png> <output.png>"
		return 1
	fi

	INPUT="$1"
	[ -z ${2+x} ] && OUTPUT=inverted.png || OUTPUT="$2"

	convert ${INPUT} -channel RGB -negate "${OUTPUT}"
}

alias erez="printf '
	bashrc		-	reload bashrc
	CLEAR		-	big boy clear
	cheat		-	room of requirement for the command line
	define		-	define a word
	dockerTool	-	dockerTool -h for info
	erez		-	This help menu
	hgrep		-	history | grep <ARG>
	inv_img		-	invert an image
	LS		-	big boy ls = tree
	ls_tree		-	ls implementation of tree
	local_ip	-	ya
	map		-	interactive ascii map
	prompt		-	interactive PS1 prompt editor
	public_ip	-	ya
	rez_git		-	list of git aliases/tools
	share		-	quick share a file
	share_get	-	quick recieve shared file
	swb		-	toggle PS1 prompt bar
	up		-	go up n directories
	weather		-	the weather

'
"
