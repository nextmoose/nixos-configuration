{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "alpha-pass";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    
  '';
}
