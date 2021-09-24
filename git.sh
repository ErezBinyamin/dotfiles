#!/bin/bash

# Helper function
choice() {
	PROMPT=${1:-'Yes or No? '}
	while true; do
		read -p "${PROMPT}" yn
		case $yn in
			[Yy]* ) RVAL=0; break;;
			[Nn]* ) RVAL=1; break;;
			    * ) echo "Please answer yes or no.";;
		esac
	done
	return $RVAL
}


# Everyday stuff
alias ga='git add'
alias gA='git add -A'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gr='git revert'
alias gs='git status'
alias gba='git branch --all'
alias gdc='git diff --cached'
alias grm="git rm"
alias gcd='git checkout'
# Git Branch Kill
gbk() {
	local BRANCH=${1}
	git branch -D ${BRANCH} && git push -u origin :${BRANCH}
}
# Git Branch Create
gbc() {
	local BRANCH=${1}
	git checkout -b ${BRANCH} && git push -u origin ${BRANCH}
}
# Git lines of code
gloc() {
	local REPO_NAME=${1}
	local VALID_REPO=0
	local TMP=$(mktemp -d)
	local LOG=$(mktemp)
	local LOC=0
	local RVAL=1

	# Make sure repo exists
	if echo ${REPO_NAME} | grep -q -e 'http' -e '\.git' -e '\.com'
	then
		git clone --recurse-submodules ${REPO_NAME} ${TMP}
	elif [ -d ${REPO_NAME} ]
	then
		cp -r ${REPO_NAME} ${TMP}
	else
		>&2 echo "InvalidRepoName: ${REPO_NAME}"
		return 1
	fi

	# Get lines of code
	if which cloc
	then
		choice "Generate cloc analysis?" && cloc ${TMP} | tee -a ${LOG}
		RVAL=$?
	fi
	if [ -d ${TMP}/.git ]
	then
		pushd .
		cd ${TMP}
		choice "Generate git ls-files analysis?" && LOC=$(git ls-files | xargs wc -l)
		RVAL=$?
		popd
		echo "TOTAL git ls-files: ${LOC}" | tee -a ${LOG}
	fi
	choice "Publish log file: ${LOG}?" && echo "Report generated: $(share ${LOG})"
	choice "Remove tmp ${REPO_NAME} dir: ${TMP}?" && rm -rf ${TMP}
	choice "Remove log file: ${LOG}?" && rm -f ${LOG}
	return 0
}

# logging
alias gl="git log --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
alias gl1="git log --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' -n 1"
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
gln() {
	git log --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' -n $1
}

# Reseting
alias grhh='git reset --hard HEAD'                            # Reset to last commit
alias groh='git fetch origin; git reset --hard origin/master' # Reset really hard to origin state

# Remote interaction
alias gps='git push'
alias gpl='git pull'
alias gre='git remote'
ghome() {
	if [ -z ${1+x} ]
	then
		REMOTE='origin'
	elif git remote 2>/dev/null | grep -q "$1"
	then
		REMOTE="$1"
	else
		echo "Invalid remote: $1"
		return 1
	fi
	git config --get remote.${REMOTE}.url &>/dev/null && git config --get remote.${REMOTE}.url | sed 's/\.git//; s/git@//; s#https://##; s#:#/#g' | xargs firefox || echo 'Error: no git remote URL'
}

# Submodules
alias gsf='git submodule foreach'

alias rez_git='printf "
	ga	-	git add
	gA	-	git add -A
	gb	-	git branch
	gc	-	git commit
	gd	-	git diff
	gr	-	git revert
	gs	-	git status
	gba	-	all git branches
	gdc	-	show staged (added) diffs
	grm	- 	git rm
	gcd	- 	git checkout
	gbk	- 	git branck create
	gbc	- 	git branch kill
	gloc	- 	git lines of code
	gl	-	git log
	gl1	-	show last log
	gln <n>	-	show last 'n' logs
	glg	-	pretty git log graph
	grhh	-	Return to last local commit
	groh	-	Return to last remote commit
	gps	-	git push
	gpl	-	git pull
        gre     -       git remote
	ghome	-	launch firfox web-browser to navigate to origin URL
	gsf	-	git submodule foreach

"'
