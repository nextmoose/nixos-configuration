{ pkgs ? import <nixpkgs> {} }:
let
  gnupg-key-id = (import ../gnupg-key-id/default.nix{
    pkgs = pkgs;
  });
  gnupg-import = (import ../gnupg-import/default.nix{
    pkgs = pkgs;
  });
  sleep-forever = (import ../sleep-forever/default.nix {} );
in
pkgs.stdenv.mkDerivation {
  name = "foo";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/foo.sh \
	      $out/bin/foo \
	      --set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils gnupg-import gnupg-key-id sleep-forever ]} &&
      true
  '';
}
