{
  pkgs ? import <nixpkgs> {},
  name,
  cmd ? [],
  entrypoint = ? []
}:
pkgs.dockerTools.buildImage {
  contents = [ ];
  name = "${name}";
  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}
      mkdir /home /tmp /usr &&
      mkdir /usr/bin &&
      useradd --create-home user &&
      chmod a+rwx /tmp &&
      ln --symbolic ${pkgs.bash}/bin/env /usr/bin &&
      true
  '';
  config = {
    cmd = ${cmd};
    entrypoint = ${entrypoint};
    User = "user";
  };
}
