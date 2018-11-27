#!/bin/sh

ls -alh "${HOME}" &&
    if [ -f "${HOME}/health-check" ]
    then
	echo "IS HEALTHY" &&
	    exit 0 &&
	    true
    else
	echo "IS NOT HEALTHY YET" &&
	    exit 1 &&
	    true
    fi &&
    true
