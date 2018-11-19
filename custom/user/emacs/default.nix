{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "emacs";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/emacs.sh \
	$out/bin/emacs2 \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} \
	--set CANONICAL_HOST github.com \
	--set CANONICAL_ORGANIZATION nextmoose \
	--set CANONICAL_REPOSITORY secrets \
	--set CANONICAL_BRANCH master \
	--set COMMITTER_NAME "Emory Merryman" \
	--set COMMITTER_EMAIL "emory.merryman@gmail.com" \
	--set ORIGIN_HOST github.com \
	--set ORIGIN_USER git \
	--set ORIGIN_PORT 22 \
	--set ORIGIN_ORGANIZATION nextmoose \
	--set ORIGIN_REPOSITORY nixos-configuration \
	--set ORIGIN_BRANCH level-5 \
	&&
      makeWrapper \
        $out/scripts/emacs.sh \
	$out/bin/emacs-ghastlywrenchserver \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} \
	--set CANONICAL_HOST github.com \
	--set CANONICAL_ORGANIZATION nextmoose \
	--set CANONICAL_REPOSITORY secrets \
	--set CANONICAL_BRANCH master \
	--set COMMITTER_NAME "Emory Merryman" \
	--set COMMITTER_EMAIL "emory.merryman@gmail.com" \
	--set ORIGIN_HOST github.com \
	--set ORIGIN_USER git \
	--set ORIGIN_PORT 22 \
	--set ORIGIN_ORGANIZATION nextmoose \
	--set ORIGIN_REPOSITORY ghastlywrenchserver \
	--set ORIGIN_BRANCH scratch/a3a0c237-5a84-4890-8a22-d7e224bea070 \
	&&
      makeWrapper \
        $out/scripts/emacs.sh \
	$out/bin/emacs-ghastlywrenchclient \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} \
	--set CANONICAL_HOST github.com \
	--set CANONICAL_ORGANIZATION nextmoose \
	--set CANONICAL_REPOSITORY secrets \
	--set CANONICAL_BRANCH master \
	--set COMMITTER_NAME "Emory Merryman" \
	--set COMMITTER_EMAIL "emory.merryman@gmail.com" \
	--set ORIGIN_HOST github.com \
	--set ORIGIN_USER git \
	--set ORIGIN_PORT 22 \
	--set ORIGIN_ORGANIZATION nextmoose \
	--set ORIGIN_REPOSITORY ghastlywrenchclient \
	--set ORIGIN_BRANCH scratch/a3a0c237-5a84-4890-8a22-d7e224bea070 \
	&&
      true
  '';
}
