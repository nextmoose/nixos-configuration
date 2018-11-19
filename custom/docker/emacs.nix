{ pkgs ? import <nixpkgs> {} }:
let
  emacs = (import ../native/emacs/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "emacs";
  config = {
    entrypoint = [ emacs ];
  };
}