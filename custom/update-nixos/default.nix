{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
stdenv.mkDerivation rec {
  name = "update-nixos";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp update-nixos.sh $out/scripts &&
      chmod 0500 $out/scripts/update-nixos.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/update-nixos.sh $out/bin/update-nixos --set PATH ${lib.makeBinPath [ coreutils rsync ]} &&
      true
  '';
}
