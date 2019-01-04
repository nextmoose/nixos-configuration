#!/bin/sh

chromium \
  --ppapi-flash-path="${STORE_DIR}/lib/adobe-flashplugin/libpepflashplayer.so" \
  --disable-gpu \
  --user-data-dir="${HOME}/data" &&
  true
