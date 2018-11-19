{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "react-space";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/react-space.sh \
	$out/bin/react-space \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} \
	&&
      true
  '';
}
