#!/bin/sh

echo BB ${@} &&
    UUID="${1}" &&
    echo BB ${UUID} &&
    echo BB $(docker-container-id ${UUID}) &&
    shift &&
    docker \
	container \
	exec \
	--interactive \
	--tty \
	$(docker-container-id "${UUID}") \
	pass \
	${@} &&
    true
