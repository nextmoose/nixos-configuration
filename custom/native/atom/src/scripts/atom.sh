#!/bin/sh

mkdir "${HOME}/project" &&
    dot-ssh &&
    (cp --recursive "${STORE_DIR}/lib/atom" "${HOME}/.atom" || true) &&
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
    tryinstall(){
      apm install "${@}" > "${HOME}/${@}.out.log" 2> "${HOME}/${@}.err.log" || true
    } &&
    ## ALPHA
    tryinstall termrk &&
    tryinstall tokamak-terminal &&
    tryinstall quantum-shell &&
    tryinstall run-commandtwo &&
    tryinstall termination &&
    tryinstall process-palette &&
    tryinstall hydrogen-launcher &&
    tryinstall command-executor &&
    tryinstall output-panel &&
    tryinstall termy &&
    tryinstall atom-console &&
    ## BETA
    ## BLACKLIST
    # tryinstall terminal-plus &&
    # tryinstall atom-terminal &&
#      tryinstall terminal-fusion &&
          #       tryinstall atom-development-server &&
#          tryinstall platformio-ide-terminal &&
#          tryinstall run-command &&
  ## WHITELIST
    tryinstall atom-terminal-panel &&
    atom --foreground "${HOME}/project" &&
    true
