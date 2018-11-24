#!/bin/sh

kafka-server-start.sh "${STORE_DIR}/lib/server.conf" &&
    true
