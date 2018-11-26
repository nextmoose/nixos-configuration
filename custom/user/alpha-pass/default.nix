{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "alpha-pass";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/* &&
      makeWrapper \
        $out/alpha-pass.sh \
	$out/alpha-pass \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} &&
      true
  '';
}
