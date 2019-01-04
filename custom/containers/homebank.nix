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
  });
  push-to-s3 = (import ../utils/custom-script-derivation.nix{
    pkgs = pkgs;
    name = "push-to-s3";
    src = ../scripts/push-to-s3;
    dependencies = [ pkgs.gnutar pkgs.gzip pkgs.gnupg pkgs.cdrecord pkgs.dvdisaster pkgs.awscli ];
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
        gnupg-import
      ];
    };
  };
  tmpfs = [ "/home" ];
}
