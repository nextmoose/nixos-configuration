#!/bin/sh

echo AA &&
pass "${SYSTEM_SECRETS_READ_ONLY_PASS_CONTAINER_UUID}" ${@} &&
    true
