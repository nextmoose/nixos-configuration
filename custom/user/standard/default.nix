{ pkgs ? import <nixpkgs> {} }:
let
  emacs = (import ../../docker/emacs.nix {});
in
pkgs.stdenv.mkDerivation rec {
  name = "standard";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/lib &&
      cat "${emacs}" > $out/lib/emacs.tar.gz &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/initialize.sh $out/bin/initialize --set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} &&
      true
  '';
}
