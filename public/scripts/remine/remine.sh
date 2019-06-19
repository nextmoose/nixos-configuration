#!/sh

showit() {
    echo &&
	echo "${@}" &&
	pass show "${@}" &&
	true
} &&
showit passphrase &&
    showit passphrases/report.id_rsa &&
    showit passwords/001 &&
    showit passwords/002 &&
    showit passwords/003 &&
    showit passwords/004 &&
    showit passwords/005 &&
    showit passwords/006 &&
    showit passwords/007 &&
    showit passwords/008 &&
    showit passwords/009 &&
    showit slack.com/Emory@Remine.com &&
    showit www.office.com/Emory@Remine.com &&
    true
