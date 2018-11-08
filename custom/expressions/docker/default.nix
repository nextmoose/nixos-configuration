{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "docker";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive lib $out/lib &&
      mkdir $out/scripts &&
      cp *.sh $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/configure-docker.sh $out/bin/configure-docker --set PATH ${lib.makeBinPath [ coreutils docker nix ]} --set STORE_DIR "$out" &&
      true
  '';
}
