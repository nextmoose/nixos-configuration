{ pkgs ? import <nixpkgs> {} }:
let
  pass = (import ../../installed/pass/default.nix {});
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
	--set COMMITTER_NAME "Emory Merryman" \
	--set COMMITTER_EMAIL "emory.merryman@gmail.com" \
	--set ORIGIN_HOST "github.com" \
	--set ORIGIN_USER "git" \
	--set ORIGIN_PORT "22" \
	--set ORIGIN_ORGANIZATION "nextmoose" \
	--set ORIGIN_REPOSITORY "secrets" \
	--set ORIGIN_BRANCH "master" \
	--set UUID "9cb093ed-91be-40f4-b478-6b4130e37aa0" \
  --set ORIGIN_ID_RSA "$(${pass}/bin/pass show origin.id_rsa)" \
  --set ORIGIN_KNOWN_HOSTS "$(${pass}/bin/pass show origin.id_rsa)" \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pass pkgs.coreutils wait-for-healthy ]} &&
      true
  '';
}
