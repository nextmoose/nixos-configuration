#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--canonical-remote)
	    CANONICAL_REMOTE="${2}" &&
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
		exit 64
	    ;;
    esac &&
	true
done &&
    TEMP_DIR=$(mktemp -d) &&
    cleanup() {
	if [ -d "${WORK_DIR}/backup" ]
	then
	    /run/wrappers/bin/sudo \
		rsync \
		--archive \
		--delete \
		"${TEMP_DIR}/bacup/configuration.nix" \
		"/etc/nixos" &&
		/run/wrappers/bin/sudo \
		    rsync \
		    --archive \
		    --delete \
		    "${TEMP_DIR}/backup/custom" \
		    "/etc/nixos" &&
		export PATH=/run/wrappers/bin:/run/current-system/sw/bin:$(dirname $(which systemctl)):$(dirname $(which grep)) &&
		sudo nixos-rebuild switch &&
		true
	fi &&
	    rm --recursive --force "${TEMP_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    sh "${STORE_DIR}/src/configure-nixos.sh" \
	--canonical-remote "${CANONICAL_REMOTE}" \
	--branch "${BRANCH}" \
	--work-dir "${TEMP_DIR}" \
	--config-dir /etc/nixos &&
    export PATH=/run/wrappers/bin:/run/current-system/sw/bin:$(dirname $(which systemctl)):$(dirname $(which grep)) &&
    sudo nixos-rebuild switch &&
    true
