#!/bin/sh

docker container ls --quiet --all | while read CID
do
    docker container stop "${CID}" &&
	docker container rm "${CID}" &&
	true
done &&
    docker system prune --force --all --volumes &&
    true
