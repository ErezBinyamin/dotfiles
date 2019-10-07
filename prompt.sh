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

# Battery life and charging status
__bat_life='`[[ $(cat /sys/class/power_supply/BAT1/status) != "Discharging" ]] && printf "🔌";\
[ $(cat /sys/class/power_supply/BAT1/capacity) -ge 75 -a $(cat /sys/class/power_supply/BAT1/capacity) -lt 101 ] && printf "\[\033[38;5;10m\]🔋$(cat /sys/class/power_supply/BAT1/capacity)%%";\
[ $(cat /sys/class/power_supply/BAT1/capacity) -ge 50 -a $(cat /sys/class/power_supply/BAT1/capacity) -lt 75 ] && printf "\[\033[38;5;11m\]🔋$(cat /sys/class/power_supply/BAT1/capacity)%%";\
[ $(cat /sys/class/power_supply/BAT1/capacity) -ge 25 -a $(cat /sys/class/power_supply/BAT1/capacity) -lt 50 ] && printf "\[\033[38;5;202m\]🔋$(cat /sys/class/power_supply/BAT1/capacity)%%";\
[ $(cat /sys/class/power_supply/BAT1/capacity) -ge 10 -a $(cat /sys/class/power_supply/BAT1/capacity) -lt 25 ] && printf "\[\033[38;5;9m\]🔋$(cat /sys/class/power_supply/BAT1/capacity)%";\
[ $(cat /sys/class/power_supply/BAT1/capacity) -lt 10 ] && printf "\[\033[38;5;9m\]\[\033[5m\]🔋$(cat /sys/class/power_supply/BAT1/capacity)%%";\
printf "\[\033[0m\]"
`'

#Date and time
#for a in {a..z}; do printf "${a}\t"; date "+%${a}"; done
#for a in {A..Z}; do printf "${a}\t"; date "+%${a}"; done
__date_time='[`date "+%m/%d/%y %l:%m:%S"`]'

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

# Always leave room for at least 25 chars of command
# 37 is length of the other stuff
# TERM_WIDTH - 37 - (length of pwd)
__wrk_dir='`[ $(( $(tput cols) - 37 - $(pwd | wc -c) )) -lt 20 ] && printf \W || printf \w`'

# Git command line prompt

# GIT PULL
#       Determine if a git pull command is needed
#	Only execute this check if on a fast network
if [ $SLOW_NETWORK -eq 0 ]
then
    __git_pull='`[ $GIT_PROMPT -eq 1 ] && \
    [[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]] && \
    [ $(git pull --dry-run 2>&1 | wc -l) -gt 1 ] && \
    printf "\[\033[00m\]\[\033[1;5;96m\] ↓\[\033[00m\]"`'
else
    __git_pull='``'
fi

# GIT PUSH

#       Determine if a git push command is needed
__git_push='`[ $GIT_PROMPT -eq 1 ] && \
[[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]] && \
git status | grep -q "git push" && \
printf "\[\033[00m\]\[\033[1;5;96m\]🔼\[\033[00m\]"`'

# GIT REPO:
#       Shows name of current git repo in random color
#       Shows oposite color on arrows (Incase of unreadable color)
__git_repo='`[ $GIT_PROMPT -eq 1 ] && \
[[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]] && \
printf "\[\033[00m\] " && \
printf "\[\033[1;38;5;"\
"$(( 255 - $(git rev-parse --show-toplevel | xargs basename | md5sum | tr -d -c 0-9 | cut -c 1-18 | sed "s/^0*//") % 255 ))"\
"m\]|" && \
printf "\[\033[00m\]\[\033[1;4;38;5;"\
"$(( $(git rev-parse --show-toplevel | xargs basename | md5sum | tr -d -c 0-9 | cut -c 1-18 | sed "s/^0*//") % 255 ))"\
"m\]$(git rev-parse --show-toplevel | xargs basename)" && \
printf "\[\033[00m\]\[\033[1;38;5;"\
"$(( 255 - $(git rev-parse --show-toplevel | xargs basename | md5sum | tr -d -c 0-9 | cut -c 1-18 | sed "s/^0*//") % 255 ))"\
"m\]|" && \
printf "\[\033[00m\]"`'

# GIT COLOR:
#       Generates color based upon local change status
#       Green : Up to date
#       Yellow: Ready to commit
#       Red   : Unstaged changes
__git_color='`[ $GIT_PROMPT -eq 1 ] && \
[[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]] && \
printf " \[\033[1;38;5;2m\]" && \
printf "$(git diff-index --quiet --cached HEAD -- &> /dev/null || printf "\[\033[1;38;5;3m\]")" && \
printf "$(git diff --quiet &> /dev/null || printf "\[\033[1;38;5;1m\]*")" && \
printf "$( [ -z "$(git ls-files --exclude-standard --others)" ] || printf "\[\033[1;38;5;1m\]+")"`'

# GIT BRANCH:
#       Prints current git branch

__git_branch='`[ $GIT_PROMPT -eq 1 ] && \
[[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]] && \
git branch 2> /dev/null | grep -e ^* | sed "s:* ::"`'

# Define ending symbol
#	ssh  = %
#	root = #
#	else = $
__ending='`[ ! -x ${SSH_CLIENT+x} ] && printf "🔒🐚 " || printf "🐚 "`'

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
    PS1+="${RST}${__ending}"                    # A '$' and a space
fi
