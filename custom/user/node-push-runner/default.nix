{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "node-push-runner";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/node-push-runner.sh \
	$out/bin/node-push-runner \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} \
	&&
      true
  '';
}
