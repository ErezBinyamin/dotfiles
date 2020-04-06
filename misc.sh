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

# Get an RFC
RFC_get()
{
	[ $# -lt 1 ] && return 1
	RFC=/tmp/rfc.txt
	MIN_RFC=1
	MAX_RFC=8650
	isNum='^[0-9]+$'
	NEVER_ISSUED=( "3333" "3350" "3399" "3699" "3799" "3800" "3899" "3900" "3907" "3908" "3999" "4000" "4099" "4100" "4199" "4200" "4232" "4299" "4300" "4399" "4400" "4499" "4500" "4599" "4600" "4658" "4699" "4700" "4751" "4799" "4800" "4899" "4900" "4921" "4922" "4989" "4999" "5099" "5100" "5108" "5199" "5200" "5299" "5300" "5312" "5313" "5314" "5315" "5319" "5399" "5400" "5499" "5500" "5599" "5600" "5699" "5700" "5799" "5800" "5809" "5821" "5822" "5823" "5899" "5900" "5999" "6000" "6099" "6100" "6102" "6103" "6199" "6200" "6299" "6300" "6399" "6400" "6499" "6500" "6523" "6524" "6599" "6600" "6634" "6699" "6700" "6799" "6800" "6899" "6900" "6966" "6995" "6999" "7000" "7099" "7327" "7907" "8523" "8524" "8535" "8566" "8626" "8644" "8646" "8647" "8648" )

	# Get corresponding RFC by number
	if [[ ${1} =~ $isNum ]]
	then
		# Validate RFC range
		if [ $1 -gt $MAX_RFC ] || [ $1 -lt $MIN_RFC ]
		then
			echo "Valid RFC numbers: [ ${MIN_RFC} - ${MAX_RFC} ]"
			return 1
		fi
		# Retrieve RFC <N>
		curl "https://www.ietf.org/rfc/rfc${1}.txt" --write-out %{http_code} --silent --output ${RFC} 2>/dev/null | grep -q '200'
		if [ $? -eq 0 ]
		then
			# Format nicely and print
			sed -i '/Page [0-9]/,+2d; /page [0-9]/,+2d' ${RFC}
			cat ${RFC} | grep -q '<!DOCTYPE html>' && return 1 || cat -s ${RFC}
			return 0
		fi
		# Attempt to retrieve PDF link to RFC <N>
		curl "https://www.rfc-editor.org/info/rfc${1}" --write-out %{http_code} --silent --output ${RFC} 2>/dev/null | grep -q '200'
		[ $? -eq 0 ] && grep -o 'https.*\.pdf' ${RFC} || echo "RFC ${1} not issued"
	# Print list of available RFCs
	elif [[ "${1,,}" == ":list" ]]
	then
		for i in `seq 1 $MAX_RFC`
		do
			echo "${NEVER_ISSUED[@]}" | tr ' ' '\n' | grep -qFx $i || echo $i
		done
	# Print list of RFCs related to keyword
	else
		ARG="${@}"
		curl "https://www.rfc-editor.org/search/rfc_search_detail.php?title=${ARG}" 2> /dev/null | sed 's/href="/\n/g; s/.html/.html\n/g' | grep -A 1 --color=auto 'http.*.html' | sed '/boldtext/d; s/"target/<"target/g; s/<[^>]*>//g; /HTML,/d; s/HTML//; /--/d' | grep -v -B 1 html | rev | sed 's/lmth\.//; s/cfr.*//; /--/d' | rev | sed 's/[A-Z]\..*//; /mail-archive/,+1d; s/^[ \t]*//' | sed  's/&nbsp.*//g; s/<a//g; N ; s/\n/:\t/' > $RFC
		# Format nicely and print
		sed -i '/Page [0-9]/,+2d; /page [0-9]/,+2d' ${RFC}
		cat ${RFC} | grep -q '<!DOCTYPE html>' && return 1 || cat -s ${RFC}
		return 0
	fi
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
	RFC_get		-	Read/Search for an RFC
	share		-	quick share a file
	share_get	-	quick recieve shared file
	swb		-	toggle PS1 prompt bar
	symbol		- 	Search for a unicode symbol
	up		-	go up n directories
	weather		-	the weather

'
"
