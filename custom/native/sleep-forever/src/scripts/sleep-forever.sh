#!/bin/sh

echo BEFORE SLEEPING FOREVER SET HEALTHY &&
    set-healthy &&
    echo OK NOW SLEEP FOREVER &&
    tail --follow /dev/null &&
    true
