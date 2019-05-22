#!/bin/sh

NOW=$(date +%s) &&
    pass git ls-tree -r master --name-only | grep ".gpg\$" | while read FILE
    do
	LAST_COMMIT_DATE=$(git log -1 --format=%ct ${FILE}) &&
	    AGE=$((${NOW} - ${LAST_COMMIT_DATE})) &&
	    PASSWORD_SIZE=$(($(pass show ${FILE%.gpg}) | wc -c)) &&
	    echo -e "${FILE%.gpg}\t${AGE}\t${PASSWORD_SIZE}" &&
	    true
    done &&
    true
