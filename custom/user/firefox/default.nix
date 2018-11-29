{ pkgs ? import <nixpkgs> {} }:
let
  alpha-pass = (import ../alpha-pass/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "firefox";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/firefox.sh \
	$out/bin/xfirefox \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker alpha-pass ]} &&
      true
  '';
}
