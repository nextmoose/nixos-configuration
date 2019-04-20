#!/bin/sh

export GNUPGHOME="${HOME}/.setup/gnupg" &&
    export PASSWORD_STORE_DIR="${HOME}/.setup/stores/readwrite/challenge" &&
    pass "${@}" &&
    true
