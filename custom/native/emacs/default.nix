{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
pkgs.stdenv.mkDerivation rec {
  name = "emacs";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper $out/scripts/emacs.sh $out/bin/emacs --set PATH ${lib.makeBinPath [ pkgs.gnupg ]} &&
      true
  '';
}
