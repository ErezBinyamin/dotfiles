#!/bin/bash
# This script gets called from ${TOP_DIR}/top.sh

source ${TOP_DIR}/docker/arduino.sh
source ${TOP_DIR}/docker/bettercap.sh
source ${TOP_DIR}/docker/cAdvisor.sh
source ${TOP_DIR}/docker/docker-del.sh
source ${TOP_DIR}/docker/ee2wine.sh
source ${TOP_DIR}/docker/matlab.sh
source ${TOP_DIR}/docker/osrs.sh
source ${TOP_DIR}/docker/pihole.sh
source ${TOP_DIR}/docker/smtp_server.sh

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
