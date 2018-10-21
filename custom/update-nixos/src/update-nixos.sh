#!/bin/sh

RESTART_CONTAINERS="false" &&
    while [ "${#}" -gt 0 ]
    do
	case "${1}" in
	    --restart-containers)
		RESTART_CONTAINERS="true" &&
		    shift &&
		    true
		;;
	    *)
		echo Unsupported Option &&
		    echo ${1} &&
		    echo ${0} &&
		    echo ${@} &&
		    exit 66 &&
		    true
		;;
	esac &&
	    true
    done &&
    if [ -f ${HOME}/projects/configuration/configuration.nix ]
    then
	/run/wrappers/bin/sudo cp ${HOME}/projects/configuration/configuration.nix /etc/nixos
    fi &&
    if [ -d ${HOME}/projects/configuration/custom ]
    then
	/run/wrappers/bin/sudo \
	    rsync \
	    --verbose \
	    --archive \
	    --delete \
	    ${HOME}/projects/configuration/custom \
	    /etc/nixos
    fi &&
    /run/wrappers/bin/sudo /run/current-system/sw/bin/nixos-rebuild switch &&
    if [ "${RESTART_CONTAINERS}" == "true" ]
    then
	/run/wrappers/bin/sudo nixos-container list | while read CONTAINER
	do
	    (/run/wrappers/bin/sudo nixos-container stop ${CONTAINER} || true) &&
	    /run/wrappers/bin/sudo nixos-container start ${CONTAINER} &&
	    true
	done &&
	    true
    fi &&
    true
