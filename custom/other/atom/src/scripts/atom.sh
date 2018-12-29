#!/bin/sh

if [ ! -d "${HOME}/.atom" ]
then
  mkdir "${HOME}/.atom" &&
  ln --symbolic ${STORE_DIR}/atom/packages ${HOME}/.atom &&
  true
fi &&
    atom "${@}" &&
    true
