#!/bin/bash
# Weather report
alias weather='curl wttr.in'
alias moon='curl wttr.in/Moon'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias map='printf "\n\nA:\tZoom In +\nZ:\tZoom Out -\nArrows:\tMove\nQ:\tQuit\n\nPress any key to continue...\n"; read -s -n 1; telnet mapscii.me'

# Help from cheat.sh git repo:
cheat() {
	if net_check
	then
		/usr/bin/curl 'cheat.sh/'"$(echo $@ | tr ' ' '+')"
	else
		echo "ERROR: No network connectivity"
	fi
}

# Create a temporary webpage for file sharing
share() {
	if [ $# -eq 1 ] && [ -f ${1} ]
	then
		FILE="${1}"
	else
		echo "USAGE: share <file>"
	fi

	if net_check
	then
		cat ${FILE} | /usr/bin/curl -F 'clbin=<-' https://clbin.com
	else
		echo "ERROR: No network connectivity"
	fi
}

# Command line dictionary
define() {
	if net_check
	then
		/usr/bin/curl -s https://www.vocabulary.com/dictionary/$1 | \
		grep 'og:description' | sed 's/&#[0-9][0-9][0-9]//g' | awk -F "\"" '{print $4}'
	else
		echo "ERROR: No network connectivity"
	fi
}

