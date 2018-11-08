#!/bin/sh

if [ ! -f ${HOME}/.gconf.path ]
then
    cp ${STORE_DIR}/lib/gconf.path ${HOME}/.gconf.path &&
	gconftool-2 --shutdown &&
	true
fi &&
    true
