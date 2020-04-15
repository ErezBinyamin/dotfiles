#!/bin/bash

# ---- Git command line prompt ----
# GIT PULL
#       Determine if a git pull command is needed
#	Only execute this check if on a fast network
if [ $PROMPT_SLOW_NETWORK -eq 0 ]
then
	export __prompt_git_pull='`
	#GIT_PULL_SYMBOL="↓"
	GIT_PULL_SYMBOL="v"
	if [ $PROMPT_GIT_REMOTE -eq 1 ] && git rev-parse --git-dir &>/dev/null && [ $(git pull --dry-run 2>&1 | wc -l) -gt 1 ]
	then
		printf "\[\033[00m\]\[\033[1;5;96m\] ${GIT_PULL_SYMBOL}\[\033[00m\]"
	fi
	`'
else
    export __prompt_git_pull='``'
fi

# GIT PUSH
#       Determine if a git push command is needed
export __prompt_git_push='`
#GIT_PUSH_SYMBOL="↑"
GIT_PUSH_SYMBOL="^"
if [ $PROMPT_GIT_REMOTE -eq 1 ] && git rev-parse --git-dir &>/dev/null
then
	git status 2>/dev/null | grep -q "git push" && printf "\[\033[00m\]\[\033[1;5;96m\]${GIT_PUSH_SYMBOL}\[\033[00m\]"
fi
`'

# GIT REPO:
#       Shows name of current git repo in random color
#       Shows oposite color on border (Incase of unreadable color)
export __prompt_git_repo='`
REPO_BORDER_SYMBOL_LEFT="|"
REPO_BORDER_SYMBOL_RIGHT="|"
if [ $PROMPT_GIT_REPO -eq 1 ] && git rev-parse --git-dir &>/dev/null
then
	REPO_NAME="$(echo $(git config --get remote.origin.url || git rev-parse --absolute-git-dir) | sed 's/\.git//g' | xargs basename)"
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
`'


# GIT COLOR:
#       Generates color based upon local change status
#       Green : Up to date
#       Yellow: Ready to commit
#       Red   : Unstaged changes
export __prompt_git_color='`
GIT_NEW_FILE_SYMBOL="+"
GIT_EDIT_FILE_SYMBOL="*"
GIT_DIR_SYMBOL="@"
if [ $PROMPT_GIT_BRANCH -eq 1 ] && git rev-parse --git-dir &>/dev/null
then
	if echo "$PWD" | grep -q "/.git"
	then
		printf " \[\033[1;38;5;4m\]${GIT_DIR_SYMBOL}"
	else
		printf " \[\033[1;38;5;2m\]"
		git diff-index --quiet --cached HEAD -- 2>/dev/null || printf "\[\033[1;38;5;3m\]"
		git diff --quiet 2>/dev/null || printf "\[\033[1;38;5;1m\]${GIT_EDIT_FILE_SYMBOL}"
		git status -s | grep -q -m 1 '??' && printf "\[\033[1;38;5;1m\]${GIT_NEW_FILE_SYMBOL}"
	fi
fi
`'

# GIT BRANCH:
#       Prints current git branch
export __prompt_git_branch='`
if [ $PROMPT_GIT_BRANCH -eq 1 ] && git rev-parse --git-dir &>/dev/null
then
	git branch 2>/dev/null | grep -e ^* | sed "s:* ::"
fi
`'
