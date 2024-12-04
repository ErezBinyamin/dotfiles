#!/bin/bash
# Script to add docker helper functions
DIR="${TOP_DIR}/Neverland/ScriptWrappers"

source ${DIR}/arduino.sh
source ${DIR}/bettercap.sh
source ${DIR}/cAdvisor.sh
source ${DIR}/docker-del.sh
source ${DIR}/ee2wine.sh
source ${DIR}/matlab.sh
source ${DIR}/osrs.sh
source ${DIR}/pihole.sh
source ${DIR}/smtp_server.sh

alias rez_docker='printf "
	arduino		-	arduino GUI
	bettercap    	-	bettercap CLI console
	cAdvisor        -       Container Advisor web UI
	docker-del   	-	Brute force docker deleting tool
	ee2wine         -       Play Empire Earth2 in wine in docker
	matlab       	-	MatLab GUI
	osrs         	-	Oldschool Runescape GUI
	pihole       	-	pihole blakchole for adds (Set router DNS server)
	smtp_server  	-	localhost testing smtp mail server
"'
