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
	--upstream-organization)
	    UPSTREAM_ORGANIZATION="${2}" &&
		shift 2 &&
		true
	    ;;
	--upstream-repository)
	    UPSTREAM_REPOSITORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--upstream-repository)
	    UPSTREAM_REPOSITORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--upstream-branch)
	    UPSTREAM_BRANCH="${2}" &&
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
	--origin-organization)
	    ORIGIN_ORGANIZATION="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-repository)
	    ORIGIN_REPOSITORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-repository)
	    ORIGIN_REPOSITORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-branch)
	    ORIGIN_BRANCH="${2}" &&
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
	--report-organization)
	    REPORT_ORGANIZATION="${2}" &&
		shift 2 &&
		true
	    ;;
	--report-repository)
	    REPORT_REPOSITORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--report-repository)
	    REPORT_REPOSITORY="${2}" &&
		shift 2 &&
		true
	    ;;
	--report-branch)
	    REPORT_BRANCH="${2}" &&
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
    init-read-only-pass \
	--upstream-url https://github.com/nextmoose/secrets.git \
	--upstream-branch master \
	&&
	mkdir --parents ${HOME}/.ssh &&
	chmod 0700 ${HOME}/.ssh &&
	(cat > ${HOME}/.ssh/config <<EOF
Include ${HOME}/.ssh/config.d/upstream.config
Include ${HOME}/.ssh/config.d/origin.config
Include ${HOME}/.ssh/config.d/report.config
EOF
	) &&
	pass show upstream.id_rsa > ${HOME}/.ssh/upstream.id_rsa &&
	pass show upstream.known_hosts > ${HOME}/.ssh/upstream.known_hosts &&
	pass show origin.id_rsa > ${HOME}/.ssh/origin.id_rsa &&
	pass show origin.known_hosts > ${HOME}/.ssh/origin.known_hosts &&
	pass show report.id_rsa > ${HOME}/.ssh/report.id_rsa &&
	pass show report.known_hosts > ${HOME}/.ssh/report.known_hosts &&
	if [ ! -z "${UPSTREAM_HOST}" ] && [ ! -z "${UPSTREAM_USER}" ] && [ ! -z "${UPSTREAM_PORT}" ]
	then
	    (cat > ${HOME}/.ssh/upstream.config <<EOF
Host upstream
HostName ${UPSTREAM_HOST}
User ${UPSTREAM_USER}
Port ${UPSTREAM_PORT}
IdentityFile ${HOME}/.ssh/upstream.id_rsa
UserKnownHostsFile ${HOME}/.ssh/upstream.known_hosts
EOF
	    ) &&
		chmod 0600 ${HOME}/.ssh/upstream.config &&
		true
	fi &&
	if [ ! -z "${ORIGIN_HOST}" ] && [ ! -z "${ORIGIN_USER}" ] && [ ! -z "${ORIGIN_PORT}" ]
	then
	    (cat > ${HOME}/.ssh/origin.config <<EOF
Host origin
HostName ${ORIGIN_HOST}
User ${ORIGIN_USER}
Port ${ORIGIN_PORT}
IdentityFile ${HOME}/.ssh/origin.id_rsa
UserKnownHostsFile ${HOME}/.ssh/origin.known_hosts
EOF
	    ) &&
		chmod 0600 ${HOME}/.ssh/origin.config &&
		true
	fi &&
	if [ ! -z "${REPORT_HOST}" ] && [ ! -z "${REPORT_USER}" ] && [ ! -z "${REPORT_PORT}" ]
	then
	    (cat > ${HOME}/.ssh/report.config <<EOF
Host report
HostName ${REPORT_HOST}
User ${REPORT_USER}
Port ${REPORT_PORT}
IdentityFile ${HOME}/.ssh/report.id_rsa
UserKnownHostsFile ${HOME}/.ssh/report.known_hosts
EOF
	    ) &&
		chmod 0600 ${HOME}/.ssh/report.config &&
		true
	fi &&
	chmod 0600 ${HOME}/.ssh/config &&
	chmod 0600 ${HOME}/.ssh/upstream.id_rsa &&
	chmod 0600 ${HOME}/.ssh/upstream.known_hosts &&
	chmod 0600 ${HOME}/.ssh/origin.id_rsa &&
	chmod 0600 ${HOME}/.ssh/origin.known_hosts &&
	chmod 0600 ${HOME}/.ssh/report.id_rsa &&
	chmod 0600 ${HOME}/.ssh/report.known_hosts &&
	mkdir ${HOME}/project &&
	git -C ${HOME}/project init &&
	git -C ${HOME}/project config user.name "${COMMITTER_NAME}" &&
	git -C ${HOME}/project config user.email "${COMMITTER_EMAIL}" &&
	git -C ${HOME}/project remote add upstream "upstream:${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git" &&
	git -C ${HOME}/project set-url --push upstream no_push &&
	git -C ${HOME}/project remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
	git -C ${HOME}/project remote add report "report:${REPORT_ORGANIZATION}/${REPORT_REPOSITORY}.git" &&
	git -C ${HOME}/project fetch upstream "${UPSTREAM_BRANCH}" &&
	git -C ${HOME}/project checkout "${ORIGIN_BRANCH}" &&
	if [ ! -z "${UPSTREAM_HOST}" ] && [ ! -z "${UPSTREAM_USER}" ] && [ ! -z "${UPSTREAM_PORT}" ] && [ ! -z "${UPSTREAM_ORGANIZATION}" ] && [ ! -z "${UPSTREAM_REPOSITORY}" ] && [ ! -z "${UPSTREAM_BRANCH}" ]
	then
	    git -C ${HOME}/project fetch upstream "${UPSTREAM_BRANCH}" &&
		git -C ${HOME}/project checkout "upstream/${UPSTREAM_BRANCH}" &&
		true
	fi &&
	if [ ! -z "${ORIGIN_HOST}" ] && [ ! -z "${ORIGIN_USER}" ] && [ ! -z "${ORIGIN_PORT}" ] && [ ! -z "${ORIGIN_ORGANIZATION}" ] && [ ! -z "${ORIGIN_REPOSITORY}" ] && [ ! -z "${ORIGIN_BRANCH}" ]
	then
	    (
		git -C ${HOME}/project fetch origin "${ORIGIN_BRANCH}" &&
		    git -C ${HOME}/project checkout "${ORIGIN_BRANCH}" &&
		    true
	    ) ||
		true
	fi &&
	ln $(which post-commit) ${HOME}/project/.git/hooks &&
	ln $(which pre-push) ${HOME}/project/.git/hooks &&
	true
