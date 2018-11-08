{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "restart-containers";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp restart-containers.sh $out/scripts &&
      chmod 0500 $out/scripts/restart-containers.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/restart-containers.sh $out/bin/restart-containers --set PATH ${lib.makeBinPath [ nixos-container sudo coreutils ]} &&
      true
  '';
}
