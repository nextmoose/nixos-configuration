#!/bin/sh

while [ $(docker container inspect --format "{{}}" "${CONTAINER}") != 0 ]
do
    sleep "${SLEEP}" &&
	true
done &&
    true
