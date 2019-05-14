#!/bin/sh

if [ ! -d "${HOME}" ]
then
    mkdir "${HOME}" &&
	${RUN} &&
	true
fi &&
    ${ENTRYPOINT} ${@} &&
    true
