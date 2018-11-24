{ pkgs ? import <nixpkgs> {} }:
let
  kafka = (import ../native/kafka/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "kafka";
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
    entrypoint = [ "${kafka}/bin/kafka" ];
    User = "user";
  };
}