{ pkgs ? import <nixpkgs> {} }:
let
  entrypoint = pkgs.writeScript "entrypoint.sh" ''
     #!${pkgs.stdenv.shell}
     ${pkgs.chromium}/bin/chromium --disable-gpu
  '';
in
with pkgs;
dockerTools.buildImage {
  name = "webex";
  contents = [ pkgs.bash pkgs.chromium pkgs.coreutils gnugrep];
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
