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

# Renames
alias hi='history'
alias jo='jobs'

#Fix mistakes / defence against trains
alias lS='ls'
alias Ls='ls'
alias LS='ls'
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

alias erez="printf '
	erez		-	This help menu
	cheat		-	room of requirement for the command line
	share		-	quick share some raw text
	define		-	define a word
	dockerTool	-	dockerTool -h for info
	weather		-	the weather
	up		-	go up n directories
	hgrep		-	history | grep <ARG>
	public_ip	-	ya
	local_ip	-	ya
'
"
