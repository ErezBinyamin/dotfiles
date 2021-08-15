#!/bin/bash
# Functions that will launch docker containers

arduino() {
    # FROM https://github.com/tombenke/darduino
    # Launches arduino GUI
    # May need to install python dependencies
    # docker exec --user root -it <Container Name> bash -c "apt update; apt install python python-pip; pip install pyserial"
    DEVICE=${1:-/dev/ttyUSB0}
    CHOME=/home/developer
    if [ ! -d $HOME/Arduino ]
    then
        echo "DirectoryNotFound: $HOME/Arduino"
        return 1
    fi
    if [ ! -e ${DEVICE} ]
    then
        echo "FileNotFound: $DEVICE"
        return 1
    fi
    docker run \
        -it \
        --rm \
        --network=host \
        -e DISPLAY=$DISPLAY \
        -v $HOME/.Xauthority:${CHOME}/.Xauthority \
        --device ${DEVICE}:${DEVICE} \
        -v $HOME/Arduino:${CHOME}/Arduino \
        tombenke/darduino \
        arduino
    return $?
}

osrs() {
	# FROM: https://github.com/austin-millan/oldschool-runescape-launcher
	xhost +local:$(id -un)
	docker run -ti \
	   -e DISPLAY=$DISPLAY \
	   -v /tmp/.X11-unix:/tmp/.X11-unix \
	   aamillan/oldschool-runescape-launcher \
	   oldschool
	return $?
}


bettercap() {
	TMP=$(mktemp -d /tmp/bettercap.XXXXX)
	VOLUME_ARG=${TMP}:/tmp/out
	echo "TMP DIR mounted: ${VOLUME_ARG}"
	docker run -it --privileged --net=host -p 8080:8080 -v ${VOLUME_ARG} bettercap/bettercap
	read -p "Delete mounted directory: $TMP? [y/n]: " X
	[[ "${X,,}" =~ "y" ]] && rm -rf ${TMP}
}

metasploit () {
    docker run --net=host -it metasploitframework/metasploit-framework
}


matlab() {
	xhost +
	docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro --shm-size=512M mathworks/matlab:r2021a
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
		docker run -d \
		    --name pihole \
		    -p ${P_DNS}:53/tcp \
		    -p ${P_DNS}:53/udp \
		    -p ${P_67}:67/udp \
		    -p ${P_HTTP}:80/tcp \
		    -p ${P_HTTPS}:443/tcp \
		    -v "${PIHOLE_BASE}/etc-pihole/:/etc/pihole/" \
		    -v "${PIHOLE_BASE}/etc-dnsmasq.d/:/etc/dnsmasq.d/" \
		    --dns=127.0.0.1 \
		    --dns=1.1.1.1 \
		    --restart=unless-stopped \
		    --hostname pi.hole \
		    -e VIRTUAL_HOST="pi.hole" \
		    -e PROXY_LOCATION="pi.hole" \
		    -e PIHOLE_DNS_="127.0.0.1#5353;8.8.8.8;8.8.4.4;1.1.1.1" \
		    -e TZ=${TIMEZONE} \
		    -e ServerIP=${EXTERNAL_IP} \
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

# Usefull docker aliases/functions
docker-del() (
	usage() {
		echo "${FUNCNAME[-1]}: usage: ${FUNCNAME[-1]} -[a|c|i|v|h]"
		return 0
	}

	help() {
		echo "${FUNCNAME[-1]}: usage: ${FUNCNAME[-1]} -[a|c|i|v|h]"
		printf "  -a\t Delete all docker containers, images, and volumes\n"
		printf "  -c\t Delete all docker containers\n"
		printf "  -i\t Delete all docker images\n"
		printf "  -v\t Delete all docker volumes\n"
		printf "  -h\t Help\n"
		return 0
	}

	rm_images() {
		[ $(docker image ls | wc -l) -gt 1 ] && docker image prune -f
		[ $(docker image ls | wc -l) -gt 1 ] && docker rmi -f $(docker images -a -q)
		[ $(docker image ls | wc -l) -gt 1 ] || echo "No more images to remove"
	}

	rm_containers() {
		[ $(docker container ls | wc -l) -gt 1 ] && docker container prune -f
		[ $(docker container ls | wc -l) -gt 1 ] && docker rm -vf $(docker ps -a -q)
	       	[ $(docker container ls | wc -l) -gt 1 ] || echo "No more containers to remove"
	}

	rm_volumes() {
		[ $(docker volume ls | wc -l) -gt 1 ] && docker volume prune -f
		[ $(docker volume ls | wc -l) -gt 1 ] && docker volume rm $(docker volume ls -q)
	       	[ $(docker volume ls | wc -l) -gt 1 ] || echo "No more volumes to remove"
	}

	[ $# -eq 0 ] && usage
	while getopts "acivh" o
	do
		case "${o}" in
		a)
			echo "Delete all docker containers, images, and volumes? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			docker system prune -f
			rm_images
			rm_containers
			rm_volumes
			;;
		c)
			echo "Delete all docker containers? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			rm_containers
			;;
		i)
			echo "Delete all docker images? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			rm_images
			;;
		v)
			echo "Delete all docker volumes? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			rm_volumes
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

