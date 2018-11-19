{ pkgs ? import <nixpkgs> {} }:
let
  emacs = (import ../../docker/emacs.nix {});
in
pkgs.stdenv.mkDerivation rec {
  name = "initialization";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      mkdir $out/lib &&
      ln --symbolic ${emacs} $out/lib/emacs.tar.gz &&
      makeWrapper \
        $out/scripts/initialization.sh \
	$out/bin/initialization \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.xorg.xhost "$out" ]} &&
      makeWrapper \
        $out/scripts/docker-image-load.sh \
	$out/bin/docker-image-load \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pkgs.coreutils ]} \
	--set STORE_DIR "$out" &&
      true
  '';
}
