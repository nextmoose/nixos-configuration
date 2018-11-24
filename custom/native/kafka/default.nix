{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "kafka";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts lib $out &&
      chmod --recursive 0500 $out/scripts/. &&
      chmod 0400 $out/libs/server.conf &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/kafka.sh \
	$out/bin/kafka \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.apacheKafka ]} \
	--set STORE_DIR "$out" \
	&&
      true
  '';
}

