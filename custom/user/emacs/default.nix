{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "emacs";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/emacs.sh $out/bin/emacs2 --set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} &&
      true
  '';
}
