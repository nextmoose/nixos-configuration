{ pkgs ? import <nixpkgs> {} }:
let
  emacs = (input ../docker/emacs.nix {});
in
pkgs.stdenv.mkDerivation rec {
  name = "initialization";
  src = ./src;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      mkdir $out/lib &&
      ln --symbolic ${emacs} $out/lib &&
      makeWrapper \
        $out/scripts/initialization.sh \
	$out/bin/initialization \
	--set PATH ${lib.makeBinPath [ pkgs.xorg.xhost "$out" ]} &&
      makeWrapper \
        $out/scripts/docker-image-load.sh \
	$out/bin/docker-image-load \
	--set PATH ${lib.makeBinPath [ pkgs.docker ]} \
	--set STORE_DIR "$out" &&
      true
  '';
}
