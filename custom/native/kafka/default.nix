{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "kafka";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod --recursive 0500 $out/scripts/. &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/kafka.sh \
	$out/bin/atom \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.apacheKafka ]} \
	&&
      true
  '';
}

