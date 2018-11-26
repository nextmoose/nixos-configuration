{ pkgs ? import <nixpkgs> {} }:
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
	$out/bin/alpha-pass \
	--set CANONICAL_HOST "github.com" \
	--set CANONICAL_ORGANIZATION "nextmoose" \
	--set CANONICAL_REPOSITORY "secrets" \
	--set CANONICAL_BRANCH "master" \
	--set UUID "d41dccd2-24bb-41ed-bb5e-1c0ff669e26d" \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} &&
      true
  '';
}
