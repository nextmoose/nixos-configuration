#!/bin/sh

mkdir "${HOME}/.npm-packages" &&
  NPMRC_PATCH="prefix=${HOME}/.npm-packages" &&
  if [ -f "${HOME}/.npmrc" ]
  then
    if [ -z "$(grep '${NPMRC_PATCH}' ${HOME}/.npmrc)" ]
    then
      echo "${NPMRC_PATCH}" >> "${HOME}/.npmrc" &&
        true
    fi &&
      true
  else
    echo "${NPMRC_PATCH}" > "${HOME}/.npmrc" &&
      true
  fi &&
  npm install -g "${@}" &&
  mkdir --parents "${HOME}/bin" &&
  ln --symbolic --force ${HOME}/.npm-packages/bin/* "${HOME}/bin"
  true
