#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--remote)
	    REMOTE="${2}" &&
		shift 2 &&
		true
	    ;;
	--branch)
	    BRANCH="${2}" &&
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
		--remote "${REMOTE}" \
		--branch "${BRANCH}" &&
	    mkdir "${HOME}/.setup/dot_ssh" &&
	    init-dot-ssh --dot-ssh "${HOME}/.setup/dot_ssh" &&
	    mkdir "${HOME}/.setup/stores/readwrite" &&
	    mkdir "${HOME}/.setup/stores/readwrite/system" &&
	    true
    fi &&
    touch "${HOME}/.setup/flag" &&
    true
