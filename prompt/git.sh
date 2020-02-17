#!/bin/bash

# ---- Git command line prompt ----
# GIT PULL
#       Determine if a git pull command is needed
#	Only execute this check if on a fast network
if [ $PROMPT_SLOW_NETWORK -eq 0 ]
then
	export __prompt_git_pull='`
	GIT_PULL_SYMBOL="↓"
	if [ $PROMPT_GIT_REMOTE -eq 1 ]
	then
		if [[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]] && [ $(git pull --dry-run 2>&1 | wc -l) -gt 1 ]
		then
			printf "\[\033[00m\]\[\033[1;5;96m\] ${GIT_PULL_SYMBOL}\[\033[00m\]"
		fi
	fi
	`'
else
    export __prompt_git_pull='``'
fi

# GIT PUSH
#       Determine if a git push command is needed
export __prompt_git_push='`
GIT_PUSH_SYMBOL="↑"
if [ $PROMPT_GIT_REMOTE -eq 1 ] && [[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]]
then
	git status | grep -q "git push" && printf "\[\033[00m\]\[\033[1;5;96m\]${GIT_PUSH_SYMBOL}\[\033[00m\]"
fi
`'

# GIT REPO:
#       Shows name of current git repo in random color
#       Shows oposite color on border (Incase of unreadable color)
export __prompt_git_repo='`
REPO_BORDER_SYMBOL_LEFT="|"
REPO_BORDER_SYMBOL_RIGHT="|"
if [ $PROMPT_GIT_REPO -eq 1 ]
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
export __prompt_git_color='`
GIT_NEW_FILE_SYMBOL="+"
GIT_EDIT_FILE_SYMBOL="*"
if [ $PROMPT_GIT_BRANCH -eq 1 ]
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
export __prompt_git_branch='`
if [ $PROMPT_GIT_BRANCH -eq 1 ] && [[ "$(git rev-parse --git-dir 2> /dev/null)" =~ git ]]
then
	git branch 2>/dev/null | grep -e ^* | sed "s:* ::"
fi
`'
