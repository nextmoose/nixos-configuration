{
  pkgs ? import <nixpkgs> {},
  development-environment-init
}:
{
  bindMounts = {
    "/srv/host" = {
      hostPath = "/";
      isReadOnly = true;
    };
    "/srv/home" = {
      hostPath = "/home/user";
      isReadOnly = false;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0.0";
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        development-environment-init
        pkgs.jdk10
        pkgs.maven
        pkgs.geany
        pkgs.jetbrains.idea-community
        pkgs.jedit
        pkgs.tomcat9
      ];
    };
  };
  tmpfs = [ "/home" ];
}
