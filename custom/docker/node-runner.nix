{ pkgs ? import <nixpkgs> {} }:
let
  node-runner = (import ../native/node-runner/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "node-runner";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home &&
      useradd --create-home user &&
      mkdir /usr &&
      mkdir /usr/bin &&
      ln --symbolic ${pkgs.coreutils}/bin/env /usr/bin &&
      true
  '';
  config = {
    entrypoint = [ "${node-runner}/bin/node-runner" ];
    User = "user";
  };
}