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
      makeWrapper $out/scripts/archive.sh $out/bin/archive --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 gnutar gzip cdrkit dvdisaster gnupg ]} &&
      makeWrapper $out/scripts/snapshot.sh $out/bin/snapshot --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 rsync ]} &&
      true
  '';
}
