{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "backup-utils";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/dearchive.sh $out/bin/dearchive --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 gnutar gzip cdrkit cdi2iso 	mdf2iso ccd2iso libisofs dvdisaster gnupg aws ]} &&
      makeWrapper $out/scripts/archive.sh $out/bin/archive --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 gnutar gzip cdrkit cdi2iso 	mdf2iso ccd2iso libisofs dvdisaster gnupg aws ]} &&
      makeWrapper $out/scripts/snapshot.sh $out/bin/snapshot --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 rsync ]} &&
      makeWrapper $out/scripts/test.sh $out/bin/test-backup-utils --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 rsync "$out" ]} &&
      true
  '';
}
