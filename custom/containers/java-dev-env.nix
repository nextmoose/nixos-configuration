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
    "/var/run/docker.sock" = {
      hostPath = "/var/run/docker.sock";
      isReadOnly = false;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0.0";
    security.sudo.wheelNeedsPassword = false;
    services.mingetty.autologinUser = "user";
    users.groups.docker = {};
    users.groups.wheel = {};
    users.extraUsers.user = {
      extraGroups = [ "docker" "wheel" ];
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
        pkgs.docker
        pkgs.docker_compose
        (import ../native/node/default.nix {
          pkgs = pkgs;
          })
      ];
    };
  };
#  tmpfs = [ "/home" ];
}
