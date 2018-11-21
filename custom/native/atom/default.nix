{ pkgs ? import <nixpkgs> {} }:
let
  secrets = (import ../../temporary/secrets/default.nix {});
  git-curt = (import ../git-curt/default.nix {});
  post-commit = (import ../post-commit/default.nix {});
in
pkgs.stdenv.mkDerivation rec {
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
	$out/bin/atom \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.gnupg pkgs.pass pkgs.git pkgs.atom pkgs.coreutils pkgs.bash git-curt pkgs.which post-commit ]} \
	--set SECRETS_DIR "${secrets}" \
	&&
      true
  '';
}

