{ pkgs ? import <nixpkgs> {} }:
let
  kafka = (import ../native/kafka/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "kafka";
  contents = [ pkgs.shadow ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home &&
      useradd --create-home user &&
      true
  '';
  config = {
    cmd = [ ];
    entrypoint = [ "${kafka}/bin/kafka" ];
    User = "user";
  };
}