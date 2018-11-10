{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  docker-run-as-root = (import ../expressions/docker-run-as-root/default.nix { inherit pkgs; });
in
dockerTools.buildImage {
  name = "development";
  contents = [ shadow bash coreutils ];
  runAsRoot = "${docker-run-as-root}/bin/runAsRoot";
  config = {
    Cmd = [ ];
    Entrypoint = [ bash ];
    User = "user";
    WorkingDir = "/home/user";
  };
}