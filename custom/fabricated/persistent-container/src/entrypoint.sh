#!/bin/sh

if [ ! -d "${HOME}/volumes" ]
then
    mkdir "${HOME}/volumes" &&
	true
fi &&
    if [ ! -d "${HOME}/volumes/${UUID}" ]
    then
	mkdir "${HOME}/volumes/${UUID}" &&
	    HOME="${HOME}/volumes/${UUID}" sh "${STORE_DIR}/run.sh" > "${HOME}/volumes/${UUID}.log.txt" 2>&1 &&
	    true
    fi &&
    HOME="${HOME}/volumes/${UUID}" sh "${STORE_DIR}/entrypoint.sh" ${@} &&
    true
