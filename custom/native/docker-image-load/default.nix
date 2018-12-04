{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "docker-image-load";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      mkdir $out/bin &&
      makeWrapper \
        $out/bin/scripts/docker-image-load.sh \
        $out/bin/docker-image-load \
         --set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.docker ]} &&
       true
  '';
}
