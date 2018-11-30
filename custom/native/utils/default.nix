{ pkgs ? import <nixpkgs> {} }:
let
  docker-image-pull = (import ../docker-image-load/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "utils";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out/scripts &&
      chmod 0500 $out/scripts/* &&
      mkdir $out/bin &&
      makeWrapper \
        $out/scripts/docker-system-prune.sh \
	$out/bin/docker-system-prune \
	--set PATH ${pkgs.lib.makeBinPath [ pkgs.docker pkgs.coreutils ]} \
	--set STORE_DIR "$out" &&
      true &&
      makeWrapper \
        $out/scripts/update-system.sh \
	$out/bin/update-system \
	--set PATH ${pkgs.lib.makeBinPath [ "/run/wrappers" "/run/current-system/sw" pkgs.coreutils pkgs.rsync pkgs.mktemp pkgs.nix pkgs.docker docker-image-pull pkgs.mktemp pkgs.git ]} \
	--set STORE_DIR "$out" &&
      true
  '';
}
