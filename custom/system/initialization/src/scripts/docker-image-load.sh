#!/bin/sh

if [ -z "$(docker image ls --filter reference=${@})" ]
then
    cat "${STORE_DIR}/${@}.tar.gz" | docker image load &&
	true
fi &&
    true
