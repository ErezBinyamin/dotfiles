#!/bin/bash
# Functions that will launch docker containers
ee2wine() { 	
	local IMAGE_NAME=erezbinyamin/ee2wine:latest
	if [ "${USER_VOLUME}" == "winehome" ] && ! docker volume ls -qf "name=winehome" | grep -q "^winehome$"
	then
		echo "INFO: Creating Docker volume container 'winehome'..."
		docker volume create winehome
	fi
	if [ -z "${XAUTHORITY:-${HOME}/.Xauthority}" ]
	then
		echo "ERROR: No valid .Xauthority file found for X11"
		return 1
	fi
	xhost +local:$(id -un)
	xauth list "${DISPLAY}" | head -n1 | awk '{print $3}' > ~/.docker-wine.Xkey
	
	sudo chrt --fifo 99 docker run -it --rm \
		--name=wine2 \
		--hostname=$(hostname) \
		--shm-size=1g \
		--workdir=/ \
		--env=RUN_AS_ROOT=yes \
		--env=DISPLAY \
		--env=TZ=America/New_York \
		--volume=/home/${USER}/.docker-wine.Xkey:/root/.Xkey:ro \
		--volume=/tmp/pulse-socket:/tmp/pulse-socket \
		--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
		--volume=winehome:/home/wineuser \
		--cap-add=NET_ADMIN \
		--privileged \
		${IMAGE_NAME} bash
}
