#!/bin/sh

mkdir "${HOME}/project" &&
    dot-ssh &&
    git -C "${HOME}/project" init &&
    if
	[ ! -z "${UPSTREAM_ORGANIZATION}" ] &&
	    [ ! -z "${UPSTREAM_REPOSITORY}" ] &&
	    [ ! -z "${UPSTREAM_BRANCH}" ]
    then
	git -C "${HOME}/project" remote add upstream "upstream:${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git" &&
	    git -C "${HOME}/project" fetch upstream "${UPSTREAM_BRANCH}" &&
	    git -C "${HOME}/project" checkout "upstream/${UPSTREAM_BRANCH}" &&
	    true
    fi &&
    if
	[ ! -z "${ORIGIN_ORGANIZATION}" ] &&
	    [ ! -z "${ORIGIN_REPOSITORY}" ] &&
	    [ -z "${ORIGIN_BRANCH}" ]
    then
	git -C "${HOME}/project" remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
	    git -C "${HOME}/project" checkout -b scratch/$(uuidgen) &&
	    true
    elif
	[ ! -z "${ORIGIN_ORGANIZATION}" ] &&
	    [ ! -z "${ORIGIN_REPOSITORY}" ] &&
	    [ ! -z "${ORIGIN_BRANCH}" ]
    then
	git -C "${HOME}/project" remote add origin "origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git" &&
	    git -C "${HOME}/project" fetch origin "${ORIGIN_BRANCH}" &&
	    git -C "${HOME}/project" checkout "${ORIGIN_BRANCH}" &&
	    true
    fi &&
    if
	[ ! -z "${REPORT_ORGANIZATION}" ] &&
	    [ ! -z "${REPORT_REPOSITORY}" ] &&
	    [ ! -z "${REPORT_BRANCH}" ]
    then
	git -C "${HOME}/project" remote add report "report:${REPORT_ORGANIZATION}/${REPORT_REPOSITORY}.git" &&
	    true
    fi &&
    git -C "${HOME}/project" config user.name "${COMMITTER_NAME}" &&
    git -C "${HOME}/project" config user.email "${COMMITTER_EMAIL}" &&
    ln --symbolic $(which post-commit) "${HOME}/project/.git/hooks" &&
    atom --foreground "${HOME}/project" &&
    true
