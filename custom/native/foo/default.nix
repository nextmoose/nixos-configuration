{ pkgs ? import <nixpkgs> {} }:
let
  sleep-forever = (import ../sleep-forever/default.nix {
    pkgs = pkgs;
  } );
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
	      --set PATH ${pkgs.lib.makeBinPath [ sleep-forever ]} &&
      true
  '';
}
