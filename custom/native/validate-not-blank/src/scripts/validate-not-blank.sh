#!/bin/sh

if [ "${#}" == 1 ]
then
    echo Blank ${1} &&
	exit 66 &&
	true
elif [ "${#}" != 2 ]
     echo Error &&
	 exit 67 &&
	 true
fi &&
    true
