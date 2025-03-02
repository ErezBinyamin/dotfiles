#!/bin/bash
# Weather report
alias weather='curl wttr.in'
alias moon='curl wttr.in/Moon'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
alias map='printf "\n\nA:\tZoom In +\nZ:\tZoom Out -\nArrows:\tMove\nQ:\tQuit\n\nPress any key to continue...\n"; read -s -n 1; telnet mapscii.me'
alias curly='curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" --compressed --retry 5 --retry-delay 3 --connect-timeout 10 --max-time 30 --fail --insecure -b cookies.txt -c cookies.txt -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Accept-Language: en-US,en;q=0.9" -H "Cache-Control: max-age=0" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1"'

# Help from cheat.sh git repo:
cheat() {
	local URL="cht.sh"
	if net_check
	then
		curl --silent "${URL}/$(echo $@ | tr ' ' '+')"
	else
		>&2 echo "ERROR: No network connectivity"
		return 1
	fi
	return 0
}

# Create a temporary webpage for file sharing
share() {
	if [ ! $# -ge 1 ] || [ ! -f ${1} ]
	then
		>&2 echo "USAGE: share <files>"
		return 1
	fi

	if net_check
	then
		for FILE in $@
		do
			if [ ! -f $FILE ]
			then
				>&2 echo "FileNotFound: $FILE"
				return 1
			fi
			printf "\n$FILE:\t"
			cat ${FILE} | curl --silent --form 'clbin=<-' https://clbin.com
		done
	else
		>&2 echo "ERROR: No network connectivity"
		return 1
	fi
	return 0
}

# Retrieve from a shared URL
share_get() {
	if [ $# -eq 1 ] && [ ${#1} -gt 4 ]
	then
		END="${1}"
	else
		>&2 echo "USAGE: share_get <clbin ending>"
		return 1
	fi

	if net_check
	then
		curl --silent "https://clbin.com/${END}"
	else
		>&2 echo "ERROR: No network connectivity"
		return 1
	fi
	return 0
}

