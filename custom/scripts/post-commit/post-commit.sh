#!/bin/sh

while ! git push origin $(git rev-parse --abbrev-ref HEAD --) >> /home/user/log.txt 2>&1
do
    sleep 1s &&
	true
done &&
    true
