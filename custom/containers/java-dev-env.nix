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
    security.sudo.wheelNeedsPassword = false;
    services.mingetty.autologinUser = "user";
    users.groups.wheel = {};
    users.groups.docker = {};
    users.extraUsers.user = {
      extraGroups = [ "docker" ];
      isNormalUser = true;
      packages = [
        development-environment-init
        pkgs.jdk10
        pkgs.maven
        pkgs.geany
        pkgs.jetbrains.idea-community
        pkgs.jedit
        pkgs.tomcat9
        pkgs.git
        pkgs.mariadb
        (import ../native/node/default.nix {
          pkgs = pkgs;
          })
      ];
    };
    virtualisation.docker.enable = true;
  };
#  tmpfs = [ "/home" ];
}
