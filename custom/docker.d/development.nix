{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  docker-run-as-root = (import ../expressions/docker-run-as-root/default.nix { inherit pkgs; });
  development = (import ../native/development/default.nix { inherit pkgs; });
in
dockerTools.buildImage {
  name = "development";
  contents = [ shadow bash coreutils git emacs ];
  runAsRoot = ''
    ${dockerTools.shadowSetup}
    ${docker-run-as-root}/bin/runAsRoot
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ "${development}/bin/development" ];
    User = "user";
    WorkingDir = "/home/user";
  };
}