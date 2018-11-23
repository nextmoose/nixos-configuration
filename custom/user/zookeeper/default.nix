{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "zookeeper";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/zookeeper.sh \
	$out/bin/zookeeper \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} \
	&&
      true
  '';
}
