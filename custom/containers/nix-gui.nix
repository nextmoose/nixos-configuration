# ide container for nix
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
        (import ../other/atom/default.nix {
          pkgs = pkgs;
          atom-package = "git-plus";
        })
        pkgs.git
        pkgs.trash-cli
        pkgs.glib.dev
      ];
    };
  };
  tmpfs = [ "/home" ];
}
