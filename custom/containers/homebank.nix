{
  pkgs ? import <nixpkgs> {},
  pass
}:
let
  gnupg-import = (import ../utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "gnupg-import";
    src = ../scripts/gnupg-import;
    dependencies = [ pkgs.gnupg pkgs.coreutils pass ];
  });
  gnupg-key-id = (import ../utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "gnupg-key-id";
    src = ../scripts/gnupg-key-id;
    dependencies = [ pkgs.gnupg pkgs.coreutils ];
  });
  aws-cli-init = (import ../utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "aws-cli-init";
    src = ../scripts/aws-cli-init;
    dependencies = [ pkgs.coreutils pkgs.awscli pass ];
  });
  encrypt-to-s3 = (import ../utils/custom-script-derivation.nix{
    pkgs = pkgs;
    name = "encrypt-to-s3";
    src = ../scripts/encrypt-to-s3;
    dependencies = [ pkgs.gnutar pkgs.gzip pkgs.gnupg pkgs.cdrkit pkgs.dvdisaster pkgs.awscli gnupg-key-id pkgs.mktemp ];
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
        gnupg-key-id
        pkgs.gnupg pkgs.cdrkit pkgs.dvdisaster pkgs.awscli
        encrypt-to-s3
        pass
      ];
    };
  };
  tmpfs = [ "/home" ];
}
