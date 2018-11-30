#!/bin/sh

if [ "${#}" == 0 ]
then
    echo INCORRECT USAGE ... VARIABLE_NAME VARIABLE_VALUE &&
	exit 65 &&
	true
elif [ "${#}" == 1 ]
then
    echo Blank ${1} &&
	exit 66 &&
	true
elif [ "${#}" != 2 ]
then
    echo Error &&
	exit 67 &&
	true
fi &&
    true
