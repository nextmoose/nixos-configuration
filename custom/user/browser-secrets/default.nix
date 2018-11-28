{ pkgs ? import <nixpkgs> {} }:
let
  alpha-pass = (import ../alpha-pass/default.nix {});
  wait-for-healthy = (import ../../native/wait-for-healthy/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "browser-secrets";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/pass.sh \
	$out/bin/browser-secrets \
	--set COMMITTER_NAME "Emory Merryman" \
	--set COMMITTER_EMAIL "emory.merryman@gmail.com" \
	--set ORIGIN_HOST "github.com" \
	--set ORIGIN_USER "git" \
	--set ORIGIN_PORT "22" \
	--set ORIGIN_ORGANIZATION "nextmoose" \
	--set ORIGIN_REPOSITORY "browser-secrets" \
	--set ORIGIN_BRANCH "master" \
	--set UUID "f684a398-2bc3-416a-b1f5-e1c8d60fc1b2" \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker alpha-pass pkgs.coreutils wait-for-healthy ]} &&
      true
  '';
}
