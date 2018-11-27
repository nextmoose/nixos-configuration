#!/bin/sh

mkdir "${HOME}/.ssh" &&
    mkdir "${HOME}/.ssh/config.d" &&
    chmod 0700 "${HOME}/.ssh" "${HOME}/.ssh/config.d" &&
    (cat > "${HOME}/.ssh/config" <<EOF
Include ${HOME}/.ssh/config.d
EOF
    ) &&
    if [ ! -z "${ORIGIN_HOST}" ] && [ ! -z "${ORIGIN_USER}" ] && [ ! -z "${ORIGIN_PORT}" ] && [ ! -z "${ORIGIN_ID_RSA}" ] && [ ! -z "${ORIGIN_KNOWN_HOSTS}" ]
    then
	(cat > "${HOME}/.ssh/config.d/origin.config" <<EOF
Host origin
HostName ${ORIGIN_HOST}
User ${ORIGIN_USER}
Port ${ORIGIN_PORT}
IdentityFile ${HOME}/.ssh/origin.id_rsa
UserKnownHostsFile ${HOME}/.ssh/origin.known_hosts
EOF
	) &&
	    echo "${ORIGIN_ID_RSA}" > "${HOME}/.ssh/origin.id_rsa" &&
	    echo "${ORIGIN_KNOWN_HOSTS}" > "${HOME}/.ssh/origin.known_hosts" &&
	    chmod 0400 "${HOME}/.ssh/origin.id_rsa" "${HOME}/.ssh/origin.known_hosts" &&
	    true
    fi &&
    true
