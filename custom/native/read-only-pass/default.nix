{ pkgs ? import <nixpkgs> {} }:
let
  gnupg-key-id = (import ../gnupgp-key-id/default.nix {});
  gnupg-import = (import ../gnupgp-import/default.nix {});
  sleep-forever = (import ../sleep-forever/default.nix {});
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
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.pass gnupg-key-id pkgs.coreutils gnupg-import sleep-forever ]} &&
      true
  '';
}
