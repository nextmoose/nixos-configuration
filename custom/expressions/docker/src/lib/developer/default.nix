{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  xxx = (import ./xxx/default.nix { inherit pkgs; });
in
dockerTools.buildImage {
  name = "developer";
  contents = [ shadow bash coreutils ];
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
    Entrypoint = [ "${xxx}/bin/entrypoint" ] ;
    User = "user" ;
    WorkingDir = "/home/user" ;
  };
}
