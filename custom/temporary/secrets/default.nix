{ pkgs ? import <nixpkgs> {} }:
let
  old-secrets = (import ../../../installed/init-read-only-pass/default.nix {});
in
pkgs.stdenv.mkDerivation rec {
  name = "setup";
  src = ./src;
  buildInputs = [ pkgs.gnutar ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/lib &&
      tar xvzf ${old-secrets}/etc/secrets.tar.gz --director $out/lib &&
      cp --recursive scripts $out &&
      chmod 0500 out/$scripts &&
      makeWrapper \
        $out/scripts/import-gnupg-keys.sh \
	$out/bin/import-gnupg-keys \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.gnupg ]} \
	--set STORE_DIR "$out" \
	&&
      true
  '';
}
