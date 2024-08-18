#!/bin/bash
osrs() {
	# FROM: https://github.com/austin-millan/oldschool-runescape-launcher
	xhost +local:$(id -un)
	docker run -ti --rm \
	   -e DISPLAY=$DISPLAY \
	   -v /tmp/.X11-unix:/tmp/.X11-unix \
	   aamillan/oldschool-runescape-launcher \
	   oldschool
	return $?
}

