#!/bin/sh

echo BB ${@} $(docker-container-id ${1}) &&
UUID="${1}" &&
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
