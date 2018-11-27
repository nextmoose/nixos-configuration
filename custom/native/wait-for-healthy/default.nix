{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "wait-for-healthy";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod --recursive 0500 $out/scripts/. &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/wait-for-healthy.sh \
	$out/bin/wait-for-healthy \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.docker ]} &&
      true
  '';
}

