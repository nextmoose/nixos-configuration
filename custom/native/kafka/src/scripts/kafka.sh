#!/bin/sh

bash &&
    zookeeper-server-start.sh config/zookeeper.properties &&
    kafka-server-start.sh config/server.properties &&
    kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test &&
    kafka-topics.sh --list --zookeeper localhost:2181 &&
    true
