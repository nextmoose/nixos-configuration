{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "kafka";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/kafka.sh \
	$out/bin/kafka \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pkgs.utillinux pkgs.coreutils ]} \
	&&
      true
  '';
}
