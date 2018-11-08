{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "container-utils";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/scripts &&
      cp * $out/scripts &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/container.sh $out/bin/container --set PATH ${lib.makeBinPath [ "/run/wrappers" nixos-container ]} &&
      true
  '';
}
