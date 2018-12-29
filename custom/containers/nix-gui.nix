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
    sound.enable = true;
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        development-environment-init
        pkgs.atom
        pkgs.gvfs-trash
        pkgs.glib.dev
      ];
    };
  };
  tmpfs = [ "/home" ];
}
