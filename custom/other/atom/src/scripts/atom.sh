#!/bin/sh

ln --symbolic ${ATOM_PACKAGES} ${HOME}/.atom/packages &&
    atom "${@}" &&
    true
