#!/bin/sh

chromium $(jq --raw-output ".[\"${@}\"]" "${STORE_DIR}/configuration.json")/log.html &&
    true
