#!/bin/sh

unset GIT_EXEC_PATH &&
while ! git push origin $(git rev-parse --abbrev-ref HEAD --)
do
    sleep 1s &&
	true
done &&
    true
