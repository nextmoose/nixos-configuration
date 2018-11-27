{ pkgs ? import <nixpkgs> {} }:
let
  atom = (import ../../docker/atom.nix {});
  read-only-pass = (import ../../docker/read-only-pass.nix {});
  pass = (import ../../docker/pass.nix {});
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
      ln --symbolic ${atom} ${read-only-pass} ${pass} $out/lib &&
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
