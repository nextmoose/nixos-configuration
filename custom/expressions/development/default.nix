{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  image = (import ../../docker.d/development.nix { inherit pkgs; });
in
stdenv.mkDerivation rec {
  name = "development";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/development.sh $out/bin/development --set PATH ${lib.makeBinPath [ docker coreutils "/run/wrappers" pass ]} --set IMAGE "${image}" &&
      true
  '';
}
