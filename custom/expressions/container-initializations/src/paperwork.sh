#!/bin/sh

#
# gnucash has some weird kludge going on.
#
# 1. start `gnucash`
# 2. there is some bullshit error - I don't know.  just click the defaults.  wait for gnucash to start.  then quit it
# 3. sleep 3 minutes `sleep 3m`.  I don't know 3 minutes is necessary but it seems some sleep is required.  I tested on 3 minutes.  most likely less is necessary.
# 4. gnucash should now work without the bullshit error `gnucash`
# 5. initially you will be prompted to create a file.
#
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
    # debucket --name gnucash --timestamp 1540656743 --destination-directory gnucash --bucket ${BUCKET}
    # gnucash &&
    # sleep 1m &&
    # gnucash &&
    # Cancel and load file
    true
