{ pkgs ? import <nixpkgs> {} }:
let
  pass = (import ../../installed/pass/default.sh{
    pkgs = pkgs;
  });
in
pkgs.stdenv.mkDerivation {
  name = "dot-ssh";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/dot-ssh.sh \
	$out/bin/dot-ssh \
	--set PATH ${pkgs.lib.makeBinPath [ pass pkgs.coreutils pkgs.gnugrep ]} &&
      true
  '';
}
