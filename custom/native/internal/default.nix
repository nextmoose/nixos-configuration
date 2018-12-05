{pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "internal";
  src = ./src;
  buildInputs = [ pkgs.docker ];
  installPhase = ''
    mkdir $out &&
      cp scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir bin &&
      makeWrapper \
        out/scripts/docker-container-pass-start.sh
  '';
};
