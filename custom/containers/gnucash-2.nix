{
  pkgs ? import <nixpkgs> {},
  pass
}:
{
  bindMounts = {
    "/run/user/1000" = {
      hostPath = "/run/user/1000";
      isReadOnly = true;
    };
    "/home/user/.config/pulse" = {
      hostPath = "/home/user/.config/pulse";
      isReadOnly = true;
    };
  };
  config = { config, pkgs, ...}:
  {
    environment.variables.DISPLAY=":0.0";
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        (import ../native/gnucash/default.nix {
          pkgs = pkgs;
          pass = pass;
        })
      ];
    };
  };
#  tmpfs = [ "/home" ];
}
