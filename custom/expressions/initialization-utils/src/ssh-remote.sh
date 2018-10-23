#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--remote)
	    REMOTE="${2}" &&
		shift 2 &&
		true
	    ;;
	--host)
	    HOST="${2}" &&
		shift 2 &&
		true
	    ;;
	--user)
	    USER="${2}" &&
		shift 2 &&
		true
	    ;;
	--port)
	    PORT="${2}" &&
		shift 2 &&
		true
	    ;;
	*)
	    echo Unknown Option &&
		echo ${1} &&
		echo ${0} &&
		echo ${@} &&
		exit 65 &&
		true
	    ;;
    esac &&
	true
done &&
    (cat <<EOF
REMOTE
HOST
PORT
USER
EOF
    ) | while read VAR do
    do
	eval VAL=\${${VAR}} &&
	    if [ -z "${VAL}" ]
	    then
		echo Undefined ${VAR} &&
		    echo ${0} &&
		    exit 66 &&
		    true
	    fi &&
	    true
    done &&
    if [ ! -f "${HOME}/.ssh/config.d/${REMOTE}" ]
    then
	(cat > "${HOME}/.ssh/config.d/${REMOTE}" <<EOF
Host ${REMOTE}
HostName ${HOST}
User ${USER}
Port ${PORT}
IdentityFile ${HOME}/.ssh/${REMOTE}.id_rsa
UserKnownHostsFile ${HOME}/.ssh/${REMOTE}.known_hosts
EOF
	) &&
	    chmod 0400 ${HOME}/.ssh/config.d/${REMOTE} &&
	    true
    fi &&
    true
