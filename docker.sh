alias docker='sudo docker'

dockerClean()(

# Print usage message
    usage() {
        printf "\nUSAGE: dockerClean [-c] [-h] [-i] [-v]\n\n"
        exit 0
    }

# Print help message
    help() {
        usage
        printf "\tUSAGE"
        printf "\t\n-c\t"
        printf "\t\n-h\t"
        printf "\t\n-i\t"
        printf "\\tn-v\t"
        exit 0
    }

# Print version message
    version() {
        printf "\nVersion\n\n"
        printf "\n"
        printf "\n"
        printf "\n"
        printf "\n"
        exit 0
    }

# Remove all docker images
    rm_images() {
        docker rmi -f $(docker images -a -q)
    }

# Remove all docker containers
    rm_containers() {
        docker rm -vf $(docker ps -a -q)
    }
# ---------------------------------------------- #
#                     MAIN
# ---------------------------------------------- #
    local CONTAINER=0
    local IMAGE=0

    while getopts "chiv" o; do
        case "${o}" in
            c)
                CONTAINER=1
                ;;
            h)
                help
                ;;
            i)
                IMAGE=1
                ;;
            v)
                version
                ;;
            *)
                usage
                ;;
        esac
    done
    shift $((OPTIND-1))

    [ $CONTAINER -eq 1 ] && rm_containers
    [ $IMAGE -eq 1 ] && rm_images
)
