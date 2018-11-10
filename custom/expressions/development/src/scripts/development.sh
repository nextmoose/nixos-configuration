#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
	--committer-name)
	    COMMITTER_NAME="${2}" &&
		shift 2
	    ;;
	--committer-email)
	    COMMITTER_EMAIL="${2}" &&
		shift 2
	    ;;
	--upstream-host)
	    UPSTREAM_HOST="${2}" &&
		shift 2
	    ;;
	--upstream-user)
	    UPSTREAM_USER="${2}" &&
		shift 2
	    ;;
	--upstream-port)
	    UPSTREAM_PORT="${2}" &&
		shift 2
	    ;;
	--upstream-organization)
	    UPSTREAM_ORGANIZATION="${2}" &&
		shift 2
	    ;;
	--upstream-repository)
	    UPSTREAM_REPOSITORY="${2}" &&
		shift 2
	    ;;
	--upstream-branch)
	    UPSTREAM_BRANCH="${2}" &&
		shift 2
	    ;;
	--origin-host)
	    ORIGIN_HOST="${2}" &&
		shift 2
	    ;;
	--origin-user)
	    ORIGIN_USER="${2}" &&
		shift 2
	    ;;
	--origin-port)
	    ORIGIN_PORT="${2}" &&
		shift 2
	    ;;
	--origin-organization)
	    ORIGIN_ORGANIZATION="${2}" &&
		shift 2
	    ;;
	--origin-repository)
	    ORIGIN_REPOSITORY="${2}" &&
		shift 2
	    ;;
	--origin-branch)
	    ORIGIN_BRANCH="${2}" &&
		shift 2
	    ;;
	--report-host)
	    REPORT_HOST="${2}" &&
		shift 2
	    ;;
	--report-user)
	    REPORT_USER="${2}" &&
		shift 2
	    ;;
	--report-port)
	    REPORT_PORT="${2}" &&
		shift 2
	    ;;
	--report-organization)
	    REPORT_ORGANIZATION="${2}" &&
		shift 2
	    ;;
	--report-repository)
	    REPORT_REPOSITORY="${2}" &&
		shift 2
	    ;;
	--report-branch)
	    REPORT_BRANCH="${2}" &&
		shift 2
	    ;;
	*)
	    echo Unknown Option &&
		echo "${1}" &&
		echo "${0}" &&
		echo "${@}" &&
		exit 65 &&
		true
	    ;;
    esac &&
	true
done &&
    cat ${IMAGE} | sudo docker image load &&
    sudo \
	docker \
	container \
	run \
	--interactive \
	--tty \
	--rm \
	--env COMMITTER_NAME="${COMMITTER_NAME}" \
	--env COMMITER_EMAIL="${COMMITTER_EMAIL}" \
	--env GPG_SECRET_KEY="$(pass show gpg.secret.key)" \
	--env GPG_OWNER_TRUST="$(pass show gpg.owner.trust)" \
	--env GPG2_SECRET_KEY="$(pass show gpg2.secret.key)" \
	--env GPG2_OWNER_TRUST="$(pass show gpg2.owner.trust)" \
	--env UPSTREAM_HOST="${UPSTREAM_HOST}" \
	--env UPSTREAM_USER="${UPSTREAM_USER}" \
	--env UPSTREAM_PORT="${UPSTREAM_PORT}" \
	--env UPSTREAM_ID_RSA="$(pass show upstream.id_rsa)" \
	--env UPSTREAM_KNOWN_HOSTS="$(pass show upstream.known_hosts)" \
	--env UPSTREAM_ORGANIZATION="${UPSTREAM_ORGANIZATION}" \
	--env UPSTREAM_REPOSITORY="${UPSTREAM_REPOSITORY}" \
	--env UPSTREAM_BRANCH="${UPSTREAM_BRANCH}" \
	--env ORIGIN_HOST="${ORIGIN_HOST}" \
	--env ORIGIN_USER="${ORIGIN_USER}" \
	--env ORIGIN_PORT="${ORIGIN_PORT}" \
	--env ORIGIN_ID_RSA="$(pass show origin.id_rsa)" \
	--env ORIGIN_KNOWN_HOSTS="$(pass show origin.known_hosts)" \
	--env ORIGIN_ORGANIZATION="${ORIGIN_ORGANIZATION}" \
	--env ORIGIN_REPOSITORY="${ORIGIN_REPOSITORY}" \
	--env ORIGIN_BRANCH="${ORIGIN_BRANCH}" \
	--env REPORT_HOST="${REPORT_HOST}" \
	--env REPORT_USER="${REPORT_USER}" \
	--env REPORT_PORT="${REPORT_PORT}" \
	--env REPORT_ID_RSA="$(pass show report.id_rsa)" \
	--env REPORT_KNOWN_HOSTS="$(pass show report.known_hosts)" \
	--env REPORT_ORGANIZATION="${REPORT_ORGANIZATION}" \
	--env REPORT_REPOSITORY="${REPORT_REPOSITORY}" \
	--env REPORT_BRANCH="${REPORT_BRANCH}" \
	development &&
    true
