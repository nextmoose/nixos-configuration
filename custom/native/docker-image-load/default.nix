{ pkgs ? import <nixpkgs> {} }:
let
  emacs = (import ../../docker/emacs.nix {});
  react-space = (import ../../docker/react-space.nix {});
in
pkgs.stdenv.mkDerivation rec {
  name = "docker-image-load";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      mkdir $out/lib &&
      ln --symbolic ${emacs} ${react-space} $out/lib/emacs.tar.gz &&
      makeWrapper \
        $out/scripts/docker-image-load.sh \
	$out/bin/docker-image-load \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pkgs.coreutils ]} \
	--set STORE_DIR "$out" &&
      true
  '';
}
