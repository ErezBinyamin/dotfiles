#!/bin/bash

# Everyday stuff
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gs='git status'

alias gba='git branch --all'
alias gdc='git diff --cached'
alias grm="git rm \$(git status -s | grep '^ D' | sed 's/ D //')"

# logging
alias gl='git log'
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
alias gl1='git log -n 1'

# Reseting
alias grhh='git reset --hard HEAD'                            # Reset to last commit
alias groh='git fetch origin; git reset --hard origin/master' # Reset really hard to origin state

# Remote interaction
alias gps='git push'
alias gpl='git pull'
alias ghome="git config --get remote.origin.url | sed 's/\.git//; s/git@/www\./; s#https://#www\.#; s#\.com:#\.com/#' | xargs firefox"

# Submodules
alias gsf='git submodule foreach'

alias rez_git='printf "
	ga	-	git add
	gb	-	git branch
	gc	-	git commit
	gd	-	git diff
	gs	-	git status
	gba	-	all git branches
	gdc	-	show staged (added) diffs
	grm	- 	stage all removed files
	gl	-	git log
	gl1	-	show last log
	glg	-	pretty git log graph
	grhh	-	Return to last local commit
	groh	-	Return to last remote push
	gps	-	git push
	gpl	-	git pull
	ghome	-	launch firfox web-browser to navigate to origin URL
	gsf	-	git submodule foreach

"'
