#!/bin/sh

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
    (cat > ${HOME}/.gconf.path <<EOF
xml:readwrite:\$(HOME)/.gconf
xml:readonly:/nix/store/p3wdpwf9aaqvr7qxhwmk3cn8lfdk089v-gnucash-2.4.15/etc/gconf/gconf.xml.defaults
EOF
    ) &&
    TSTAMP=$(aws s3 ls s3://${BUCKET} | sort | head --lines 1 | cut --bytes 40-49) &&
    debucket --name gnucash --timestamp "${TSTAMP}" --destination-directory gnucash &&
    sleep 1m &&
    gnucash &&
    true
