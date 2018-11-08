{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "pass-utils";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/turnover.sh $out/bin/turnover --set PATH ${lib.makeBinPath [ mktemp coreutils gnupg pass findutils gnugrep ]} &&
      makeWrapper $out/scripts/email-id.sh $out/bin/email-id --set PATH ${lib.makeBinPath [ pass utillinux ]} &&
      true
  '';
}
