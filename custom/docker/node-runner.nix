{ pkgs ? import <nixpkgs> {} }:
let
  node-runner = (import ../native/node-runner/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "node-runner";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp &&
      chmod a+rwx /tmp &&
      useradd --create-home user &&
      true
  '';
  config = {
    entrypoint = [ "${node-runner}/bin/node-runner" ];
    User = "user";
  };
}