{ pkgs ? import <nixpkgs> {} }:
let
  secrets = (import ../../temporary/secrets/read-only-pass/default.nix {} );
  gnupg-key-id = (import ../gnupgp-key-id/default.nix {});
in
pkgs.stdenv.mkDerivation rec {
  name = "utilities";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/init-read-only-pass.sh \
	$out/bin/init-read-only-pass \
	--set PATH ${pkgs.lib.makeBinPath [ secrets pkgs.pass gnupg-key-id pkgs.coreutils ]} &&
      true
  '';
}
