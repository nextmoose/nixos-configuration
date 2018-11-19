#!/bin/sh

if [ -z "$(docker image ls --filter reference=${@} --quiet)" ]
then
    echo YES &&
	cat "${STORE_DIR}/lib/${@}.tar.gz" | docker image load &&
	true
else
    echo NO &&
	true
fi &&
    true
