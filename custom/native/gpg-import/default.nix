{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "gpg-import";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod --recursive 0500 $out/scripts/. &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/gpg-import.sh \
	$out/bin/gpg-import \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.gnupg pkgs.mktemp]} &&
      true
  '';
}

