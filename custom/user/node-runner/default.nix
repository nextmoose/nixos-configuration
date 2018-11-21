{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "node-runner";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/node-runner.sh \
	$out/bin/node-runner \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} \
	&&
      true
  '';
}
