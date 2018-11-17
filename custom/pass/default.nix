{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  image = dockerTools.buildImage {
    name = "xxx";
    config = {
      entrypoint = 
    };
  };
in
stdenv.mkDerivation rec {
  name = "setup";
  src = ./src;
  installPhase = ''
    mkdir $out &&
  '';
}
