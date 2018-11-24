#!/bin/sh

cp ${STORE_DIR}/lib/zookeeper.conf ${HOME}/zookeeper.conf &&
    mkdir ${HOME}/zookeeper &&
    zkServer.sh --start-foreground ${HOME}/zookeeper.conf &&
    true
