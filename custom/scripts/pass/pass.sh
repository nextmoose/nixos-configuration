#!/bin/sh

UUID="${1}" &&
    shift &&
    docker \
	container \
	run \
	--interactive \
	--tty \
	$(docker-container-id "${UUID}") \
	pass \
	${@} &&
    true
