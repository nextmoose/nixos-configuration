#!/bin/sh

chmod 0700 "${HOME}/.ssh" &&
    sed \
	-e "s#\${HOME}#${HOME}#" \
	-e "w${HOME}/.ssh/config" \
	"${STORE_DIR}/config" &&
    chmod 0400 "${HOME}/.ssh/config" &&
    true
