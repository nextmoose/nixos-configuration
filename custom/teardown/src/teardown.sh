jq -r ".containers | to_entries[] | .value" "${STORE_DIR}/uuids.json" | while read UUID
do
    docker container ls --quiet --no-trunc --filter "label=uuid=${UUID}" | while read CONTAINER
    do
	docker container stop "${CONTAINER}" &&
	    true
    done &&
	true
done &&
    jq -r ".containers | to_entries[] | .value" "${STORE_DIR}/uuids.json" | while read UUID
    do
	docker container ls --quiet --no-trunc --filter "label=uuid=${UUID}" --all | while read CONTAINER
	do
	    docker container rm --volumes "${CONTAINER}" &&
		true
	done &&
	    true
    done &&
    jq -r ".images | to_entries[] | .value" "${STORE_DIR}/uuids.json" | while read UUID
    do
	docker image ls --quiet --no-trunc --filter "label=uuid=${UUID}" --all | while read IMAGE
	do
	    docker container rm "${IMAGE}" &&
		true
	done &&
	    true
    done &&
    true
