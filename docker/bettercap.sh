#!/bin/bash
# Functions that will launch docker containers

bettercap() {
	local TMP=$(mktemp -d /tmp/bettercap.XXXXX)
	local VOLUME_ARG=${TMP}:/tmp/out
	echo "TMP DIR mounted: ${VOLUME_ARG}"

	docker run -it --rm \
		--privileged \
		--net=host \
		--publish 8080:8080 \
		--volume "${VOLUME_ARG}" \
		bettercap/bettercap

	read -p "Delete mounted directory: ${TMP}? [y/n]: " READ
	[[ "${READ,,}" =~ "y" ]] && rm -rf ${TMP}
}

