#!/bin/sh

mkdir "${HOME}/.ssh" &&
    chmod 0700 "${HOME}/.ssh" &&
    cat "${STORE_DIR}/lib/config" > "${HOME}/.ssh/config" &&
    chmod 0400 "${HOME}/.ssh/config" &&
    mkdir "${HOME}/.ssh/config.d" &&
    chmod 0700 "${HOME}/.ssh/config.d" &&
    git init &&
    git config user.name "${COMMITTER_NAME}" &&
    git config user.email "${COMMITTER_EMAIL}" &&
    git remote add upstream upstream://"${UPSTREAM_ORGANIZATION}"/"${UPSTREAM_REPOSITORY}".git &&
    git remote add origin origin://"${ORIGIN_ORGANIZATION}"/"${ORIGIN_REPOSITORY}".git &&
    git remote add report report://"${REPORT_ORGANIZATION}"/"${REPORT_REPOSITORY}".git &&
    bash &&
    true
