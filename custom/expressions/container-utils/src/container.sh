#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	list)
	    sudo nixos-container list &&
		true
	    ;;
	start)
	    sudo nixos-container "${@}" &&
		true
	    ;;
	stop)
	    sudo nixos-container "${@}" &&
		true
	    ;;
	restart)
	    shift &&
		sudo nixos-container stop "${@}" &&
		sudo nixos-container start "${@}" &&
		true
	    ;;
	login)
	    shift &&
		if [ "up" != $(sudo nixos-container status "${@}") ]
		then
		    sudo nixos-container start "${@}" &&
			true
		fi &&
		sudo nixos-container login "${@}" &&
		true
	    ;;
	*)
	    nixos-container --help &&
		true
	;;
    esac
    true
done &&
    true
