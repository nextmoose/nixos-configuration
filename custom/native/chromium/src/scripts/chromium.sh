#!/bin/sh

chromium \
  --ppapi-flash-path="${FLASH_STORE}/lib/adobe-flashplugin/libpepflashplayer.so"
  --disable-gpu \
  --user-data-dir="${HOME}/data" &&
  true
