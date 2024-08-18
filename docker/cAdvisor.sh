#!/bin/bash
# Functions that will launch docker containers

cAdvisor() {
	local PORT=$(next_port 8080)
	if docker ps | grep -q cadvisor
	then
		echo "Bringing down cAdvisor container.."
		sleep 1
		docker container stop cadvisor
		docker container prune
	else
		echo "cAdvisor: http://localhost:${PORT}"
		sleep 1
		docker run \
			--volume=/:/rootfs:ro \
			--volume=/var/run:/var/run:ro \
			--volume=/sys:/sys:ro \
			--volume=/var/lib/docker/:/var/lib/docker:ro \
			--volume=/dev/disk/:/dev/disk:ro \
			--publish=${PORT}:8080 \
			--detach=true \
			--name=cadvisor \
			--privileged \
			--device=/dev/kmsg \
			gcr.io/cadvisor/cadvisor:v0.40.0
	fi
}
