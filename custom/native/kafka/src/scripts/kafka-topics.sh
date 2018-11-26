#!/bin/sh

kafka-topics.sh "${@}" &&
    true
