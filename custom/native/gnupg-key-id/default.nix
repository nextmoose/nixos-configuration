{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "gnupg-key-id";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/gnupg-key-id.sh \
	$out/bin/gnupg-key-id \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.gnupg pkgs.coreutils pkgs.gnugrep ]} &&
      true
  '';
}
