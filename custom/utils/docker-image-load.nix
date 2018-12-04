{
  pkgs ? import <nixpkgs> {},
  name
}:
{
  description = "XXX Docker Image Pull -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "forking";
    ExecStart = "${pkgs.docker}/bin/docker image ls";
  };
  wantedBy = [ "default.target"];
}
