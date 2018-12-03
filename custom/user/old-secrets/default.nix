{ pkgs ? import <nixpkgs> {} }:
let
  pass = (import ../../../installed/pass/default.nix {});
  wait-for-healthy = (import ../../native/wait-for-healthy/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "old-secrets";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/pass.sh \
	$out/bin/old-secrets \
	--set COMMITTER_NAME "Emory Merryman" \
	--set COMMITTER_EMAIL "emory.merryman@gmail.com" \
	--set ORIGIN_HOST "github.com" \
	--set ORIGIN_USER "git" \
	--set ORIGIN_PORT "22" \
	--set ORIGIN_ORGANIZATION "desertedscorpion" \
	--set ORIGIN_REPOSITORY "passwordstore" \
	--set ORIGIN_BRANCH "master" \
	--set UUID "fb3abe9d-b3c1-4bc5-a926-907fdce8c722" \
  --set ORIGIN_ID_RSA "$(${pass}/bin/pass show origin.id_rsa)" \
  --set ORIGIN_KNOWN_HOSTS "$(${pass}/bin/pass show origin.id_rsa)" \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pass pkgs.coreutils wait-for-healthy ]} &&
      true
  '';
}
