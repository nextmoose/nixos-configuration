{ pkgs ? import <nixpkgs> {} }:
let
  gnupg-key-id = (import ../gnupg-key-id/default.nix {});
  gnupg-import = (import ../gnupg-import/default.nix {});
  sleep-forever = (import ../sleep-forever/default.nix {});
  post-commit = (import ../post-commit/default.nix {});
  dot-ssh = (import ../dot-ssh/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "read-write-pass";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/read-write-pass.sh \
	$out/bin/read-write-pass \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.pass gnupg-key-id pkgs.coreutils gnupg-import sleep-forever post-commit pkgs.which dot-ssh ]} &&
      true
  '';
}
