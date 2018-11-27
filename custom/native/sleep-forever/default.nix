{ pkgs ? import <nixpkgs> {} }:
let
  set-healthy = (import ../set-healthy/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "sleep-forever";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod --recursive 0500 $out/scripts/. &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/sleep-forever.sh \
	$out/bin/sleep-forever \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils set-healthy ]} &&
      true
  '';
}

