#!/bin/bash

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

# logging
alias gl='git log --abbrev-commit'
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
alias gl1='git log --abbrev-commit -n 1'
gln() {
	git log --abbrev-commit -n $1
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
