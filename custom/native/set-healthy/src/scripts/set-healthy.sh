#!/bin/sh

echo SETTING HEALTH &&
    touch "${HOME}/health-check" &&
    echo WE SET IT HEALTH IT SHOULD RETURN HEALTH NOW &&
    true
