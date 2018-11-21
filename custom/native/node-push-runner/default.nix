{ pkgs ? import <nixpkgs> {} }:
let
  node-push-runner = (import ../node-push-runner/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "node-push-runner";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      makeWrapper \
        $out/scripts/node-push-runner \
        $out/bin/node-push-runner \
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.openssh node-push-runner ]} \
        &&
      true
  '';
}
