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

# Get an RFC
RFC_get()
{
	[ $# -lt 1 ] && return 1
	RFC=/tmp/rfc.txt
	isNum='^[0-9]+$'

	if [[ ${1} =~ $isNum ]]
	then
		curl "https://www.ietf.org/rfc/rfc${1}.txt" 2>/dev/null > $RFC
	else
		curl "https://www.rfc-editor.org/search/rfc_search_detail.php?title=${1}&pubstatus%5B%5D=Any&pub_date_type=any" 2>/dev/null | sed 's/href="/\n/g; s/.html/.html\n/g' | grep 'http.*.html' | sed 's/.html*//g' | rev | sed 's/cfr.*//' | rev > $RFC
	fi

	# Remove HEADER, and Footer sections
	sed -i '/RFC/d; /\[Page/d' $RFC

	cat $RFC | grep -q '<!DOCTYPE html>' && return 1 || cat -s $RFC
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

symbol() {
	SYMBOL="${@}"
	SYMBOL_FILE=/tmp/symbol_file.html
	curl 'https://en.wikipedia.org/wiki/List_of_Unicode_characters' 2>/dev/null > ${SYMBOL_FILE}
	cat ${SYMBOL_FILE} | sed 's#</td>##g' | sed -r '/^\s*$/d; s#<td align="center">#<td>#g' | grep -e '<td>' | grep -B 10 -i "$SYMBOL" | sed '/^.\{6\}./d' | sed 's#<td>##g; s#--##g' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'
	cat ${SYMBOL_FILE} | grep 'class="mw-redirect" title="' | grep -i "${SYMBOL}" | tr '"' '\n' | sed '/^.\{1\}./d' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'

	curl 'https://en.wikipedia.org/wiki/Dingbat' 2>/dev/null > ${SYMBOL_FILE}
	cat ${SYMBOL_FILE} | sed 's#</td>##g' | sed -r '/^\s*$/d; s#<td align="center">#<td>#g' | grep -e '<td>' | grep -B 10 -i "$SYMBOL" | sed '/^.\{6\}./d' | sed 's#<td>##g; s#--##g' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'
	cat ${SYMBOL_FILE} | grep 'class="mw-redirect" title="' | grep -i "${SYMBOL}" | tr '"' '\n' | sed '/^.\{1\}./d' | sed -r 's/[0-9]{1,10}$//' | sed -r '/^\s*$/d'
}

alias erez="printf '
	erez		-	This help menu
	cheat		-	room of requirement for the command line
	share		-	quick share some raw text
	symbol		- 	Search for a unicode symbol
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
