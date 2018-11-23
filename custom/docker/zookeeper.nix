{ pkgs ? import <nixpkgs> {} }:
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
    entrypoint = [ "${pkgs.zookeeper}/bin/zkServer.sh" ];
    User = "user";
  };
}