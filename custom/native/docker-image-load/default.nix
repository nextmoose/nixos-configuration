{ pkgs ? import <nixpkgs> {} }:
let
  atom = (import ../../docker/atom.nix {});
  kafka = (import ../../docker/kafka.nix {});
  node-runner = (import ../../docker/node-runner.nix {});
  zookeeper = (import ../../docker/zookeeper.nix {});
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
      ln --symbolic ${atom} ${kafka} ${node-runner} ${zookeeper} $out/lib &&
      makeWrapper \
        $out/scripts/docker-image-load.sh \
	$out/bin/docker-image-load \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pkgs.coreutils ]} \
	--set STORE_DIR "$out" &&
      true
  '';
}
