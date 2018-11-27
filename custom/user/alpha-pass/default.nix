{ pkgs ? import <nixpkgs> {} }:
let
  secrets = (import ../../temporary/secrets/default.nix {});
  wait-for-healthy = (import ../../native/wait-for-healthy/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "alpha-pass";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/alpha-pass.sh \
	$out/bin/pass \
	--set CANONICAL_HOST "github.com" \
	--set CANONICAL_ORGANIZATION "nextmoose" \
	--set CANONICAL_REPOSITORY "secrets" \
	--set CANONICAL_BRANCH "master" \
	--set UUID "d41dccd2-24bb-41ed-bb5e-1c0ff669e26d" \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pkgs.mktemp pkgs.coreutils secrets pkgs.which wait-for-healthy ]} &&
      true
  '';
}
