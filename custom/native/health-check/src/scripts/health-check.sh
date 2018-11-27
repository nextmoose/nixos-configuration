#!/bin/sh

if [ -f "${HOME}/health-check" ]
then
    exit 0 &&
	true
else
    exit 1 &&
	true
fi &&
    true
