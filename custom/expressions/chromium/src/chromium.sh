#!/bin/sh

chromium --disable-gpu --user-data-dir=/home/user --ppapi-flash-path="${STORE_DIR}/lib/adobe-flashplugin/libpepflashplayer.so" "${@}" &&
    true
