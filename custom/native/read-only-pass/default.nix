{ pkgs ? import <nixpkgs> {} }:
let
  gnupg-key-id = (import ../gnupg-key-id/default.nix {});
  gnupg-import = (import ../gnupg-import/default.nix {});
  sleep-forever = (import ../sleep-forever/default.nix {});
in
pkgs.stdenv.mkDerivation rec {
  name = "read-only-pass";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/read-only-pass.sh \
	$out/bin/read-only-pass \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.pass gnupg-key-id pkgs.coreutils gnupg-import sleep-forever ]} &&
      true
  '';
}
