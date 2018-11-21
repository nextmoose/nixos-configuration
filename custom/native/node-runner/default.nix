{ pkgs ? import <nixpkgs> {} }:
let
  node = (import ../node/default.nix {});
in
pkgs.stdenv.mkDerivation {
  name = "node-runner";
  src = ./src;
  buildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir $out &&
      cp --recursive scripts $out &&
      chmod 0500 $out/scripts/*.sh &&
      makeWrapper \
        $out/scripts/node-runner.sh \
        $out/bin/node-runner \
        --set PATH ${pkgs.lib.makeBinPath [ pkgs.openssh node ]} \
        &&
      true
  '';
}
