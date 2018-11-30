#!/bin/sh

pvcreate /dev/sda4 &&
    vgcreate volumes /dev/sda4 &&
    true
