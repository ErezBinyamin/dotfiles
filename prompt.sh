#!/bin/bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# CONTROLS
#############################################################################################################################################
DEFAULT=0           # Ignore all prompt customizations and use ubuntu default
SLOW_NETWORK=1      # If you have a slow network, set to a '1' to stop all slow network items
GIT_PROMPT=1        # Git branch and coloring
IP_COLORING=1       # Use IP octets to color command line
RANDOM_COLORING=0   # Randomize prompt colors (override IP coloring)
#############################################################################################################################################

RST="\[\033[00m\]"

# Battery life colored and charging status
__bat_life='`
#BATTERY_CHARGING="🔌"
BATTERY_CHARGING="⚡"
BATTERY_SYMBOL="🔋"
if [ -d /sys/class/power_supply/ ] && ls /sys/class/power_supply/ | grep -q BAT && [ $(echo $(find /sys/class/power_supply/BAT*/ -name status -exec cat {} \;) | wc -c) -gt 3 ]
then
	[[ $(find /sys/class/power_supply/BAT*/ -name status -exec cat {} \;) != "Discharging" ]] && printf "${BATTERY_CHARGING}"
	BAT=$(find /sys/class/power_supply/BAT*/ -name capacity -exec cat {} \;)
	[ $BAT -ge 75 -a $BAT -lt 101 ] && printf "\[\033[38;5;10m\]"
	[ $BAT -ge 50 -a $BAT -lt 75 ] && printf "\[\033[38;5;11m\]"
	[ $BAT -ge 25 -a $BAT -lt 50 ] && printf "\[\033[38;5;202m\]"
	[ $BAT -ge 10 -a $BAT -lt 25 ] && printf "\[\033[38;5;9m\]"
	[ $BAT -lt 10 ] && printf "\[\033[38;5;9m\]\[\033[5m\]"
	printf "${BATTERY_SYMBOL}${BAT}%%"
fi
printf "\[\033[0m\]"
`'

#Date and time
__date_time='`
printf "[ $(date +%m/%d/%y) "
HR=$(date "+%l" | tr -d " ")
MN=$(date "+%M" | tr -d " ")
case "${HR}" in
  "1")
	[ $MN -lt 15 ] && printf "🕐" || printf "🕜";;
  "2")
	[ $MN -lt 15 ] && printf "🕑" || printf "🕝";;
  "3")
	[ $MN -lt 15 ] && printf "🕒" || printf "🕞";;
  "4")
	[ $MN -lt 15 ] && printf "🕓" || printf "🕟";;
  "5")
	[ $MN -lt 15 ] && printf "🕔" || printf "🕠";;
  "6")
	[ $MN -lt 15 ] && printf "🕕" || printf "🕡";;
  "7")
	[ $MN -lt 15 ] && printf "🕖" || printf "🕢";;
  "8")
	[ $MN -lt 15 ] && printf "🕗" || printf "🕣";;
  "9")
	[ $MN -lt 15 ] && printf "🕘" || printf "🕤";;
  "10")
	[ $MN -lt 15 ] && printf "🕙" || printf "🕥";;
  "11")
	[ $MN -lt 15 ] && printf "🕚" || printf "🕦";;
  "12")
	[ $MN -lt 15 ] && printf "🕛" || printf "🕧";;
  *)
	echo foo > /dev/null ;;
esac

HR_24=$(date "+%H")
if [ ${HR_24} -lt 6 ]
then
	printf "🌚"
elif [ ${HR_24} -lt 17 ]
then
	printf "🌞"
elif [ ${HR_24} -ge 17 ]
then
	printf "🌚"
fi

printf "$(date +%l:%M:%S) ]"
`'

# set variable identifying this machines ip address (used in the prompt below)
# Color the command line according to the IP, sed away the bad colors
# Helper function for generating IP-color string
# Replaces hard to see colors with highlighed backgrounds
_assign_color() {
    case "$1" in
     "")
        echo '\[\033[48;5;m\]'
        ;;
     "0" | "8" | "17" | "18" | "16" | "232" | "233" | "234" | "235" | "236" | "237")
        echo '\[\033[48;5;'"$1"'m\]'
        ;;
     *)
        echo '\[\033[38;5;'"$1"'m\]'
        ;;
    esac
}

# IP address definition, either live or on source define
[ $SLOW_NETWORK -eq 0 ] && __ip_addr='`nc -w 3 -z 8.8.8.8 53 && hostname -I | cut -d" " -f1 || echo OFFLINE`'
[ $SLOW_NETWORK -eq 1 ] && __ip_addr="$(nc -w 3 -z 8.8.8.8 53 && hostname -I | cut -d' ' -f1 || echo OFFLINE)"

if [ $IP_COLORING -eq 1 ]; then
    # IF OFFLINE then print gray else color
    if nc -w 3 -z 8.8.8.8 53
    then
        __COLOR_1=$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f1))
        __COLOR_2=$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f2))
        __COLOR_3=$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f3))
        __COLOR_4=$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f4))
    else
        __COLOR_1=$(_assign_color "0")
        __COLOR_2=$(_assign_color "0")
        __COLOR_3=$(_assign_color "0")
        __COLOR_4=$(_assign_color "0")
    fi

    # Poll google servers for each color
    if [ $SLOW_NETWORK -eq 0 ]
    then
         __COLOR_1='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f1)"m\]" || echo "\[\033[48;5;m\]"`'
         __COLOR_2='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f2)"m\]" || echo "\[\033[48;5;m\]"`'
         __COLOR_3='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f3)"m\]" || echo "\[\033[48;5;m\]"`'
         __COLOR_4='`nc -w 2 -z 8.8.8.8 53 && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f4)"m\]" || echo "\[\033[48;5;m\]"`'
    fi
fi

# Assign 4 random colors to the command line components
if [ $RANDOM_COLORING -eq 1 ]; then
    __COLOR_1=$(_assign_color $(( $RANDOM % 255 )))
    __COLOR_2=$(_assign_color $(( $RANDOM % 255 )))
    __COLOR_3=$(_assign_color $(( $RANDOM % 255 )))
    __COLOR_4=$(_assign_color $(( $RANDOM % 255 )))
fi

# TODO: actually calculate size of prompt instead of hardcoding
# Always leave room for at least 20 chars of command
# 55 is the stated length of the nonDir_part of the prompt
# TERM_WIDTH - 55 - (length of pwd)
__wrk_dir='`[ $(( $(tput cols) - 55 - $(pwd | wc -c) )) -lt 20 ] && printf \W || printf \w`'

# ---- Git command line prompt ----
# GIT PULL
#       Determine if a git pull command is needed
#	Only execute this check if on a fast network
if [ $SLOW_NETWORK -eq 0 ]
then
	__git_pull='`
	GIT_PULL_SYMBOL="📥"
	if [ $GIT_PROMPT -eq 1 ]
	then
		if [[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]] && [ $(git pull --dry-run 2>&1 | wc -l) -gt 1 ]
		then
			printf "\[\033[00m\]\[\033[1;5;96m\] ${GIT_PULL_SYMBOL}\[\033[00m\]"
		fi
	fi
	`'
else
    __git_pull='``'
fi

# GIT PUSH
#       Determine if a git push command is needed
__git_push='`
GIT_PUSH_SYMBOL="📤"
if [ $GIT_PROMPT -eq 1 ] && [[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]]
then
	git status | grep -q "git push" && printf "\[\033[00m\]\[\033[1;5;96m\]${GIT_PUSH_SYMBOL}\[\033[00m\]"
fi
`'

# GIT REPO:
#       Shows name of current git repo in random color
#       Shows oposite color on border (Incase of unreadable color)
__git_repo='`
REPO_BORDER_SYMBOL_LEFT="|"
REPO_BORDER_SYMBOL_RIGHT="|"
if [ $GIT_PROMPT -eq 1 ]
then
	if [[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]]
	then
		REPO_NAME="$(git rev-parse --show-toplevel | xargs basename)"
		REPO_COLOR="$(( $(echo ${REPO_NAME} | md5sum | tr -d -c 0-9 | cut -c 1-18 | sed "s/^0*//") % 255 ))"
		REPO_INV_COLOR="$(( 255 - ${REPO_COLOR} % 255 ))"

		printf "\[\033[00m\] "
		printf "\[\033[1;38;5;${REPO_INV_COLOR}m\]"
		printf "${REPO_BORDER_SYMBOL_LEFT}"
		printf "\[\033[00m\]\[\033[1;4;38;5;${REPO_COLOR}m\]"
		printf "${REPO_NAME}"
		printf "\[\033[00m\]\[\033[1;38;5;${REPO_INV_COLOR}m\]"
		printf "${REPO_BORDER_SYMBOL_RIGHT}"
		printf "\[\033[00m\]"
	fi
fi
`'


# GIT COLOR:
#       Generates color based upon local change status
#       Green : Up to date
#       Yellow: Ready to commit
#       Red   : Unstaged changes
__git_color='`
GIT_NEW_FILE_SYMBOL="🗒 "
GIT_EDIT_FILE_SYMBOL="📝"
if [ $GIT_PROMPT -eq 1 ]
then
	if [[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]]
	then
		printf " \[\033[1;38;5;2m\]"
		git diff-index --quiet --cached HEAD -- &> /dev/null || printf "\[\033[1;38;5;3m\]"
		git diff --quiet &> /dev/null || printf "\[\033[1;38;5;1m\]${GIT_EDIT_FILE_SYMBOL}"
		[ -z "$(git ls-files --exclude-standard --others)" ] || printf "\[\033[1;38;5;1m\]${GIT_NEW_FILE_SYMBOL}"
	fi
fi
`'

# GIT BRANCH:
#       Prints current git branch
__git_branch='`
if [ $GIT_PROMPT -eq 1 ] && [[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]]
then
	git branch 2> /dev/null | grep -e ^* | sed "s:* ::"
fi
`'

# CAPS LOCK notification symbol
__caps_lock='`
CAPS_LOCK_SYMBOL="🆑"
if xset -h &> /dev/null
then
	xset q | grep -q "00: Caps Lock:   off" || printf "${CAPS_LOCK_SYMBOL}"
fi
`'

# Define ending symbol
#	ssh  = 🔒🐚
#	root = #
#	else = 🐚
__ending='`
if [ ! -x ${SSH_CLIENT+x} ]
then
	printf "🔒🐚 "
else
	printf "🐚 "
fi
`'

#################################################
#			                        #
#	----ACTUALLY SET THE PS1----		#
#			                        #
#################################################
if [ $DEFAULT -eq 1 ]
then
    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    # set a fancy prompt (non-color, unless we know we "want" color)
    case "$TERM" in
        xterm-color) color_prompt=yes;;
    esac

    # uncomment for a colored prompt, if the terminal has the capability; turned
    # off by default to not distract the user: the focus in a terminal window
    # should be on the output of commands, not on the prompt
    force_color_prompt=yes

    if [ -n "$force_color_prompt" ]; then
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
        else
        color_prompt=
        fi
    fi

    if [ "$color_prompt" = yes ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
    unset color_prompt force_color_prompt

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
    esac
else
    unset PS1
    PS1+="${__bat_life}"			# Battery life
    PS1+="${__COLOR_1}${__date_time}${RST}"     # Date and time
    PS1+="${__COLOR_2}\u@${RST}"                # Username '@'
    PS1+="${__COLOR_3}${__ip_addr}:${RST}"      # IP address ':'
    PS1+="${__COLOR_4}${__wrk_dir}${RST}"	# Working directory
    PS1+="${__git_repo}${RST}"                  # Repo name
    PS1+="${__git_pull}${__git_push}${RST}"     # Push pull arrows
    PS1+="${__git_color}${__git_branch}${RST}"  # Colored git branch/status
    PS1+="${__caps_lock}"                       # Caps lock notification
    PS1+="${RST}${__ending}"                    # A '$' and a space
fi
