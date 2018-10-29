{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "docker";
  src = ./src;
  buildInputs = [ makeWrapper ];
  buildPhase = ''
    nix-build simple.nix
  '';
  installPhase = ''
  '';
}
