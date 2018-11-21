{ pkgs ? import <nixpkgs> {} }:
let
  atom = (import ../../docker/atom.nix {});
  emacs = (import ../../docker/emacs.nix {});
  node-push-runner = (import ../../docker/node-push-runner.nix {});
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
      ln --symbolic ${atom} ${emacs} ${node-push-runner} ${react-space} $out/lib &&
      makeWrapper \
        $out/scripts/docker-image-load.sh \
	$out/bin/docker-image-load \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pkgs.coreutils ]} \
	--set STORE_DIR "$out" &&
      true
  '';
}
