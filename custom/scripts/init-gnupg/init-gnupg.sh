#!/bin/sh

gnupg-private-keys &&
    gnupg2-private-keys &&
    gnupg-ownertrust &&
    gnupg2-ownertrust &&
    true
