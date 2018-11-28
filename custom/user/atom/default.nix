{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "atom";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/atom.sh \
	$out/bin/atom-yegor256-blog \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker ]} \
	--set COMMITTER_NAME "Emory Merryman" \
	--set COMMITTER_EMAIL "emory.merryman@gmail.com" \
	--set UPSTREAM_HOST github.com \
	--set UPSTREAM_USER git \
	--set UPSTREAM_PORT 22 \
	--set UPSTREAM_ORGANIZATION yegor256 \
	--set UPSTREAM_REPOSITORY blog \
	--set UPSTREAM_BRANCH master \
	--set ORIGIN_HOST github.com \
	--set ORIGIN_USER git \
	--set ORIGIN_PORT 22 \
	--set ORIGIN_ORGANIZATION nextmoose \
	--set ORIGIN_REPOSITORY 786f1166-5566-4b84-a208-25000902956e \
	--set REPORT_HOST github.com \
	--set REPORT_USER git \
	--set REPORT_PORT 22 \
	--set REPORT_ORGANIZATION yegor256 \
	--set REPORT_REPOSITORY blog \
	--set REPORT_BRANCH master \
	&&
      true
  '';
}
