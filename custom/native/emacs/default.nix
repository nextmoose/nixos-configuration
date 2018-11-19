{ pkgs ? import <nixpkgs> {} }:
let
  secrets = (import ../../temporary/secrets/default.nix {});
  git-curt = (import ../git-curt/default.nix {});
  post-commit = (import ../post-commit/default.nix {});
in
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
	$out/bin/emacs \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.gnupg pkgs.pass pkgs.git pkgs.emacs pkgs.coreutils pkgs.bash git-curt pkgs.which post-commit ]} \
	--set SECRETS_DIR "${secrets}" \
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
	--set ORIGIN_BRANCH level-5 &&
      true
  '';
}
