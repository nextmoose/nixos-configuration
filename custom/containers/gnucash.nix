{
  pkgs ? import <nixpkgs> {},
  pass
}:
let
  initialization = (import ../initialization/gnucash/default.nix {
    pkgs = pkgs;
    pass = pass;
  });
in
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
    programs.bash.shellInit = "${initialization}/bin/gnucash --bucket 77fe28f8-1704-4219-8220-f8bc3ec0d204";
    service.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        pkgs.gnucash
      ];
    };
  };
#  tmpfs = [ "/home" ];
}
