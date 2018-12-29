#!/bin/sh

echo ln --symbolic ${ATOM_PACKAGES} ${HOME}/.atom/packages &&
    atom "${@}" &&
    true
