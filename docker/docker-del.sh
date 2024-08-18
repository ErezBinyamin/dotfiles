#!/bin/bash
# Functions that will launch docker containers
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
			read -sn1 CHOICE
			[[ 'Yy' =~ "${CHOICE}" ]] || return 0
			docker system prune -f
			rm_images
			rm_containers
			rm_volumes
			;;
		c)
			printf "Delete all docker containers? [Y/N]: "
			read -sn1 CHOICE
			[[ 'Yy' =~ "${CHOICE}" ]] || return 0
			rm_containers
			;;
		i)
			printf "Delete all docker images? [Y/N]: "
			read -sn1 CHOICE
			[[ 'Yy' =~ "${CHOICE}" ]] || return 0
			rm_images
			;;
		v)
			printf "Delete all docker volumes? [Y/N]: "
			read -sn1 CHOICE
			[[ 'Yy' =~ "${CHOICE}" ]] || return 0
			rm_volumes
			;;
		o)
			printf "Delete all orphan images? [Y/N]:"
			read -sn1 CHOICE
			[[ 'Yy' =~ "${CHOICE}" ]] || return 0
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

