{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  initialization-utils = (import ../initialization-utils/default.nix { inherit pkgs; });
in
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
      makeWrapper $out/scripts/dearchive.sh $out/bin/dearchive --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 gnutar gzip cdrkit cdi2iso 	mdf2iso ccd2iso libisofs dvdisaster gnupg awscli ]} &&
      makeWrapper $out/scripts/archive.sh $out/bin/archive --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 gnutar gzip cdrkit cdi2iso 	mdf2iso ccd2iso libisofs dvdisaster gnupg awscli ]} &&
      makeWrapper $out/scripts/bucket.sh $out/bin/bucket --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 gnutar gzip cdrkit cdi2iso mdf2iso ccd2iso libisofs dvdisaster gnupg awscli initialization-utils ]} &&
      makeWrapper $out/scripts/restore.sh $out/bin/restore --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 gnutar gzip cdrkit cdi2iso mdf2iso ccd2iso libisofs dvdisaster gnupg awscli initialization-utils ]} &&
      makeWrapper $out/scripts/debucket.sh $out/bin/debucket --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 gnutar gzip cdrkit cdi2iso mdf2iso ccd2iso libisofs dvdisaster gnupg awscli initialization-utils ]} &&
      makeWrapper $out/scripts/snapshot.sh $out/bin/snapshot --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 rsync ]} &&
      makeWrapper $out/scripts/test.sh $out/bin/test-backup-utils --set PATH ${lib.makeBinPath [ "/run/wrappers" coreutils utillinux lvm2 rsync "$out" e2fsprogs gnupg bash diffutils ]} &&
      true
  '';
}
