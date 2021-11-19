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
			cat ${FILE} | /usr/bin/curl -F 'clbin=<-' https://clbin.com
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
		/usr/bin/curl "https://clbin.com/${END}"
	else
		>&2 echo "ERROR: No network connectivity"
		return 1
	fi
	return 0
}

# Command line dictionary
define() {
	if net_check
	then
		/usr/bin/curl -s https://www.vocabulary.com/dictionary/$(echo $@ | tr ' ' '-') | \
		grep 'og:description' | sed 's/&#[0-9][0-9][0-9]//g' | awk -F "\"" '{print $4}'
	else
		>&2 echo "ERROR: No network connectivity"
		return 1
	fi
	return 0
}

# Command line wikepedia
wiki() {
    if ! net_check
    then
	    >&2 echo "ERROR: No network connectivity"
            return 1
    fi
    QUERY=$(echo $@ | tr ' ' '+' | tr -d "'" | tr -d '"')

    GOOG="https://www.google.com/search?q=wikepedia+${QUERY}"
    QUERY=$(curl --silent --user-agent 'Mozilla/5.0 (MSIE; Windows 10)' ${GOOG} \
            | grep -Po 'https://en.wikipedia[.]org.*?"' \
            | head -n1 \
            | tr -d '"' \
            | sed 's|https://||' \
            | xargs basename)

    WIKI="https://en.wikipedia.org/w/api.php?action=query&format=json&titles=${QUERY}&prop=extracts&exintro&explaintext"
    curl --silent --user-agent 'Mozilla/5.0 (MSIE; Windows 10)' ${WIKI}
    printf '\n\n'
}

