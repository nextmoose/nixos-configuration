#!/bin/sh

cp ${STORE_DIR}/lib/zookeeper.conf ${HOME}/zookeeper.conf &&
    mkdir ${HOME}/zookeeper &&
    echo zkServer.sh start-foreground ${HOME}/zookeeper.conf &&
    zkServer.sh start-foreground ${HOME}/zookeeper.conf &&
    true
