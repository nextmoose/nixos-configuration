{ pkgs ? import <nixpkgs> {} }:
pkgs.dockerTools.buildImage {
  name = "pass";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp &&
      useradd --create-home user &&
      chmod 0777 /tmp &&
      true
  '';
  config = {
    cmd = [ ];
    entrypoint = [ "${pkgs.pass}/bin/pass" ];
    User = "user";
  };
}