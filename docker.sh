#!/bin/bash
# Functions that will launch docker containers

# FROM https://github.com/tombenke/darduino
# Launches arduino GUI
# May need to install python dependencies
# docker exec --user root -it <Container Name> bash -c "apt update; apt install python python-pip; pip install pyserial"
arduino() {
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

# FROM: https://github.com/austin-millan/oldschool-runescape-launcher
osrs() {
    docker run -ti \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       aamillan/oldschool-runescape-launcher \
       oldschool
    return $?
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

	[ $# -eq 0 ] && usage
	while getopts "acivh" o
	do
		case "${o}" in
		a)
			echo "Delete all docker containers, images, and volumes? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			[ $(docker container ls | wc -l) -gt 1 ] && docker rm -vf $(docker ps -a -q) || echo "No containers to remove"
			[ $(docker image ls | wc -l)     -gt 1 ] && docker volume rm $(docker volume ls -q --filter dangling=true) || echo "No images to remove"
			[ $(docker volume ls | wc -l)    -gt 1 ] && docker rmi -f $(docker images -a -q) || echo "No volumes to remove"
			;;
		c)
			[ $(docker container ls | wc -l) -gt 1 ] || echo "No containers to remove"
			echo "Delete all docker containers? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			[ $(docker container ls | wc -l) -gt 1 ] && docker rm -vf $(docker ps -a -q)
			;;
		i)
			[ $(docker image ls | wc -l)     -gt 1 ] || echo "No images to remove"
			echo "Delete all docker images? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			[ $(docker image ls | wc -l)     -gt 1 ] && docker volume rm $(docker volume ls -q --filter dangling=true) 
			;;
		v)
			[ $(docker volume ls | wc -l)    -gt 1 ] || echo "No volumes to remove"
			echo "Delete all docker volumes? [Y/N]: "
			read -sn1 CH
			[[ 'Yy' =~ "${CH}" ]] || return 0
			[ $(docker volume ls | wc -l)    -gt 1 ] && docker rmi -f $(docker images -a -q)
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

