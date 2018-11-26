{ pkgs ? import <nixpkgs> {} }:
pkgs.dockerTools.buildImage {
  name = "pass";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home &&
      useradd --create-home user &&
      true
  '';
  config = {
    cmd = [ ];
    entrypoint = [ "${pkgs.pass}/bin/pass" ];
    User = "user";
  };
}