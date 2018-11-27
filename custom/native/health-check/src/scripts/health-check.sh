#!/bin/sh

if [ -f "${HOME}/health-check" ]
then
    echo 0 &&
	exit 0 &&
	true
    else
	echo 1 &&
	    exit 1 &&
	    true
fi &&
    true
