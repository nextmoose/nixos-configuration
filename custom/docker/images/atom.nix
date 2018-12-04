{ pkgs ? import <nixpkgs> {} }:
let
  atom = (import ../../atom/default.nix {});
  git-refresh = (import ../../git-refresh/default.nix {});
in
pkgs.dockerTools.buildImage {
  name = "atom";
  contents = [ pkgs.shadow pkgs.git git-refresh pkgs.bash pkgs.coreutils ];
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp /usr &&
      useradd --create-home user &&
      chmod a+rwx /tmp &&
      mkdir /usr/bin &&
      ln --symbolic ${pkgs.coreutils}/bin/env /usr/bin &&
      true
  '';
  config = {
    entrypoint = [ "${atom}/bin/atom" ];
    User = "user";
  };
}
