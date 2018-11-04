#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    if [ ! -d ${HOME}/.aws ]
    then
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
	    cp ${STORE_DIR}/lib/t.02/.gconf.path ${HOME}/.gconf.path &&
	    gconftool-2 --shutdown &&
	    cp -r ${HOME} ${TEMP_DIR}/t.01 &&
	    ${AWS_PATH}/bin/aws s3 ls s3://${BUCKET} &&
	    TSTAMP=$(${AWS_PATH}/bin/aws s3 ls s3://${BUCKET} | sort | head --lines 1 | cut --bytes 40-49) &&
	    debucket --name gnucash --timestamp "${TSTAMP}" --destination-directory gnucash &&
	    # gnucash gnucash/gnucash.gnucash &&
	    true
    fi &&
    true
