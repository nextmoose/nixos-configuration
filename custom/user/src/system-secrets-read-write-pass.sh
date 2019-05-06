#!/bin/sh

pass "${SYSTEM_SECRETS_READ_WRITE_PASS_CONTAINER_UUID}" ${@} &&
    true
