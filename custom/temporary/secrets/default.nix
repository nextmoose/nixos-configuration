{ pkgs ? import <nixpkgs> {} }:
let
  old-secrets = (import ../../../installed/init-read-only-pass/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "setup";
  src = ./src;
  buildInputs = [ pkgs.gnutar pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/lib &&
      tar xvzf ${old-secrets}/etc/secrets.tar.gz --director $out/lib &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/* &&
      makeWrapper \
        $out/scripts/pass.sh \
	$out/bin/pass \
	--set STORE_DIR $out \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils ]} &&
      true
  '';
}
