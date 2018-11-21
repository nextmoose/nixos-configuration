{ pkgs ? import <nixpkgs> {} }:
let
  atom = (import ../native/atom/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "atom";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp &&
      chmod a+rwx /tmp &&
      useradd --create-home user &&
      true
  '';
  config = {
    entrypoint = [ "${atom}/bin/atom" ];
    User = "user";
  };
}