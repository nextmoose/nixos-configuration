#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	list)
	    sudo nixos-container list &&
		shift "${#}" &&
		true
	    ;;
	start)
	    sudo nixos-container "${@}" &&
		shift "${#}" &&
		true
	    ;;
	stop)
	    sudo nixos-container "${@}" &&
		shift "${#}" &&
		true
	    ;;
	restart)
	    shift &&
		sudo nixos-container stop "${@}" &&
		sudo nixos-container start "${@}" &&
		shift "${#}" &&
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
		shift "${#}" &&
		true
	    ;;
	*)
	    nixos-container --help &&
		shift "${#}" &&
		true
	;;
    esac
    true
done &&
    true
