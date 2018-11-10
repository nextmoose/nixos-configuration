#!/bin/sh

cat ${IMAGE} | docker image load &&
    docker \
	container \
	run \
	--interactive \
	--tty \
	--rm \
	--env COMMITTER_NAME="Emory Merryman" \
	--env COMMITER_EMAIL="emory.merryman@gmail.com" \
	development &&
    true
