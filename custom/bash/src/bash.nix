{ pkgs ? import <nixpkgs> {} }:
with pkgs;
dockerTools.buildImage {
  name = "bash";
  runAsRoot = ''
    ${dockerTools.shadowSetup}
    mkdir /home &&
      useradd --create-home user &&
      true
  '';
  contents = [ pkgs.bash ];
  config = {
    Cmd = [ ];
    Entrypoint = [ pkgs.bash ];
    User = "user";
  };
}