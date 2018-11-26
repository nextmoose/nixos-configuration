 #!/bin/sh

GARBAGE="no" &&
    DOCKER="no" &&
    while [ "${#}" -gt 0 ]
    do
	case "${1}" in
	    --source-directory)
		SOURCE_DIRECTORY="${2}" &&
		    shift 2 &&
		    true
		;;
	    --garbage)
		GARBAGE="yes" &&
		    shift 1 &&
		    true
		;;
	    --docker)
		DOCKER="yes" &&
		    shift 1 &&
		    true
		;;
	    *)
		echo Unknown Option &&
		    echo "${1}" &&
		    echo "${0}" &&
		    echo "${@}" &&
		    exit 66 &&
		    true
		;;
	esac
    done &&
    TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR} &&
	    true
    } &&
    cd "${SOURCE_DIRECTORY}" &&
    if [ "${DOCKER}" == "yes" ]
    then
	docker container ls --quiet --all | while read CID
	do
	    docker container stop "${CID}" &&
		docker container rm "${CID}" &&
		true
	done &&
	    docker system prune --force --all --volumes &&
	    true
    fi &&
    if [ "${GARBAGE}" == "yes" ]
    then
	nix-collect-garbage &&
	    true
    fi &&
    if [ -f configuration.nix ]
    then
	sudo cp configuration.nix /etc/nixos
    fi &&
    if [ -d custom ]
    then
	rsync \
	    --verbose \
	    --archive \
	    --delete \
	    custom \
	    /etc/nixos &&
	    true
    fi &&
    sudo nixos-rebuild switch &&
    if [ "${DOCKER}" == "yes" ]
    then
	docker-image-load &&
	    true
    fi &&
    true
