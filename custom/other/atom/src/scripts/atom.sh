#!/bin/sh

if [ ! -d "${HOME}/.atom" ]
then
  mkdir "${HOME}/.atom" &&
  (cat > ~/.atom/config.cson <<EOF
"*":
  core:
    telemetryConsent: "no"
  welcome:
    showOnStartup: false
EOF
  ) &&
  cp --recursive ${STORE_DIR}/atom/packages ${HOME}/.atom &&
  true
fi &&
    atom "${@}" &&
    true
