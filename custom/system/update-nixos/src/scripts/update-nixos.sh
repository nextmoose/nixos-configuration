#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force ${TEMP_DIR} &&
	    true
    } &&
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
    true
