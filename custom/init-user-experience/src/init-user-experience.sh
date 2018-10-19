#!/bin/sh

(wifi || true) &&
    export OLD_HOME=${HOME} &&
    export HOME=$(mktemp -d) &&
    init-read-only-pass --upstream-url https://github.com/nextmoose/secrets.git --upstream-branch master &&
    mkdir ${OLD_HOME}/.ssh &&
    chmod 0700 ${OLD_HOME}/.ssh &&
    pass show upstream.id_rsa > ${OLD_HOME}/.ssh/upstream.id_rsa &&
    pass show upstream.known_hosts > ${OLD_HOME}/.ssh/upstream.known_hosts &&
    pass show origin.id_rsa > ${OLD_HOME}/.ssh/origin.id_rsa &&
    pass show report.known_hosts > ${OLD_HOME}/.ssh/origin.known_hosts &&
    pass show report.id_rsa > ${OLD_HOME}/.ssh/report.id_rsa &&
    pass show report.known_hosts > ${OLD_HOME}/.ssh/report.known_hosts &&
    (cat > ${OLD_HOME}/.ssh/config <<EOF
Host upstream
HostName github.com
User git
IdentityFile ${OLD_HOME}/.ssh/upstream.id_rsa
UserKnownHostsFile ${OLD_HOME}/.ssh/upstream.known_hosts

Host origin
HostName github.com
User git
IdentityFile ${OLD_HOME}/.ssh/origin.id_rsa
UserKnownHostsFile ${OLD_HOME}/.ssh/origin.known_hosts

Host report
HostName github.com
User git
IdentityFile ${OLD_HOME}/.ssh/report.id_rsa
UserKnownHostsFile ${OLD_HOME}/.ssh/report.known_hosts
EOF
    ) &&
    chmod 0600 ${OLD_HOME}/.ssh/upstream.id_rsa &&
    chmod 0600 ${OLD_HOME}/.ssh/upstream.known_hosts &&
    chmod 0600 ${OLD_HOME}/.ssh/origin.id_rsa &&
    chmod 0600 ${OLD_HOME}/.ssh/origin.known_hosts &&
    chmod 0600 ${OLD_HOME}/.ssh/report.id_rsa &&
    chmod 0600 ${OLD_HOME}/.ssh/report.known_hosts &&
    chmod 0600 ${OLD_HOME}/.ssh/config &&
    mkdir ${OLD_HOME}/projects &&
    mkdir ${OLD_HOME}/projects/installation &&
    git -C ${OLD_HOME}/projects/installation init &&
    git -C ${OLD_HOME}/projects/installation config user.name "Emory Merryman" &&
    git -C ${OLD_HOME}/projects/installation config user.email "emory.merryman@gmail.com" &&
    git -C ${OLD_HOME}/projects/installation remote add upstream upstream:rebelplutonium/nixos-installer.git &&
    git -C ${OLD_HOME}/projects/installation remote set-url --push upstream no_push &&
    git -C ${OLD_HOME}/projects/installation remote add origin origin:nextmoose/nixos-installer.git &&
    git -C ${OLD_HOME}/projects/installation remote add report report:rebelplutonium/nixos-installer.git &&
    ln --symbolic $(which post-commit) ${OLD_HOME}/projects/installation/.git/hooks &&
    mkdir ${OLD_HOME}/projects/configuration &&
    git -C ${OLD_HOME}/projects/configuration init &&
    git -C ${OLD_HOME}/projects/configuration config user.name "Emory Merryman" &&
    git -C ${OLD_HOME}/projects/configuration config user.email "emory.merryman@gmail.com" &&
    git -C ${OLD_HOME}/projects/configuration remote add upstream upstream:rebelplutonium/nixos-configuration.git &&
    git -C ${OLD_HOME}/projects/configuration remote set-url --push upstream no_push &&
    git -C ${OLD_HOME}/projects/configuration remote add origin origin:nextmoose/nixos-configuration.git &&
    git -C ${OLD_HOME}/projects/configuration remote add report report:rebelplutonium/nixos-configuration.git &&
    ln --symbolic $(which post-commit) ${OLD_HOME}/projects/configuration/.git/hooks &&
    true
