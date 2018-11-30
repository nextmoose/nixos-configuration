{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "validate-not-blank";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod --recursive 0500 $out/scripts/. &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/validate-not-blank.sh \
	$out/bin/validate-not-blank \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils ]} &&
      true
  '';
}

