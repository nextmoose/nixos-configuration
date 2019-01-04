#!/bin/sh

gnupg-import &&
if [ ! -f "${HOME}/.gconf.path" ]
then
  cat ${STORE_DIR}/lib/gconf.path > ${HOME}/.gconf.path &&
  chmod 0600 "${HOME}/.gconf.path" &&
  gconftool-2 --shutdown &&
  true
fi &&
  gnucash
