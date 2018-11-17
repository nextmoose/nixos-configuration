{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "configuration-utils";
  src = ./src;
  buildInputs = [ makeWrapper which ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      which makeWrapper &&
      makeWrapper $out/scripts/build-phase.sh $out/bin/build-phase --set PATH ${lib.makeBinPath [ coreutils which ]} &&
      makeWrapper $out/scripts/install-phase.sh $out/bin/install-phase --set PATH ${lib.makeBinPath [ bash coreutils ]} &&
      true
  '';
}
