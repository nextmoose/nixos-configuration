#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--staples-file)
	    STAPLES_FILE="${2}" &&
		shift 2 &&
		true
	;;
	--package)
	    PACKAGE="${2}" &&
		shift 2 &&
		true
	;;
	*)
	    echo Unsupported Option &&
		echo "${1}" &&
		echo "${@}" &&
		echo "${0}" &&
		exit 64 &&
		true
	    ;;
    esac &&
	true
done &&
    TEST_SCRIPT=$(jq --raw-output ".[\"${PACKAGE}\"].script" "${STORE_DIR}/configuration.json") &&
    IMPLEMENTATION=$(cat <<EOF
(import ${STAPLES_FILE} { pkgs = import <nixpkgs> {}; }).${PACKAGE}.implementation
EOF
    ) &&
    RESULT=$(nix-build --arg implementation "${IMPLEMENTATION}" --arg test-script "${TEST_SCRIPT}" "${STORE_DIR}/src/script-test.nix") &&
    chromium "${RESULT}/log.html" &&
    true
