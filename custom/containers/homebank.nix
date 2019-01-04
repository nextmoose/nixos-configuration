{
  pkgs ? import <nixpkgs> {},
  pass
}:
let
  gnupg-import = (import ../utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "gnupg-import";
    src = ../scripts/gnupg-import;
    dependencies = [ pkgs.gnucash pkgs.coreutils ];
  })
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
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      isNormalUser = true;
      packages = [
        (import ../utils/custom-script-derivation.nix {
          pkgs = pkgs;
          name = "homebank";
          src = ../scripts/homebank;
          dependencies = [ pkgs.homebank gnupg-import ];
        })
      ];
    };
  };
  tmpfs = [ "/home" ];
}
