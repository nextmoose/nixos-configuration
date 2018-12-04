{
  pkgs ? import <nixpkgs> {},
  name
}:
{
  description = "XXX Docker Image Pull -- ${name}";
  enable = true;
  serviceConfig = {
    Type = "forking";
    ExecStart = "${pkgs.coreutils}/bin/echo hi";
  };
  wantedBy = [ "default.target"];
}
