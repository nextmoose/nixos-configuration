{
  pkgs ? import <nixpkgs> {},
  name,
  image
}:
{
  description = "X3 Docker Image Pull -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "forking";
    ExecStart = "${pkgs.coreutils}/bin/cat ${image} | ${pkgs.docker}/bin/docker image ls";
  };
  wantedBy = [ "default.target"];
}
