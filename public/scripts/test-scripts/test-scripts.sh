#!/bin/sh

jq "." "${STORE_DIR}/configuration.json" &&
    true
