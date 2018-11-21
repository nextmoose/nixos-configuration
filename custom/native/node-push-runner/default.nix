{ pkgs ? import <nixpkgs> {} }:
let
  node = (import ../node/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "node-push-runner";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      makeWrapper \
        $out/scripts/node-push-runner.sh \
        $out/bin/node-push-runner \
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.openssh node ]} \
        &&
      true
  '';
}
