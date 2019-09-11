#!/bin/bash

alias docker='sudo docker'

# The only function defined in here thus far
# Acts like command line command implementing get-opt and all that
# Simply allows me to be lazy with docker things
# Mostly a tool for deleting stuff
dockerTool()(
    sudo echo foo > /dev/null
# Remove all docker CONTAINERS
    rm_containers() {
        [ $(docker ps -a -q | wc -w) -gt 0 ] && docker rm $(docker ps -aq) || echo "$(tput setaf 3)No containers$(tput sgr0)"
        return $?
    }

# Remove all docker iIMAGES
    rm_images() {
        [ $(docker images -a -q | wc -w) -gt 0 ] && docker rmi $(docker images -aq) || echo "$(tput setaf 3)No images$(tput sgr0)"
        return $?
    }

# Remove all docker VOLUMES
    rm_volumes() {
	[ $(docker volume ls | wc -l) -gt 1 ] && docker volume rm $(docker volume ls -q) || echo "$(tput setaf 3)No volumes$(tput sgr0)"
        return $?
    }

# Remove ALL docker stuffs
    rm_all() {
	docker system prune
	rm_volumes
	rm_containers
	rm_images
        return $?
    }

# Show all docker status
	docker_status() {
	printf "\n------- IMAGES -------\n"
        [ $(docker image ls | wc -l) -gt 1 ] && docker images || echo "$(tput setaf 3)No images$(tput sgr0)"
	printf "\n----- CONTAINTERS ----\n"
        [ $(docker ps -a | wc -l) -gt 1 ] && docker ps -as || echo "$(tput setaf 3)No containers$(tput sgr0)"
	printf "\n------- VOLUMES ------\n"
        [ $(docker volume ls | wc -l) -gt 1 ] && docker volume ls || echo "$(tput setaf 3)No volumes$(tput sgr0)"
	printf "$(tput sgr0)\n"
        return 0
    }

# Print help message
    docker_help() {
	version
	usage
        printf "\n\t-a: Clean Everything"
        printf "\n\t-c: Clean Containers"
        printf "\n\t-h: Help"
        printf "\n\t-i: Clean Images"
	printf "\n\t-s: Status"
        printf "\n\t-v: Clean volumes"
        printf "\n\n"
        return 0
    }

# Print version message
    version() {
	echo "dockerClean 1.2.0"
        return 0
    }

# Print usage message
    usage() {
        echo "USAGE: dockerClean [-a] [-c] [-h] [-i] [-s] [-v]"
        return 0
    }

# ---------------------------------------------- #
#                     MAIN
# ---------------------------------------------- #
    local ALL=0
    local CONTAINER=0
    local HELP=0
    local IMAGE=0
    local STATUS=0
    local VOLUME=0

    while getopts "achisv" o; do
        case "${o}" in
            a)
                ALL=1
                ;;
            c)
                CONTAINER=1
                ;;
            h)
                HELP=1
                ;;
            i)
                IMAGE=1
                ;;
            s)
                STATUS=1
                ;;
            v)
                VOLUME=1
                ;;
            *)
                usage
                ;;
        esac
    done
    shift $((OPTIND-1))

    [ $ALL -eq 1 ]       && rm_all
    [ $CONTAINER -eq 1 ] && rm_containers
    [ $HELP -eq 1 ]      && docker_help
    [ $IMAGE -eq 1 ]     && rm_images
    [ $STATUS -eq 1 ]    && docker_status
    [ $VOLUME -eq 1 ]    && rm_volumes
)
