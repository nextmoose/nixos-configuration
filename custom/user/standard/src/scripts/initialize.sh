#!/bin/sh

cat "${STORE_DIR}/lib/emacs.tar.gz" | docker image load &&
    true
