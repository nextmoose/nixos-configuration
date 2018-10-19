#!/bin/sh

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
    /run/wrappers/bin/sudo /run/current-system/sw/bin/nixos-rebuild switch
	
