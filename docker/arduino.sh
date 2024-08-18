#!/bin/bash

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

