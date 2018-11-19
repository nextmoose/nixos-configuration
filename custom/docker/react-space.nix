{ pkgs ? import <nixpkgs> {} }:
let
  react-space = (import ../native/react-space/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "react-space";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp &&
      chmod a+rwx /tmp &&
      useradd --create-home user
  '';
  config = {
    entrypoint = [ "${react-space}/bin/react-space" ];
    User = "user";
  };
}