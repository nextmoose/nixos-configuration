{
  pkgs ? import <nixpkgs> {},
  name,
  entrypoint,
  cmd ? []
}:
let
  docker-image-load = (import ../native/docker-image-load/default.nix {} );
  image = pkgs.dockerTools.buildImage {
    name = name;
    runAsRoot = ''
      ${pkgs.dockerTools.shadowSetup}
        mkdir /home &&
        useradd --create-home user &&
        true
    '';
    config = {
      entrypoint = entrypoint;
      cmd = cmd;
      User = "user";
    };
  };
in
{
  description = "XE Docker Image Service -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.docker}/bin/docker image load --quiet --input ${image}";
    ExecStop = "${pkgs.docker}/bin/docker image rm --force ${name}";
  };
  wantedBy = [ "default.target"];
}
