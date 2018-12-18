#!/bin/sh

mkdir ${HOME}/.ssh &&
    pass show upstream.id_rsa > ${HOME}/.ssh/upstream.id_rsa &&
    pass show upstream.known_hosts > ${HOME}/.ssh/upstream.known_hosts &&
    pass show origin.id_rsa > ${HOME}/.ssh/origin.id_rsa &&
    pass show origin.known_hosts > ${HOME}/.ssh/origin.known_hosts &&
    pass show report.id_rsa > ${HOME}/.ssh/report.id_rsa &&
    pass show report.known_hosts > ${HOME}/.ssh/report.known_hosts &&
    (cat > ${HOME}/.ssh/config <<EOF
Host upstream
HostName github.com
User git
Port 22
IdentityFile ${HOME}/.ssh/upstream.id_rsa
UserKnownHostsFile ${HOME}/.ssh/upstream.known_hosts

Host origin
HostName github.com
User git
Port 22
IdentityFile ${HOME}/.ssh/origin.id_rsa
UserKnownHostsFile ${HOME}/.ssh/origin.known_hosts

Host report
HostName github.com
User git
Port 22
IdentityFile ${HOME}/.ssh/report.id_rsa
UserKnownHostsFile ${HOME}/.ssh/report.known_hosts
EOF
    ) &&
    chmod 0400 ${HOME}/.ssh/* &&
    mkdir ${HOME}/project &&
    git -C ${HOME}/project init &&
    git -C ${HOME}/project config user.name "Emory Merryman" &&
    git -C ${HOME}/project config user.email "emory.merryman@gmail.com" &&
    git -C ${HOME}/project remote add upstream upstream:rebelplutonium/nixos-configuration.git &&
    git -C ${HOME}/project remote add origin origin:nextmoose/nixos-configuration.git &&
    git -C ${HOME}/project remote add report report:rebelplutonium/nixos-configuration.git &&
    git -C ${HOME}/project fetch origin level-5 &&
    git -C ${HOME}/project checkout level-5 &&
    true
