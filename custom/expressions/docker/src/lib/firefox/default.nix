{ pkgs ? import <nixpkgs> {} }:
let
  entrypoint = pkgs.writeScript "entrypoint.sh" ''
     #!${pkgs.stdenv.shell}
     ${pkgs.firefox}/bin/firefox
  '';
in
with pkgs;
dockerTools.buildImage {
  name = "firefox";
  contents = [ pkgs.bash pkgs.firefox ];
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
      mkdir /home /tmp &&
      ${pkgs.shadow}/bin/useradd --create-home user &&
      chmod a+rwx /tmp &&
      true
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
    WorkingDir = "/home/user";
  };
}
