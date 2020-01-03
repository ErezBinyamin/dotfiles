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

# Aggressive clear
alias CLEAR='printf "\ec"'

# Renames
alias hi='history'
alias jo='jobs'
alias nano='nano --smooth --softwrap'
#alias nano='nano --smooth --positionlog --linenumbers --softwrap'

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

# Get an RFC
RFC_get() {
	[ $# -lt 1 ]         && return 1
	isNum='^[0-9]+$'
	[[ ${1} =~ $isNum ]] || return 1

	curl "https://www.ietf.org/rfc/rfc${1}.txt"
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

# mktouch
mktouch() {
	mkdir -p $(dirname $1) && $(echo 'touch') $1
}

ls_tree(){
	ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}

# Change bash instance title
title() {
	echo -ne "\033]0;$@\007"
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
	erez		-	This help menu
	cheat		-	room of requirement for the command line
	share		-	quick share some raw text
	define		-	define a word
	dockerTool	-	dockerTool -h for info
	up		-	go up n directories
	hgrep		-	history | grep <ARG>
	public_ip	-	ya
	local_ip	-	ya
	inv_img		-	invert an image
	weather		-	the weather
	map		-	interactive ascii map
	bashrc		-	reload bashrc
	CLEAR		-	big boy clear
	LS		-	big boy ls

'
"
