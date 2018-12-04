{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "initialization";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/initialization.sh \
	$out/bin/initialization \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.xorg.xhost pkgs.coreutils pkgs.networkmanager pkgs.gnugrep pkgs.gnused ]} &&
      true
  '';
}
