{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "git-refresh";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod --recursive 0500 $out/scripts/. &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/git-refresh \
	$out/bin/git-refresh \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.git ]} &&
      true
  '';
}

