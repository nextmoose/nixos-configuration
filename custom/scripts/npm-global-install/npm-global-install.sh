#!/bin/sh

mkdir "${HOME}/.npm-packages" &&
  NPMRC_PATCH="prefix=${HOME}/.npm-packages" &&
  if [ -f "${HOME}/.npmrc" ]
  then
    if [ -z "$(grep '${NPMRC_PATCH}' ${HOME}/.npmrc)" ]
    then
      cat "${NPMRC_PATCH}" >> "${HOME}/.npmrc" &&
        true
    fi &&
      true
  else
    cat "${NPMRC_PATCH}" > "${HOME}/.npmrc" &&
      true
  fi &&
  mkdir --parents "${HOME}/bin" &&
  ln --symbolic "${HOME}/.npm-packages/bin/*" "${HOME}/bin"
  true
