alias docker='sudo docker'

dockerClean()(

# Remove all docker images
    rm_images() {
        [ $(docker images -a -q | wc -w) -gt 0 ] && docker images -a -q && docker rmi -f $(docker images -a -q) || echo "No images to remove :("
        return 0
    }

# Remove all docker containers
    rm_containers() {
        [ $(docker ps -a -q | wc -w) -gt 0 ] && docker rm -vf $(docker ps -a -q) || echo "No containers to remove :("
        return 0
    }

# Print help message
    docker_help() {
        printf "USAGE:"
        printf "\n\t-i: Clean Images"
        printf "\n\t-c: Clean Containers"
        printf "\n\t-h: Help"
        printf "\n\t-v: Version Info"
        printf "\n\n"
        return 0
    }

# Print version message
    version() {
        printf "\nVersion\n\n"
        printf "\n"
        printf "\n"
        printf "\n"
        printf "\n"
        return 0
    }

# Print usage message
    usage() {
        printf "\nUSAGE: dockerClean [-c] [-h] [-i] [-v]\n\n"
        return 0
    }

# ---------------------------------------------- #
#                     MAIN
# ---------------------------------------------- #
    local IMAGE=0
    local CONTAINER=0
    local HELP=0
    local VERSION=0

    while getopts "chiv" o; do
        case "${o}" in
            i)
                IMAGE=1
                ;;
            c)
                CONTAINER=1
                ;;
            h)
                HELP=1
                ;;
            v)
                VERSION=1
                ;;
            *)
                usage
                ;;
        esac
    done
    shift $((OPTIND-1))

    [ $IMAGE -eq 1 ]     && rm_images
    [ $CONTAINER -eq 1 ] && rm_containers
    [ $HELP -eq 1 ]      && docker_help
    [ $VERSION -eq 1 ]   && version
)
