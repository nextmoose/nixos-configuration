{ pkgs ? import <nixpkgs> {} }:
with pkgs;
dockerTools.buildImage {
  name = "developer";
  contents = [ shadow bash ];
  runAsRoot = ''
     #!${stdenv.shell}
     ${dockerTools.shadowSetup}
     mkdir /home /tmp &&
       useradd --create-home user &&
       chmod a+rwx /tmp &&
       true
  '';
  config = {
    Cmd = [ ] ;
    Entrypoint = [ "${bash}/bin/bash" ] ;
    User = "user" ;
    WorkingDir = "/home/user" ;
  };
}
