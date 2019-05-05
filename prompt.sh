# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# CONTROLS
#############################################################################################################################################
DEFAULT=0           # Ignore all prompt customizations and use default
PROMPT_GIT_PARSE=1  # Git branch and coloring
IP_COLORING=1       # Use IP octets to color command line
IP_COLORING_LIVE=0  # BROKEN: Live update IP coloring (not just at bashrc)
RANDOM_COLORING=0   # Randomize prompt colors (override IP coloring)
#############################################################################################################################################

RST="\[\033[00m\]"

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

# Live update IP address
__ip_addr='`nc -w 3 -z 8.8.8.8 53 && hostname -I | cut -d" " -f1 || echo OFFLINE`'

if [ $IP_COLORING -eq 1 ]; then
    __COLOR_1=$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f1))
    __COLOR_2=$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f2))
    __COLOR_3=$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f3))
    __COLOR_4=$(_assign_color $(hostname -I | tr '.' ' ' | cut -d' ' -f4))
    if [ $IP_COLORING_LIVE -eq 1 ]
    then
        # Check connectivity with envar
         __OFFLINE=0
         __AM_I_OFFLINE='`export __OFFLINE=$(nc -w 3 -z 8.8.8.8 53 && echo 1 || echo 0)`'
         __COLOR_1='`[ $__OFFLINE -eq 0 ] && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f1)"m\]" || echo "\[\033[48;5;m\]"`'
         __COLOR_2='`[ $__OFFLINE -eq 0 ] && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f2)"m\]" || echo "\[\033[48;5;m\]"`'
         __COLOR_3='`[ $__OFFLINE -eq 0 ] && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f3)"m\]" || echo "\[\033[48;5;m\]"`'
         __COLOR_4='`[ $__OFFLINE -eq 0 ] && echo "\[\033[38;5;"$(hostname -I | tr "." " " | cut -d" " -f4)"m\]" || echo "\[\033[48;5;m\]"`'
    fi
fi

if [ $RANDOM_COLORING -eq 1 ]; then
    __COLOR_1=$(_assign_color $(( $RANDOM % 255 )))
    __COLOR_2=$(_assign_color $(( $RANDOM % 255 )))
    __COLOR_3=$(_assign_color $(( $RANDOM % 255 )))
    __COLOR_4=$(_assign_color $(( $RANDOM % 255 )))
fi

# COLORS:
#       Green : Up to date
#       Yellow: Ready to commit
#       Red   : Unstaged changes
__git_color='`[ $PROMPT_GIT_PARSE -eq 1 ] && [[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]] && printf " " && printf "\[\033[1;48;5;2m\]" && printf "$(git diff-index --quiet --cached HEAD -- || printf "\[\033[1;48;5;3m\]")" && printf "$(git diff --quiet || printf "\[\033[1;48;5;1m\]*")" && printf "$( [ -z "$(git ls-files --exclude-standard --others)" ] || printf "\[\033[1;48;5;1m\]+")"`'
__git_branch='`[ $PROMPT_GIT_PARSE -eq 1 ] && [[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]] && git branch 2> /dev/null | grep -e ^* | sed "s:* ::"`'

#Date and time
__date_time='[`date "+%m/%d/%Y %H:%M:%S"`]'
#################################################
#						                        #
#		        ----ACTUALLY SET THE PS1----	#
#						                        #
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
    PS1="${__AM_I_OFFLINE}"
#    PS1="${__COLOR_1}${__date_time}${RST}"     # Date and time
    PS1+="${__COLOR_1}${__date_time}${RST}"     # Date and time
    PS1+="${__COLOR_2}\u@${RST}"                # Username '@'
    PS1+="${__COLOR_3}${__ip_addr}:${RST}"      # IP address ':'
    PS1+="${__COLOR_4}\w${RST}"                 # Working directory
    PS1+="${__git_color}${__git_branch}${RST}"  # Colored git branch/status
    PS1+="${RST}\$ "                            # A '$' and a space
fi
