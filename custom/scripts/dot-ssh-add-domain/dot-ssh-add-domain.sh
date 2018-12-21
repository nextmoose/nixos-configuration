#!/bin/sh

unset DOMAIN HOST USER PORT &&
    while [ "${#}" -gt 0 ]
    do
	case "${1}" in
	    --domain)
		DOMAIN="${2}" &&
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
		echo Unsupported Option &&
		    echo "${1}" &&
		    echo "${@}" &&
		    echo "${0}" &&
		    exit 66 &&
		    true
		;;
	esac &&
	    true
    done &&
    if [ -z "${DOMAIN}" ]
    then
	echo Unspecified Domain &&
	    exit 67 &&
	    true
    elif [ -z "${USER}" ]
    then
	echo Unspecified User &&
	    exit 67 &&
	    true
    elif [ -z "${HOST}" ]
    then
	echo Unspecified Host &&
	    exit 67 &&
	    true
    elif [ -z "${PORT}" ]
    then
	echo Unspecified Port &&
	    exit 67 &&
	    true
    fi &&
    (cat > "${HOME}/.ssh/${DOMAIN}.conf" <<EOF
Host ${DOMAIN}
HostName ${HOST}
User ${USER}
Port ${PORT}
IdentityFile ${HOME}/.ssh/${DOMAIN}.id_rsa
UserKnownHostsFile ${HOME}/.ssh/${DOMAIN}.known_hosts
EOF
    ) &&
    pass show "${DOMAIN}.id_rsa" > "${HOME}/.ssh/${DOMAIN}.id_rsa" &&
    pass show "${DOMAIN}.known_hosts" > "${HOME}/.ssh/${DOMAIN}.known_hosts" &&
    chmod 0400 "${HOME}/.ssh/${DOMAIN}.conf" \
	  true
