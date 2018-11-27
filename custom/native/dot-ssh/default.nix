{ pkgs ? import <nixpkgs> {} }:
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
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.gnugrep ]} &&
      true
  '';
}
