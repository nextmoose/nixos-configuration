{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "gnupg-import";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod --recursive 0500 $out/scripts/. &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/gnupg-import.sh \
	$out/bin/gnupg-import \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.gnupg pkgs.mktemp pkgs.coreutils ]} &&
      true
  '';
}

