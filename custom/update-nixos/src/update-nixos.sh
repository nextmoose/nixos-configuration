#!/bin/sh

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
	    ls -1 ${TEMP_DIR} | grep "[.]d\$" | while read DOMAIN
	    do
		cat ${STORE_DIR}/etc/head.txt > ${TEMP_DIR}/${DOMAIN%.*}.nix &&
		    ls -1 ${TEMP_DIR}/${DOMAIN} | grep "[.]nix\$" | while read SUB
		    do
			echo "  ${SUB%.*} = (import ./${DOMAIN%.*}.d/${SUB%.*}.nix { inherit pkgs; });" >> ${TEMP_DIR}/${DOMAIN%.*}.nix
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
		${TEMP_DIR}/. \
		/etc/nixos/custom &&
	    true
    fi &&
    /run/wrappers/bin/sudo /run/current-system/sw/bin/nixos-rebuild switch &&
    true
