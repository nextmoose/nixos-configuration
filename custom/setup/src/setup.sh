#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    cleanup() {
	rm --recursive --force "${WORK_DIR}" &&
	    true
    } &&
    trap cleanup EXIT &&
    if [ -z "$(docker-image-id $(jq -r --from-file ${STORE_DIR}/src/queries/images/read-only-pass.js ${STORE_DIR}/uuids.json))" ]
    then
	docker image load --quiet --input "${STORE_DIR}/images/read-only-pass.tar" &&
	    true
    fi &&
    if [ -z "$(docker-container-id $(jq -r --from-file ${STORE_DIR}/src/queries/containers/system-secrets-read-only-pass.js ${STORE_DIR}/uuids.json))" ]
    then
	echo \
	    docker \
	    container \
	    create \
	    --cidfile "${WORK_DIR}/system-secrets-read-only-pass.cid" \
	    --restart always \
	    --label uuid=$(jq --from-file "${STORE_DIR}/src/queries/containers/system-secrets-read-only-pass.js") \
	    $(docker-image-id $(jq -r --from-file "${STORE_DIR}/src/queries/images/read-only-pass.js" "${STORE_DIR}/uuids.json")) \
	    --remote https://github.com/nextmoose/secrets.git \
	    --branch master &&
	    docker \
		container \
		create \
		--cidfile "${WORK_DIR}/system-secrets-read-only-pass.cid" \
		--restart always \
		--label uuid=$(jq --from-file "${STORE_DIR}/src/queries/containers/system-secrets-read-only-pass.js") \
		$(docker-image-id $(jq -r --from-file "${STORE_DIR}/src/queries/images/read-only-pass.js" "${STORE_DIR}/uuids.json")) \
		--remote https://github.com/nextmoose/secrets.git \
		--branch master &&
	    true
    fi &&
    find "${WORK_DIR}" -name *.cid | while read CIDFILE
    do
	docker container start $(cat ${CIDFILE}) &&
	    rm --force "${CIDFILE}" &&
	    true
    done &&
    true
