#!/bin/sh

chromium \
  --ppapi-flash-path="${FLASH_STORE}/libpepflashplayer.so" \
  --disable-gpu \
  --user-data-dir="${HOME}/data" &&
  true
