#!/bin/sh

mkdir "${HOME}/.ssh" &&
    chmod 0700 "${HOME}/.ssh" &&
    (cat > "${HOME}/.ssh/config" <<EOF
Include ${HOME}/.ssh/*.config
EOF
    ) &&
    chmod 0400 "${HOME}/.ssh/config" &&
    true
