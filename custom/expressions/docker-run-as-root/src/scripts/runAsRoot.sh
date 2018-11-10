#!/bin/sh

mkdir /home /tmp &&
    useradd --create-home user &&
    chmod a+rwx /tmp &&
    true
