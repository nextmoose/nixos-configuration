{ pkgs ? import <nixpkgs> {} }:
let
  alpha-pass = (import ../alpha-pass/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "chromium";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/chromium.sh \
	$out/bin/xchromium \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker alpha-pass ]} &&
      true
  '';
}
