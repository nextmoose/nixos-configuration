{ pkgs ? import <nixpkgs> {} }:
let
  fedora = pkgs.dockerTools.pullImage {
    imageName = "fedora";
    sha256 = "5891b5b522d5df086d0ff0b110fbd9d21bb4fc7163af34d08286a2e846f6be03";
  };
  entrypoint = pkgs.writeScript "entrypoint.sh" ''
     #!${pkgs.stdenv.shell}
     ${pkgs.gnucash}/bin/gnucash
  '';
in
with pkgs;
dockerTools.buildImage {
  name = "gnucash";
  fromImage = fedora;
  runAsRoot = ''
    dnf install --assumeyes gnucash &&
      adduser user &&
      true
  '';
  config = {
    Cmd = [ ];
    Entrypoint = [ entrypoint ];
    User = "user";
    WorkingDir = "/home/user";
  };
}
