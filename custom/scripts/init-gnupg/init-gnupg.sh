#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--gnupghome)
	    GNUPGHOME="${2}" &&
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
    if [ -z "${GNUPGHOME}" ]
    then
	echo Unspecified GNUPGHOME &&
	    exit 64 &&
	    true
    elif [ ! -d "${GNUPGHOME}" ]
    then
	echo "Specified GNUPGHOME=${GNUPGHOME} does not exist" &&
	    exit 64 &&
	    true
    fi &&
    WORK_DIR="$(mktemp -d)" &&
    cleanup(){
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    pass show private.gpg > "${WORK_DIR}/private.gpg.asc" &&
    pass show private.gpg2 > "${WORK_DIR}/private.gpg2.asc" &&
    pass show ownertrust.gpg > "${WORK_DIR}/ownertrust.gpg.asc" &&
    pass show ownertrust.gpg2 > "${WORK_DIR}/ownertrust.gpg2.asc" &&
    gpg --homedir "${GNUPGHOME}" --batch --import "${WORK_DIR}/private.gpg.asc" &&
    gpg --homedir "${GNUPGHOME}" --import "${WORK_DIR}/private.gpg2.asc" &&
    gpg --homedir "${GNUPGHOME}" --import-ownertrust "${WORK_DIR}/ownertrust.gpg.asc" &&
    gpg2 --homedir "${GNUPGHOME}" --import-ownertrust "${WORK_DIR}/ownertrust.gpg2.asc" &&
    true
