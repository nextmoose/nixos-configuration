{ pkgs ? import <nixpkgs> {} }:
let
  alpha-pass = (import ../alpha-pass/default.nix {});
in
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
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker alpha-pass ]} \
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
  makeWrapper \
    $out/scripts/atom.sh \
$out/bin/atom-configuration \
--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker alpha-pass ]} \
--set COMMITTER_NAME "Emory Merryman" \
--set COMMITTER_EMAIL "emory.merryman@gmail.com" \
--set UPSTREAM_HOST github.com \
--set UPSTREAM_USER git \
--set UPSTREAM_PORT 22 \
--set UPSTREAM_ORGANIZATION rebelplutonium \
--set UPSTREAM_REPOSITORY nixos-configuration \
--set UPSTREAM_BRANCH master \
--set ORIGIN_HOST github.com \
--set ORIGIN_USER git \
--set ORIGIN_PORT 22 \
--set ORIGIN_ORGANIZATION nextmoose \
--set ORIGIN_REPOSITORY nixos-configuration \
--set ORIGIN_BRANCH level-5 \
--set REPORT_HOST github.com \
--set REPORT_USER git \
--set REPORT_PORT 22 \
--set REPORT_ORGANIZATION rebelplutonium \
--set REPORT_REPOSITORY nixos-configuration \
--set REPORT_BRANCH master \
&&
makeWrapper \
  $out/scripts/atom.sh \
$out/bin/atom-installation \
--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker alpha-pass ]} \
--set COMMITTER_NAME "Emory Merryman" \
--set COMMITTER_EMAIL "emory.merryman@gmail.com" \
--set UPSTREAM_HOST github.com \
--set UPSTREAM_USER git \
--set UPSTREAM_PORT 22 \
--set UPSTREAM_ORGANIZATION rebelplutonium \
--set UPSTREAM_REPOSITORY nixos-installer \
--set UPSTREAM_BRANCH master \
--set ORIGIN_HOST github.com \
--set ORIGIN_USER git \
--set ORIGIN_PORT 22 \
--set ORIGIN_ORGANIZATION nextmoose \
--set ORIGIN_REPOSITORY nixos-installer \
--set ORIGIN_BRANCH scratch/a655c542-f64f-4b6b-b5fc-cf0cec741b7a \
--set REPORT_HOST github.com \
--set REPORT_USER git \
--set REPORT_PORT 22 \
--set REPORT_ORGANIZATION rebelplutonium \
--set REPORT_BRANCH master \
&&
      true
  '';
}
