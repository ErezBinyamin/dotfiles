#!/bin/bash
# Functions that will launch docker containers
matlab() {
	xhost +local:$(id -un)

	docker run --rm -it \
		--net=host \
		--env DISPLAY="${DISPLAY}" \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		--shm-size=512M \
		mathworks/matlab:r2021a
}

