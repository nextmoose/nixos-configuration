#!/bin/sh

cleanup() {
    if [ -d "${HOME}/project" ]
    then
	git -C "${HOME}/project" curt &&
	    true
    fi &&
	true
} &&
    trap cleanup EXIT &&
    mkdir "${HOME}/.ssh" &&
    chmod 0700 "${HOME}/.ssh" &&
    cat "${STORE_DIR}/lib/config" > "${HOME}/.ssh/config" &&
    chmod 0400 "${HOME}/.ssh/config" &&
    mkdir "${HOME}/.ssh/config.d" "${HOME}/.ssh/keys" "${HOME}/.ssh/known_hosts" &&
    chmod 0700 "${HOME}/.ssh/config.d" "${HOME}/.ssh/keys" "${HOME}/.ssh/known_hosts" &&
    mkdir "${HOME}/project" &&
    git -C "${HOME}/project" init &&
    git -C "${HOME}/project" config user.name "${COMMITTER_NAME}" &&
    git -C "${HOME}/project" config user.email "${COMMITTER_EMAIL}" &&
    git -C "${HOME}/project" config --global user.signingkey $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
    if [ ! -z "${UPSTREAM_HOST}" ] && [ ! -z "${UPSTREAM_PORT}" ] && [ ! -z "${UPSTREAM_USER}" ] && [ ! -z "${UPSTREAM_ID_RSA}" ] && [ ! -z "${UPSTREAM_KNOWN_HOSTS}" ] && [ ! -z "${UPSTREAM_ORGANIZATION}" ] && [ ! -z "${UPSTREAM_REPOSITORY}" ]
    then
	(cat > "${HOME}/.ssh/config.d/upstream.config" <<EOF
Host upstream
HostName ${UPSTREAM_HOST}
Port ${UPSTREAM_PORT}
User ${UPSTREAM_USER}
IdentityFile ${HOME}/.ssh/keys/upstream.id_rsa
UserKnownHostsFile ${HOME}/.ssh/known_hosts/upstream.known_hosts
EOF
	) &&
	    echo "${UPSTREAM_ID_RSA}" > "${HOME}/.ssh/keys/upstream.id_rsa" &&
	    echo "${UPSTREAM_KNOWN_HOSTS}" > "${HOME}/.ssh/known_hosts/upstream.known_hosts" &&
	    chmod 0400 "${HOME}/.ssh/config.d/upstream.config" "${HOME}/.ssh/keys/upstream.id_rsa" "${HOME}/.ssh/known_hosts/upstream.known_hosts" &&
	    git -C "${HOME}/project" remote add upstream upstream:"${UPSTREAM_ORGANIZATION}"/"${UPSTREAM_REPOSITORY}".git &&
	    git -C "${HOME}/project" remote set-url --push upstream no_push &&
	    if [ ! -z "${UPSTREAM_BRANCH}" ]
	    then
		git -C "${HOME}/project" fetch upstream "${UPSTREAM_BRANCH}" &&
		    git -C "${HOME}/project" checkout "upstream/${UPSTREAM_BRANCH}" &&
		    true
	    fi &&
	    true
    fi &&
    if [ ! -z "${ORIGIN_HOST}" ] && [ ! -z "${ORIGIN_PORT}" ] && [ ! -z "${ORIGIN_USER}" ] && [ ! -z "${ORIGIN_ID_RSA}" ] && [ ! -z "${ORIGIN_KNOWN_HOSTS}" ] && [ ! -z "${ORIGIN_ORGANIZATION}" ] && [ ! -z "${ORIGIN_REPOSITORY}" ]
    then
	(cat > "${HOME}/.ssh/config.d/origin.config" <<EOF
Host origin
HostName ${ORIGIN_HOST}
Port ${ORIGIN_PORT}
User ${ORIGIN_USER}
IdentityFile ${HOME}/.ssh/keys/origin.id_rsa
UserKnownHostsFile ${HOME}/.ssh/known_hosts/origin.known_hosts
EOF
	) &&
	    echo "${ORIGIN_ID_RSA}" > "${HOME}/.ssh/keys/origin.id_rsa" &&
	    echo "${ORIGIN_KNOWN_HOSTS}" > "${HOME}/.ssh/known_hosts/origin.known_hosts" &&
	    chmod 0400 "${HOME}/.ssh/config.d/origin.config" "${HOME}/.ssh/keys/origin.id_rsa" "${HOME}/.ssh/known_hosts/origin.known_hosts" &&
	    git -C "${HOME}/project" remote add origin origin:"${ORIGIN_ORGANIZATION}"/"${ORIGIN_REPOSITORY}".git &&
	    if [ -z "${ORIGIN_BRANCH}" ]
	    then
		git -C "${HOME}/project" checkout -b scratch/$(uuidgen) &&
		    true
	    else
		(
		    (git -C "${HOME}/project" fetch origin "${ORIGIN_BRANCH}" && git -C "${HOME}/project" checkout "${ORIGIN_BRANCH}" && true) ||
			(git -C "${HOME}/project" checkout -b "${ORIGIN_BRANCH}" && true)
		) &&
		    true
	    fi &&
	    true
    fi &&
    if [ ! -z "${REPORT_HOST}" ] && [ ! -z "${REPORT_PORT}" ] && [ ! -z "${REPORT_USER}" ] && [ ! -z "${REPORT_ID_RSA}" ] && [ ! -z "${REPORT_KNOWN_HOSTS}" ] && [ ! -z "${REPORT_ORGANIZATION}" ] && [ ! -z "${REPORT_REPOSITORY}" ]
    then
	(cat > "${HOME}/.ssh/config.d/report.config" <<EOF
Host report
HostName ${REPORT_HOST}
Port ${REPORT_PORT}
User ${REPORT_USER}
IdentityFile ${HOME}/.ssh/keys/report.id_rsa
UserKnownHostsFile ${HOME}/.ssh/known_hosts/report.known_hosts
EOF
	) &&
	    echo "${REPORT_ID_RSA}" > "${HOME}/.ssh/keys/report.id_rsa" &&
	    echo "${REPORT_KNOWN_HOSTS}" > "${HOME}/.ssh/known_hosts/report.known_hosts" &&
	    chmod 0400 "${HOME}/.ssh/config.d/report.config" "${HOME}/.ssh/keys/report.id_rsa" "${HOME}/.ssh/known_hosts/report.known_hosts" &&
	    git -C "${HOME}/project" remote add report report:"${REPORT_ORGANIZATION}"/"${REPORT_REPOSITORY}".git &&
	    true
    fi &&
    ln --symbolic --force "${STORE_DIR}/scripts/post-commit" "${STORE_DIR}/scripts/pre-push" "${HOME}/project/.git/hooks" &&
    bash &&
    true
