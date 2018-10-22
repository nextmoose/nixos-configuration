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
    TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR} &&
	    true
    } &&
    if [ -f ${HOME}/projects/configuration/configuration.nix ]
    then
	/run/wrappers/bin/sudo cp ${HOME}/projects/configuration/configuration.nix /etc/nixos
    fi &&
    if [ -d ${HOME}/projects/configuration/custom ]
    then
	cp --recursive ${HOME}/projects/configuration/custom/. ${TEMP_DIR} &&
	    ls -1 ${TEMP_DIR} | grep ".d\$" | while read DOMAIN
	    do
		cat ${STORE_DIR}/etc/head.txt > ${TEMP_DIR}/${DOMAIN%.*}.nix &&
		    ls -1 ${TEMP_DIR}/${DOMAIN} | grep ".nix\$" | while read SUB
		    do
			echo "  ${SUB%.*} = (import ./${DOMAIN%.*}.d/${SUB%.*}.nix { inherit pkgs; });
" >> ${TEMP_DIR}/${DOMAIN%.nix}.nix
			true
		    done &&
		    cat ${STORE_DIR}/etc/tail.txt >> ${TEMP_DIR}/${DOMAIN%.*}.nix &&
		    true
	    done &&
	    /run/wrappers/bin/sudo \
		rsync \
		--verbose \
		--archive \
		--delete \
		${TEMP_DIR} \
		/etc/nixos &&
	    if [ -d ${HOME}/projects/configuration/custom/virtualisation.d ]
	    then
		(ca
		 true
		fi &&
		     true
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
