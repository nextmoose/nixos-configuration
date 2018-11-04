#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cp -r ${HOME} ${TEMP_DIR}/t.00 &&
secrets \
    --canonical-host github.com \
    --canonical-organization nextmoose \
    --canonical-repository secrets \
    --canonical-branch master &&
    ssh-remote \
	--remote upstream \
	--host github.com \
	--user git \
	--port 22 &&
    read-only-pass \
	--upstream-organization nextmoose \
	--upstream-repository aws-secrets \
	--upstream-branch master &&
    aws \
	--aws-access-key-id AKIAICSO2M2FPGDMRHNA \
	--default-region-name us-east-1 \
	--default-output-format json &&
    echo ALPHA 00100 &&
    cat ${STORE_DIR}/lib/t.02/.gconf.path ${HOME}/.gconf.path &&
    echo ALPHA 00200 &&
    cp ${STORE_DIR}/lib/t.02/.gconf.path ${HOME}/.gconf.path &&
    echo ALPHA 00300 &&
    cat ${STORE_DIR}/lib/t.02/.gconf.path ${HOME}/.gconf.path &&
    echo ALPHA 00400 &&
    gconftool-2 --shutdown &&
    echo ALPHA 00500 &&
    sleep 1m &&
    echo ALPHA 00600 &&
    gnucash &&
    fun() {
	cp -r ${HOME} ${TEMP_DIR}/t.01 &&
	    sleep 10s &&
	    echo &&
	    echo BUCKET=${BUCKET} &&
	    echo ${AWS_PATH}/bin/aws s3 ls s3://${BUCKET} &&
	    which aws &&
	    ls -alh $(which aws) &&
	    ${AWS_PATH}/bin/aws s3 ls s3://${BUCKET} &&
	    TSTAMP=$(${AWS_PATH}/bin/aws s3 ls s3://${BUCKET} | sort | head --lines 1 | cut --bytes 40-49) &&
	    echo TSTAMP="${TSTAMP}" &&
	    debucket --name gnucash --timestamp "${TSTAMP}" --destination-directory gnucash &&
	    sleep 10s &&
	    gnucash gnucash/gnucash.gnucash &&
	    cp -r ${HOME} ${TEMP_DIR}/t.02 &&
	    true
    } &&
    true
