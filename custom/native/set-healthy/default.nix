{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "set-healthy";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod --recursive 0500 $out/scripts/. &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/set-healthy.sh \
	$out/bin/set-healthy \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils ]} &&
      true
  '';
}

