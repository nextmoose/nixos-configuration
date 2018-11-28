#!/bin/sh

addsshhost() {
    DOMAIN="${1}" &&
	HOST="${2}" &&
	USER="${3}" &&
	PORT="${4}" &&
	ID_RSA="${5}" &&
	KNOWN_HOSTS="${6}" &&
	if
	    [ ! -z "${DOMAIN}" ] &&
		[ ! -z "${HOST}" ] &&
		[ ! -z "${USER}" ] &&
		[ ! -z "${PORT}" ] &&
		[ ! -z "${ID_RSA}" ] &&
		[ ! -z "${KNOWN_HOSTS}" ]
	then
	    (cat > "${HOME}/.ssh/${DOMAIN}.conf" <<EOF
Host ${DOMAIN}
HostName ${HOST}
User ${USER}
Port ${PORT}
IdentityFile ${HOME}/.ssh/${DOMAIN}.id_rsa
UserKnownHostsFile ${HOME}/.ssh/${DOMAIN}.known_hosts
EOF
	    ) &&
		echo "${ID_RSA}" > "${HOME}/.ssh/${DOMAIN}.id_rsa" &&
		echo "${KNOWN_HOSTS}" > "${HOME}/.ssh/${DOMAIN}.known_hosts" &&
		chmod \
		    0400 \
		    "${HOME}/.ssh/${DOMAIN}.conf" \
		    "${HOME}/.ssh/${DOMAIN}.id_rsa" \
		    "${HOME}/.ssh/${DOMAIN}.known_hosts" &&
		true
	fi &&
	true
} &&
    mkdir "${HOME}/.ssh" &&
    chmod 0700 "${HOME}/.ssh" &&
    (cat > "${HOME}/.ssh/config" <<EOF
Include ${HOME}/.ssh/upstream.conf
Include ${HOME}/.ssh/origin.conf
Include ${HOME}/.ssh/report.conf
EOF
    ) &&
    chmod 0400 "${HOME}/.ssh/config" &&
    addsshhost upstream "${UPSTREAM_HOST}" "${UPSTREAM_USER}" "${UPSTREAM_PORT}" "${UPSTREAM_ID_RSA}" "${UPSTREAM_KNOWN_HOSTS}" &&
    addsshhost origin "${ORIGIN_HOST}" "${ORIGIN_USER}" "${ORIGIN_PORT}" "${ORIGIN_ID_RSA}" "${ORIGIN_KNOWN_HOSTS}" &&
    addsshhost report "${REPORT_HOST}" "${REPORT_USER}" "${REPORT_PORT}" "${REPORT_ID_RSA}" "${REPORT_KNOWN_HOSTS}" &&
    true
