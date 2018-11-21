{ pkgs ? import <nixpkgs> {} }:
let
  node-push-runner = (import ../native/node-push-runner/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "node-push-runner";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp &&
      chmod a+rwx /tmp &&
      useradd --create-home user &&
      true
  '';
  config = {
    entrypoint = [ "${node-push-runner}/bin/node-push-runner" ];
    ExposedPorts = {
      "22/tcp" = {};
    };
    User = "user";
  };
}