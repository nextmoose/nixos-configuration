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
	    create-nixos-objects --root ${TEMP_DIR} &&
	    sudo \
		rsync \
		--verbose \
		--archive \
		--delete \
		${TEMP_DIR}/. \
		/etc/nixos/custom &&
	    true
    fi &&
    sudo nixos-rebuild switch &&
    true
