{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "docker-container-start";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/docker-container-start.sh \
	         $out/bin/docker-container-start \
	          --set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} &&
      true
  '';
}
