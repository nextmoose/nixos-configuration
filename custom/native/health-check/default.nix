{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "health-check";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod --recursive 0500 $out/scripts/. &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/health-check.sh \
	$out/bin/health-check \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.bash ]} &&
      true
  '';
}

