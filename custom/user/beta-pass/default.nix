{ pkgs ? import <nixpkgs> {} }:
let
  alpha-pass = (import ../alpha-pass/default.nix {});
  wait-for-healthy = (import ../../native/wait-for-healthy/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "beta-pass";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/pass.sh \
	$out/bin/pass \
	--set ORIGIN_HOST "github.com" \
	--set ORIGIN_ORGANIZATION "nextmoose" \
	--set ORIGIN_REPOSITORY "secrets" \
	--set ORIGIN_BRANCH "master" \
	--set UUID "9cb093ed-91be-40f4-b478-6b4130e37aa0" \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker alpha-pass pkgs.coreutils wait-for-healthy ]} &&
      true
  '';
}
