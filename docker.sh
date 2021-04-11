#!/bin/bash
# Functions that will launch docker containers

arduino() {
    DEVICE=${1:-/dev/ttyUSB0}
    CHOME=/home/developer
    if [ ! -d $HOME/Arduino ]
    then
        echo "DirectoryNotFound: $HOME/Arduino"
        return 1
    fi
    if [ ! -f ${DEVICE} ]
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
