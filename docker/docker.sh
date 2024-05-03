#!/bin/bash
# Functions that will launch docker containers

arduino() {
    # FROM https://github.com/tombenke/darduino
    # Launches arduino GUI
    # May need to install python dependencies
    # docker exec --user root -it <Container Name> bash -c "apt update; apt install python python-pip; pip install pyserial"
    CHOME=/home/developer
    DEVICE_ARGS=()
    
    echo "Discovering Arduino devices ...."
    for D in $(ls -l /dev/serial/by-id/ | grep 'Arduino' | grep -o 'tty.*')
    do
        DEVICE_ARGS+=( "--device /dev/${D}:/dev/${D}" )
	echo "Found: ${D}"
    done
    if [ ${#DEVICE_ARGS[@]} -eq 0 ]
    then
        echo "No Arduino devices found in /dev/serial/by-id/"
        return 1
    fi
    if [ ! -d $HOME/Arduino ]
    then
        echo "DirectoryNotFound: $HOME/Arduino"
        return 1
    fi
    set -x
    docker run \
        -it \
        --rm \
        --network=host \
        -e DISPLAY=$DISPLAY \
        -v $HOME/.Xauthority:${CHOME}/.Xauthority \
        ${DEVICE_ARGS[@]} \
        -v $HOME/Arduino:${CHOME}/Arduino \
        tombenke/darduino \
        arduino
    set +x
    return $?
}

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


bettercap() {
	local TMP=$(mktemp -d /tmp/bettercap.XXXXX)
	local VOLUME_ARG=${TMP}:/tmp/out
	echo "TMP DIR mounted: ${VOLUME_ARG}"

	docker run -it --rm \
		--privileged \
		--net=host \
		--port 8080:8080 \
		--volume "${VOLUME_ARG}" \
		bettercap/bettercap

	read -p "Delete mounted directory: ${TMP}? [y/n]: " READ
	[[ "${READ,,}" =~ "y" ]] && rm -rf ${TMP}
}

metasploit() {
    docker run --rm -it \
	    --net=host \
	    metasploitframework/metasploit-framework
}

smtp_server() {
	docker run --rm \
		--net=host \
		maildev/maildev
}

matlab() {
	xhost +local:$(id -un)

	docker run --rm -it \
		--net=host \
		--env DISPLAY="${DISPLAY}" \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		--shm-size=512M \
		mathworks/matlab:r2021a
}

pihole() {
	if docker container ls 2>/dev/null | grep -q 'pihole'
	then
		echo "Stopping pihole..."
		docker container stop pihole
		docker container rm pihole
		echo "pihole stopped"
	else
		# https://github.com/pi-hole/docker-pi-hole/blob/master/README.md 
		PIHOLE_BASE="${PIHOLE_BASE:-$(pwd)}"
		[[ -d "$PIHOLE_BASE" ]] || mkdir -p "$PIHOLE_BASE" || { echo "Couldn't create storage directory: $PIHOLE_BASE"; exit 1; }

		# Note: ServerIP should be replaced with your external ip.
		local P_DNS=$(next_port 53)
		local P_67=$(next_port 67)
		local P_HTTP=$(next_port 80)
		local P_HTTPS=$(next_port 443)
		local TIMEZONE='America/New_York' # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
		local EXTERNAL_IP=$(public_ip)

		docker run --detach \
		    --name pihole \
		    --port ${P_DNS}:53/tcp \
		    --port ${P_DNS}:53/udp \
		    --port ${P_67}:67/udp \
		    --port ${P_HTTP}:80/tcp \
		    --port ${P_HTTPS}:443/tcp \
		    --volume "${PIHOLE_BASE}/etc-pihole/:/etc/pihole/" \
		    --volume "${PIHOLE_BASE}/etc-dnsmasq.d/:/etc/dnsmasq.d/" \
		    --dns=127.0.0.1 \
		    --dns=1.1.1.1 \
		    --restart=unless-stopped \
		    --hostname pi.hole \
		    --env VIRTUAL_HOST="pi.hole" \
		    --env PROXY_LOCATION="pi.hole" \
		    --env PIHOLE_DNS_="127.0.0.1#5353;8.8.8.8;8.8.4.4;1.1.1.1" \
		    --env TZ=${TIMEZONE} \
		    --env ServerIP=${EXTERNAL_IP} \
		    --restart=unless-stopped \
		    pihole/pihole:latest

		printf "\nStarting up pihole container: http://localhost:${P_HTTP}"
		printf "\nUsing Ports:\n\tDNS: ${P_DNS}\n\tHTTP: ${P_HTTP}\n\tHTTPS: ${P_HTTPS}\n\t67: ${P_67}\n"
		sleep 10
		wait

		for i in $(seq 1 20); do
		    if [ "$(docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ] ; then
		        printf ' OK'
		        echo -e "\n$(docker logs pihole 2> /dev/null | grep 'password:') for your pi-hole: https://${IP}/admin/"
		        return 0
		    else
		        sleep 3
		        printf '.'
		    fi

		    if [ $i -eq 20 ] ; then
		        echo -e "\nTimed out waiting for Pi-hole start, consult your container logs for more info (\`docker logs pihole\`)"
		        return 1
		    fi
		done;
	fi
}

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

# Usefull docker aliases/functions
docker-del() (
	usage() {
		echo "${FUNCNAME[-1]}: usage: ${FUNCNAME[-1]} -[a|c|i|v|o|h]"
		return 0
	}

	help() {
		echo "${FUNCNAME[-1]}: usage: ${FUNCNAME[-1]} -[a|c|i|v|o|h]"
		printf "  -a\t Delete all docker containers, images, and volumes\n"
		printf "  -c\t Delete all docker containers\n"
		printf "  -i\t Delete all docker images\n"
		printf "  -v\t Delete all docker volumes\n"
		printf "  -o\t Delete all docker orpahn images\n"
		printf "  -h\t Help\n"
		return 0
	}

	rm_images() {
		[ $(docker image ls | wc -l) -gt 1 ] && docker image prune -f
		[ $(docker image ls | wc -l) -gt 1 ] && docker rmi -f $(docker images -a -q)
		[ $(docker image ls | wc -l) -gt 1 ] || echo "No more images to remove"
	}

	rm_containers() {
		docker container prune -f
		[ $(docker container ls | wc -l) -gt 1 ] && docker rm -vf $(docker ps -a -q)
	       	[ $(docker container ls | wc -l) -gt 1 ] || echo "No more containers to remove"
	}

	rm_volumes() {
		[ $(docker volume ls | wc -l) -gt 1 ] && docker volume prune -f
		[ $(docker volume ls | wc -l) -gt 1 ] && docker volume rm $(docker volume ls -q)
	       	[ $(docker volume ls | wc -l) -gt 1 ] || echo "No more volumes to remove"
	}

	rm_orphans() {
		if [ $(docker image ls | grep 'none' | wc -l) -gt 0 ]
		then
			docker container prune -f
			docker images | grep 'none' | grep -oE '[0-9a-z]{12,}' | xargs docker image rm
		else
			echo "No more orphan images to remove"
		fi
	}

	[ $# -eq 0 ] && usage
	while getopts "acivoh" o
	do
		case "${o}" in
		a)
			printf "Delete all docker containers, images, and volumes? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			docker system prune -f
			rm_images
			rm_containers
			rm_volumes
			;;
		c)
			printf "Delete all docker containers? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			rm_containers
			;;
		i)
			printf "Delete all docker images? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			rm_images
			;;
		v)
			printf "Delete all docker volumes? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			rm_volumes
			;;
		o)
			printf "Delete all orphan images? [Y/N]:"
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			rm_orphans
			;;
		h)
			help
			;;
		*)
			usage
			;;
		esac
	done
	shift $((OPTIND-1))
)

alias rez_docker='printf "
	arduino		-	arduino GUI
	osrs         	-	Oldschool Runescape GUI
	bettercap    	-	bettercap CLI console
	metasploit   	-	metasploit CLI console
	smtp_server  	-	localhost testing smtp mail server
	matlab       	-	MatLab GUI
	pihole       	-	pihole blakchole for adds (Set router DNS server)
	docker-del   	-	Brute force docker deleting tool
"'
