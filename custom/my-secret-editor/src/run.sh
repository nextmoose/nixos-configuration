#!/bin/sh

if [ ! -f ${HOME}/.flag ]
then
    nmcli device wifi connect "Richmond Sq Guest" password "guestwifi" &&
	gpg --import $(secret-file gpg.secret.key) &&
	gpg --import-ownertrust $(secret-file gpg.owner.trust) &&
	gpg2 --import $(secret-file gpg2.secret.key) &&
	gpg2 --import-ownertrust $(secret-file gpg2.owner.trust) &&
	pass init $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
	mkdir ${HOME}/.ssh &&
	chmod 0700 ${HOME}/.ssh &&
	(cat > ${HOME}/.ssh <<EOF
Host upstream
HostName github.com
User git
IdentityFile $(secret-file upstream.id_rsa)
UserKnownHostsFile $(secret-file upstream.known_hosts)

Host origin
HostName github.com
User git
IdentityFile $(secret-file origin.id_rsa)
UserKnownHostsFile $(secret-file origin.known_hosts)

Host report
HostName github.com
User git
IdentityFile $(secret-file report.id_rsa)
UserKnownHostsFile $(secret-file report.known_hosts)

EOF
	) &&
	pass git init &&
	pass git remote add origin origin:desertedscorpion/passwordstore.git &&
	pass git fetch origin master &&
	pass git checkout master &&
	ln --symbolic $(which post-commit) ${HOME}/.password-store/.git/hooks &&
	ln --symbolic $(which pre-push) ${HOME}/.password-store/.git/hooks &&
	mkdir ${HOME}/projects &&
	mkdir ${HOME}/projects/installation &&
	git -C ${HOME}/projects/installation init &&
	git -C ${HOME}/projects/installation config user.name "Emory Merryman" &&
	git -C ${HOME}/projects/installation config user.email "emory.merryman@gmail.com" &&
	git -C ${HOME}/projects/installation remote add upstream upstream:rebelplutonium/nixos-installation.git &&
	git -C ${HOME}/projects/installation remote set-url --push upstream no_push &&
	git -C ${HOME}/projects/installation remote add origin origin:nextmoose/nixos-installation.git &&
	git -C ${HOME}/projects/installation remote add report report:rebelplutonium/nixos-installation.git &&
	ln --symbolic $(which post-commit) ${HOME}/projects/installation/.git/hooks &&
	ln --symbolic $(which pre-push) ${HOME}/projects/installation/.git/hooks && 
	mkdir ${HOME}/projects/configuration &&
	git -C ${HOME}/projects/configuration init &&
	git -C ${HOME}/projects/configuration config user.name "Emory Merryman" &&
	git -C ${HOME}/projects/configuration config user.email "emory.merryman@gmail.com" &&
	git -C ${HOME}/projects/configuration remote add upstream upstream:rebelplutonium/nixos-configuration.git &&
	git -C ${HOME}/projects/configuration remote set-url --push upstream no_push &&
	git -C ${HOME}/projects/configuration remote add origin origin:nextmoose/nixos-configuration.git &&
	git -C ${HOME}/projects/configuration remote add report report:rebelplutonium/nixos-configuration.git &&
	ln --symbolic $(which post-commit) ${HOME}/projects/configuration/.git/hooks &&
	ln --symbolic $(which pre-push) ${HOME}/projects/configuration/.git/hooks &&
	
	touch ${HOME}/.flag
fi
