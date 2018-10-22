#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--upstream-host)
	    UPSTREAM_HOST="${2}" &&
		shift 2 &&
		true
	    ;;
	--upstream-user)
	    UPSTREAM_USER="${2}" &&
		shift 2 &&
		true
	    ;;
	--upstream-port)
	    UPSTREAM_PORT="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-host)
	    ORIGIN_HOST="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-user)
	    ORIGIN_USER="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-port)
	    ORIGIN_PORT="${2}" &&
		shift 2 &&
		true
	    ;;
	--report-host)
	    REPORT_HOST="${2}" &&
		shift 2 &&
		true
	    ;;
	--report-user)
	    REPORT_USER="${2}" &&
		shift 2 &&
		true
	    ;;
	--report-port)
	    REPORT_PORT="${2}" &&
		shift 2 &&
		true
	    ;;
	--committer-name)
	    COMMITTER_NAME="${2}" &&
		shift 2 &&
		true
	    ;;
	--committer-email)
	    COMMITTER_EMAIL="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unknown Option &&
		echo ${1} &&
		echo ${0} &&
		echo ${@} &&
		exit 64 &&
		true
	    ;;
    esac &&
	true
done &&
    (cat <<EOF
COMMITTER_NAME
COMMITTER_EMAIL
EOF
    ) | while read VAR
    do
	eval VAL=\${${VAR}} &&
	    if [ -z "${VAR}" ]
	    then
		echo Unspecified ${VAR} &&
		    exit 66 &&
		    true
	    fi &&
	    true
    done &&
    if [ ! -d ${HOME}/.gnupg ]
    then
	init-read-only-pass \
	    --upstream-url https://github.com/nextmoose/secrets.git \
	    --upstream-branch master \
	    &&
	    mkdir ${HOME}/.ssh &&
	    chmod 0700 ${HOME}/.ssh &&
	    (cat > ${HOME}/.ssh/config <<EOF
Include ${HOME}/.ssh/config.d/*
EOF
	    ) &&
	    mkdir ${HOME}/.ssh/keys &&
	    chmod 0700 ${HOME}/.ssh/keys &&
	    pass show upstream.id_rsa > ${HOME}/.ssh/keys/upstream.id_rsa &&
	    pass show origin.id_rsa > ${HOME}/.ssh/keys/origin.id_rsa &&
	    pass show report.id_rsa > ${HOME}/.ssh/report.id_rsa &&
	    mkdir ${HOME}/.ssh/known_hosts &&
	    chmod 0700 ${HOME}/.ssh/known_hosts &&
	    pass show upstream.known_hosts > ${HOME}/.ssh/known_hosts/upstream.known_hosts &&
	    pass show report.known_hosts > ${HOME}/.ssh/known_hosts/report.known_hosts &&
	    pass show origin.known_hosts > ${HOME}/.ssh/known_hosts/origin.known_hosts &&
	    mkdir ${HOME}/.ssh/config.d &&
	    chmod 0700 ${HOME}/.ssh/config.d &&
	    if [ ! -z "${UPSTREAM_HOST}" ] && [ ! -z "${UPSTREAM_USER}" ] && [ ! -z "${UPSTREAM_PORT}" ]
	    then
		(cat > ${HOME}/.ssh/config.d/upstream.config <<EOF
Host upstream
HostName ${UPSTREAM_HOST}
User ${UPSTREAM_USER}
Port ${UPSTREAM_PORT}
IdentityFile ${HOME}/.ssh/keys/upstream.id_rsa
UserKnownHostsFile ${HOME}/.ssh/known_hosts/upstream.known_hosts
EOF
		) &&
		    chmod 0600 ${HOME}/.ssh/config.d/upstream.config &&
		    true
	    fi &&
	    if [ ! -z "${ORIGIN_HOST}" ] && [ ! -z "${ORIGIN_USER}" ] && [ ! -z "${ORIGIN_PORT}" ]
	    then
		(cat > ${HOME}/.ssh/config.d/origin.config <<EOF
Host origin
HostName ${ORIGIN_HOST}
User ${ORIGIN_USER}
Port ${ORIGIN_PORT}
IdentityFile ${HOME}/.ssh/keys/origin.id_rsa
UserKnownHostsFile ${HOME}/.ssh/known_hosts/origin.known_hosts
EOF
		) &&
		    chmod 0600 ${HOME}/.ssh/config.d/origin.config &&
		    true
	    fi &&
	    if [ ! -z "${REPORT_HOST}" ] && [ ! -z "${REPORT_USER}" ] && [ ! -z "${REPORT_PORT}" ]
	    then
		(cat > ${HOME}/.ssh/config.d/report.config <<EOF
Host report
HostName ${REPORT_HOST}
User ${REPORT_USER}
Port ${REPORT_PORT}
IdentityFile ${HOME}/.ssh/keys/report.id_rsa
UserKnownHostsFile ${HOME}/.ssh/known_hosts/report.known_hosts
EOF
		) &&
		    chmod 0600 ${HOME}/.ssh/config.d/report.config &&
		    true
	    fi &&
	    chmod 0600 ${HOME}/.ssh/config &&
	    chmod 0600 ${HOME}/.ssh/upstream.id_rsa &&
	    chmod 0600 ${HOME}/.ssh/upstream.known_hosts &&
	    chmod 0600 ${HOME}/.ssh/origin.id_rsa &&
	    chmod 0600 ${HOME}/.ssh/origin.known_hosts &&
	    chmod 0600 ${HOME}/.ssh/report.id_rsa &&
	    chmod 0600 ${HOME}/.ssh/report.known_hosts &&
	    true &&
    fi &&
    true
