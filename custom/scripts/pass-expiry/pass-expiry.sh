#!/bin/sh

NOW=$(date +%s) &&
    YEAR=$(date +%y) &&
    pass git ls-tree -r master --name-only | grep ".gpg\$" | while read FILE
    do
	LAST_COMMIT_DATE=$(pass git log -1 --format=%ct ${FILE}) &&
	    AGE=$((${NOW} - ${LAST_COMMIT_DATE})) &&
	    PASSWORD_SIZE=$(pass show ${FILE%.gpg} | wc -c) &&
	    if [ "${AGE}" -gt 31622400 ]
	    then
		echo -e "A ${FILE%.gpg}" &&
		    true
	    elif [ "${YEAR}" == "${PASSWORD_SIZE}" ] && [ "${AGE}" -gt 2678400 ]
	    then
		echo -e "B ${FILE%.gpg}" &&
		    true
	    elif [ "${YEAR}" == $(("${PASSWORD_SIZE}" + 1)) ] && [ "${AGE}" -gt 604800 ]
	    then
		echo -e "C ${FILE%.gpg}" &&
		    true
	    elif [ "${YEAR}" == $(("${PASSWORD_SIZE}" + 2)) ] && [ "${AGE}" -gt 86400 ]
	    then
		echo -e "D ${FILE%.gpg}" &&
		    true
	    elif [ "${YEAR}" == $(("${PASSWORD_SIZE}" + 3)) ] && [ "${AGE}" -gt 3600 ]
	    then
		echo -e "E ${FILE%.gpg}" &&
		    true
	    elif [ "${YEAR}" -gt $(("${PASSWORD_SIZE}" + 3)) ]
	    then
		echo -e F "${FILE%.gpg}" ${NOW} ${YEAR} ${AGE} ${PASSWORD_SIZE} &&
		    true
	    fi &&
	    true
    done &&
    true
