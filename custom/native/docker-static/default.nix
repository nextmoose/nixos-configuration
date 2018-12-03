{ pkgs ? import <nixpkgs> {} }:
let
  emacs = (import ./docker/emacs.nix {
    pkgs = pkgs;
  });
in
pkgs.stdenv.mkDerivation rec {
  name = "docker-image-load";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp ${emacs} $out/lib &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/lib &&
      ln --symbolic ${emacs} $out/lib &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/docker-image-load.sh \
	$out/bin/docker-image-load \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pkgs.coreutils ]} \
	--set STORE_DIR "$out" &&
      true
      makeWrapper \
        $out/scripts/docker-system-prune.sh \
	$out/bin/docker-system-prune \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pkgs.coreutils ]} \
	--set STORE_DIR "$out" &&
      true
  '';
}
