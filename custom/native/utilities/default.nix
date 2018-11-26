{ pkgs ? import <nixpkgs> {} }:
let
  secrets = (import ../../temporary/secrets/default.nix);
in
pkgs.stdenv.mkDerivation rec {
  name = "utilities";
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
      makeWrapper \
        $out/scripts/init-read-only-pass.sh \
	$out/bin/init-read-only-pass \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.pass ]} \
	--set CANONICAL_HOST "github.com" \
	--set CANONICAL_ORGANIZATION "nextmoose" \
	--set CANONICAL_REPOSITORY "secrets" \
	--set CANONICAL_BRANCH "master" &&
      true
  '';
}
