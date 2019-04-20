#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--canonical-system-remote)
	    CANONICAL_SYSTEM_REMOTE="${2}" &&
		shift 2 &&
		true
	    ;;
	--canonical-system-branch)
	    CANONICAL_SYSTEM_BRANCH="${2}" &&
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
	--origin-system-remote)
	    ORIGIN_SYSTEM_REMOTE="${2}" &&
		shift 2 &&
		true
	    ;;
	--origin-system-branch)
	    ORIGIN_SYSTEM_BRANCH="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unsupported Option &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 64 &&
		true
	    ;;
    esac &&
	true
done &&
    if [ -z "${CANONICAL_SYSTEM_REMOTE}" ]
    then
	echo Unspecified CANONICAL_SYSTEM_REMOTE &&
	    exit 64 &&
	    true
    elif [ -z "${CANONICAL_SYSTEM_BRANCH}" ]
    then
	echo Unspecified CANONICAL_SYSTEM_BRANCH &&
	    exit 64 &&
	    true
    elif [ -z "${COMMITTER_NAME}" ]
    then
	echo Unspecified COMMITTER_NAME &&
	    exit 64 &&
	    true
    elif [ -z "${COMMITTER_EMAIL}" ]
    then
	echo Unspecified COMMITTER_EMAIL &&
	    exit 64 &&
	    true
    elif [ -z "${ORIGIN_SYSTEM_REMOTE}" ]
    then
	echo Unspecified ORIGIN_SYSTEM_REMOTE &&
	    exit 64 &&
	    true
    elif [ -z "${ORIGIN_SYSTEM_BRANCH}" ]
    then
	echo Unspecified ORIGIN_SYSTEM_BRANCH &&
	    exit 64 &&
	    true
    fi &&
    if [ ! -d "${HOME}/.setup" ]
    then
	mkdir "${HOME}/.setup" &&
	    true
    fi &&
    if [ ! -f "${HOME}/.setup/flag" ]
    then
	mkdir "${HOME}/.setup/gnupg" &&
	    init-gnupg --gnupghome "${HOME}/.setup/gnupg" &&
	    mkdir "${HOME}/.setup/stores" &&
	    mkdir "${HOME}/.setup/stores/readonly" &&
	    mkdir "${HOME}/.setup/stores/readonly/system" &&
	    init-read-only-pass \
		--gnupghome "${HOME}/.setup/gnupg" \
		--password-store-dir "${HOME}/.setup/stores/readonly/system" \
		--remote "${CANONICAL_SYSTEM_REMOTE}" \
		--branch "${CANONICAL_SYSTEM_BRANCH}" &&
	    mkdir --parents "${HOME}/.ssh" &&
	    init-dot-ssh --dot-ssh "${HOME}/.ssh" &&
	    add-ssh-domain \
		--dot-ssh "${HOME}/.ssh" \
		--gnupghome "${HOME}/.setup/gnupg" \
		--password-store-dir "${HOME}/.setup/stores/readonly/system" \
		--domain upstream \
		--host github.com \
		--user git &&
	    add-ssh-domain \
		--dot-ssh "${HOME}/.ssh" \
		--gnupghome "${HOME}/.setup/gnupg" \
		--password-store-dir "${HOME}/.setup/stores/readonly/system" \
		--domain origin \
		--host github.com \
		--user git &&
	    add-ssh-domain \
		--dot-ssh "${HOME}/.ssh" \
		--gnupghome "${HOME}/.setup/gnupg" \
		--password-store-dir "${HOME}/.setup/stores/readonly/system" \
		--domain report \
		--host github.com \
		--user git &&
	    mkdir "${HOME}/.setup/stores/readwrite" &&
	    mkdir "${HOME}/.setup/stores/readwrite/system" &&
	    init-read-write-pass \
		--gnupghome "${HOME}/.setup/gnupg" \
		--password-store-dir "${HOME}/.setup/stores/readwrite/system" \
		--remote "${ORIGIN_SYSTEM_REMOTE}" \
		--branch "${ORIGIN_SYSTEM_BRANCH}" \
		--committer-name "${COMMITTER_NAME}" \
		--committer-email "${COMMITTER_EMAIL}" &&
	    true
    fi &&
    touch "${HOME}/.setup/flag" &&
    true
