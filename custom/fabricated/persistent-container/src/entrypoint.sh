#!/bin/sh

if [ ! -d "${HOME}/volumes" ]
then
    mkdir "${HOME}/volumes" &&
	true
fi &&
    if [ ! -d "${HOME}/volumes/${UUID}" ]
    then
	mkdir "${HOME}/volumes/${UUID}" &&
	    HOME="${HOME}/volumes/${UUID}" ${RUN} &&
	    true
    fi &&
    HOME="${HOME}/volumes/${UUID}" ${ENTRYPOINT} ${@} &&
    true
