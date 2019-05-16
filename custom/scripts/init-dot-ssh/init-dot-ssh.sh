#!/bin/sh

mkdir "${HOME}/.ssh" &&
    chmod 0700 "${HOME}/.ssh" &&
    sed \
	-e "s#\${HOME}#${HOME}#" \
	-e "w${HOME}/.ssh/config" \
	"${SOURCE_DIR}/config" &&
    chmod 0400 "${HOME}/.ssh/config" &&
    true
