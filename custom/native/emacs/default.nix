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
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.gnupg pkgs.pass pkgs.git pkgs.emacs pkgs.coreutils pkgs.bash git-curt pkgs.which post-commit nodejs ]} \
	--set SECRETS_DIR "${secrets}" \
	&&
      true
  '';
}
