{
  pkgs ? import <nixpkgs> {},
  name
}:
{
  description = "Docker Image Pull -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "forking";
    ExecStart = "${coreutils}/bin/echo hi";
  };
  wantedBy = [ "default.target"];
}
