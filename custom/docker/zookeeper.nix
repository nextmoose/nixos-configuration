{ pkgs ? import <nixpkgs> {} }:
let
  zookeeper = (import ../native/zookeeper/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "zookeeper";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home &&
      useradd --create-home user &&
      true
  '';
  config = {
    cmd = [ "start-foreground" "zoo_sample.cfg" ];
    entrypoint = [ "${zookeeper}/bin/zookeeper" ];
    User = "user";
  };
}