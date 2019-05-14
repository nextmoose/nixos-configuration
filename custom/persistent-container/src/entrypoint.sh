#!/bin/sh

if [ ! -d "${HOME}" ]
then
    mkdir --parents "${HOME}" &&
	${RUN} &&
	true
fi &&
    ${ENTRYPOINT} ${@} &&
    true
