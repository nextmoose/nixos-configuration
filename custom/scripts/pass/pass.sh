#!/bin/sh

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
