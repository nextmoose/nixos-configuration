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
    echo AAA &&
    if [ -z "$(docker-container-id $(jq -r --from-file ${STORE_DIR}/src/queries/containers/system-secrets-read-only-pass.js ${STORE_DIR}/uuids.json))" ]
    then
	echo BBB &&
	    echo "${WORK_DIR}/system-secrets-read-only-pass.cid" &&
	    jq -r --from-file "${STORE_DIR}/src/queries/containers/system-secrets-read-only-pass.js" "${STORE_DIR}/uuids.json" &&
	    jq -r --from-file "${STORE_DIR}/src/queries/images/read-only-pass.js" "${STORE_DIR}/uuids.json" &&
	    docker-image-id $(jq -r --from-file "${STORE_DIR}/src/queries/images/read-only-pass.js" "${STORE_DIR}/uuids.json") &&
	    echo CCC &&
	    echo \
		docker \
		container \
		create \
		--cidfile "${WORK_DIR}/system-secrets-read-only-pass.cid" \
		--restart always \
		--label uuid=$(jq -r --from-file "${STORE_DIR}/src/queries/containers/system-secrets-read-only-pass.js" "${STORE_DIR}/uuids.json") \
		$(docker-image-id $(jq -r --from-file "${STORE_DIR}/src/queries/images/read-only-pass.js" "${STORE_DIR}/uuids.json")) \
		--remote https://github.com/nextmoose/secrets.git \
		--branch master \
		--foo bar &&
	    docker \
		container \
		create \
		--cidfile "${WORK_DIR}/system-secrets-read-only-pass.cid" \
		--restart always \
		--label uuid=$(jq -r --from-file "${STORE_DIR}/src/queries/containers/system-secrets-read-only-pass.js") \
		$(docker-image-id $(jq -r --from-file "${STORE_DIR}/src/queries/images/read-only-pass.js" "${STORE_DIR}/uuids.json")) \
		--remote https://github.com/nextmoose/secrets.git \
		--branch master \
		--foo bar &&
	    true
    fi &&
    echo DDD &&
    find "${WORK_DIR}" -name *.cid | while read CIDFILE
    do
	echo EEE ${CIDFILE} &&
	    docker container start $(cat ${CIDFILE}) &&
	    rm --force "${CIDFILE}" &&
	    echo FFF ${CIDFILE} &&
	    true
    done &&
    true
