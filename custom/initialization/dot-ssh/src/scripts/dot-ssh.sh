#!/bin/sh

while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --upstream-host)
      UPSTREAM_HOST="${2}" &&
        shift 2 &&
        true
    ;;
    --upstream-user)
      UPSTREAM_USER="${2}" &&
        shift 2 &&
        true
    ;;
    --upstream-port)
      UPSTREAM_PORT="${2}" &&
        shift 2 &&
        true
    ;;
    --origin-host)
      ORIGIN_HOST="${2}" &&
        shift 2 &&
        true
    ;;
    --origin-user)
      ORIGIN_USER="${2}" &&
        shift 2 &&
        true
    ;;
    --origin-port)
      ORIGIN_PORT="${2}" &&
        shift 2 &&
        true
    ;;
    --report-host)
      REPORT_HOST="${2}" &&
        shift 2 &&
        true
    ;;
    --report-user)
      REPORT_USER="${2}" &&
        shift 2 &&
        true
    ;;
    --report-port)
      REPORT_PORT="${2}" &&
        shift 2 &&
        true
    ;;
    *)
      echo Unknown Option &&
        echo "${1}" &&
        echo "${0}" &&
        echo "${@}" &&
        exit 66 &&
        true
  esac &&
    true
done &&
  mkdir "${HOME}/.ssh" &&
  chmod 0700 "${HOME}/.ssh" &&
  (cat > "${HOME}/.ssh/config" <<EOF
Include ${HOME}/.ssh/*.conf
EOF
  ) &&
  chmod 0400 "${HOME}/.ssh/config" &&
  addhost() {
    DOMAIN="${1}" &&
    HOST="${2}" &&
    USER="${3}" &&
    PORT="${4}" &&
    ID_RSA="${5}" &&
    KNOWN_HOSTS="${6}" &&
    if
      [ ! -z "${DOMAIN}" ] &&
      [ ! -z "${HOST}" ] &&
      [ ! -z "${USER}" ] &&
      [ ! -z "${PORT}" ] &&
      [ ! -z "${ID_RSA}" ] &&
      [ ! -z "${KNOWN_HOSTS}" ]
      then
        (cat > "${HOME}/.ssh/${DOMAIN}.conf" <<EOF
Host ${DOMAIN}
HostName ${HOST}
User ${USER}
Port ${PORT}
IdentityFile ${HOME}/.ssh/${DOMAIN}.id_rsa
UserKnownHostsFile ${HOME}/.ssh/${DOMAIN}.known_hosts
EOF
      ) &&
      echo "${ID_RSA}" > "${HOME}/.ssh/${DOMAIN}.id_rsa" &&
      echo "${KNOWN_HOSTS}" > "${HOME}/.ssh/${DOMAIN}.known_hosts" &&
      chmod \
        0400 \
        "${HOME}/.ssh/${DOMAIN}.conf" \
        "${HOME}/.ssh/${DOMAIN}.id_rsa" \
        "${HOME}/.ssh/${DOMAIN}.known_hosts" &&
    true
  fi &&
  true
} &&
echo BEFORE &&
addhost upstream "${UPSTREAM_HOST}" "${UPSTREAM_USER}" "${UPSTREAM_PORT}" "$(pass show upstream.id_rsa)" "$(pass show upstream.known_hosts)" &&
echo AFTER &&
addhost origin "${ORIGIN_HOST}" "${ORIGIN_USER}" "${ORIGIN_PORT}" "$(pass show origin.id_rsa)" "$(pass show origin.known_hosts)" &&
addhost report "${REPORT_HOST}" "${REPORT_USER}" "${REPORT_PORT}" "$(pass show report.id_rsa)" "$(pass show report.known_hosts)" &&
true
