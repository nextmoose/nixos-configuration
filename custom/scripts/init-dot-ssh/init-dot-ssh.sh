#!/bin/sh

if [ ! -d "${HOME}/.ssh" ]
   mkdir "${HOME}/.ssh" &&
       chmod 0700 "${HOME}/.ssh" &&
       sed \
	   -e "s#\${HOME}#${HOME}#" \
	   -e "w${HOME}/.ssh/config" \
	   "${STORE_DIR}/src/config" &&
       chmod 0400 "${HOME}/.ssh/config" &&
       true
fi &&
       true
