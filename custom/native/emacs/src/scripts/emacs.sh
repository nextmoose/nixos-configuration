#!/bin/sh

cleanup() {
    bash &&
	true
} &&
    trap cleanup EXIT &&
    echo AAA 00100 &&
    gpg --batch --import "${SECRETS_DIR}/lib/gpg.secret.key" &&
    echo AAA 00200 &&
    gpg2 --import "${SECRETS_DIR}/lib/gpg2.secret.key" &&
    echo AAA 00300 &&
    gpg --import-ownertrust "${SECRETS_DIR}/lib/gpg.owner.trust" &&
    echo AAA 00400 &&
    gpg2 --import-ownertrust "${SECRETS_DIR}/lib/gpg2.owner.trust" &&
    echo AAA 00500 &&
    echo ALPHA &&
    pass init $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
    pass git init &&
    pass git remote add canonical "https://${CANONICAL_HOST}/${CANONICAL_ORGANIZATION}/${CANONICAL_REPOSITORY}.git" &&
    pass git remote set-url --push canonical no_push &&
    GIT_SSL_NO_VERIFY=true pass git fetch canonical "${CANONICAL_BRANCH}" &&
    pass git checkout "canonical/${CANONICAL_BRANCH}" &&
    mkdir "${HOME}/.ssh" &&
    (cat > "${HOME}/.ssh/config" <<EOF
Host origin
HostName ${ORIGIN_HOST}
User ${ORIGIN_USER}
Port ${ORIGIN_PORT}
IdentityFile ${HOME}/.ssh/origin.id_rsa
UserKnownHostsFile ${HOME}/.ssh/origin.known_hosts
EOF
    ) &&
    echo AAA 00600 &&
    pass show origin.id_rsa > "${HOME}/.ssh/origin.id_rsa" &&
    echo AAA 00700 &&
    pass show origin.known_hosts > "${HOME}/.ssh/origin.known_hosts" &&
    chmod 0400 "${HOME}/.ssh/config" "${HOME}/.ssh/origin.id_rsa" "${HOME}/.ssh/origin.known_hosts" &&
    mkdir "${HOME}/project" &&
    git -C "${HOME}/project" init &&
    git -C "${HOME}/project" config user.name "${COMMIITTER_NAME}" &&
    git -C "${HOME}/project" config user.email "${COMMIITTER_EMAIL}" &&
    git -C "${HOME}/project" remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
    git -C "${HOME}/project" fetch origin "${ORIGIN_BRANCH}" &&
    git -C "${HOME}/project" checkout "${ORIGIN_BRANCH}" &&
    emacs "${HOME}/project" &&
    true
