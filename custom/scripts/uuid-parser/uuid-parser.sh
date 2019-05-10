#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--domain)
	    DOMAIN="${2}" &&
		shift 2 &&
		true
	    ;;
	--key)
	    KEY="${2}" &&
		shift 2 &&
		true
	    ;;
	--data-file)
	    DATA_FILE="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unsupported Options &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 64 &&
		true
	    ;;
    esac &&
	true
done &&
    if [ -z "${DOMAIN}" ]
    then
	echo Unspecified DOMAIN &&
	    exit 64 &&
	    true
    elif [ -z "${KEY}" ]
    then
	echo Unspecified KEY &&
	    exit 64 &&
	    true
    elif [ -z "${DATA_FILE}" ]
    then
	echo Unspecified DATA_FILE &&
	    exit 64 &&
	    true
    elif [ ! -f "${DATA_FILE}" ]
    then
	echo Nonexistant DATA_FILE "${DATA_FILE}" &&
	    exit 64 &&
	    true
    fi &&
    WORK_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    (cat > ${WORK_DIR}/query.js <<EOF
.["${DOMAIN}"]["${KEY}"]
EOF
    ) &&
    jq -r --from-file "${WORK_DIR}/query.js" "${DATA_FILE}" &&
    true
