#!/bin/sh

echo No commits allowed on a read only repository &&
    exit 67 &&
    true
