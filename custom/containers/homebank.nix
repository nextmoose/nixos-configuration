{
  pkgs ? import <nixpkgs> {},
  pass,
  encrypt-to-s3,
  decrypt-from-s3
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
in
{
  additionalCapabilities = [
    "CAP_SYS_ADMIN"
  ];
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
    environment.variables = {
      DISPLAY=":0.0";
      BUCKET = "063a969c-ebc4-49dc-9853-e2e0974132fb";
      ACCESS_KEY_ID = "AKIAJYGTH5EGV54AOYUA";
    };
    security.sudo.wheelNeedsPassword = false;
    services.mingetty.autologinUser = "user";
    users.extraUsers.user = {
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      packages = [
        (import ../utils/custom-script-derivation.nix {
          pkgs = pkgs;
          name = "homebank";
          src = ../scripts/homebank;
          dependencies = [ pkgs.homebank gnupg-import installed-pass encrypt-to-s3 decrypt-from-s3 ];
        })
        gnupg-import
        gnupg-key-id
        pkgs.gnupg pkgs.cdrkit pkgs.dvdisaster pkgs.awscli
        encrypt-to-s3
        decrypt-from-s3
        pass
        pkgs.archivemount
        pkgs.autofs5
        pkgs.bashmount
        pkgs.bindfs
        pkgs.pmount
        pkgs.s3fs
        pkgs.udevil
        pkgs.fuse-7z-ng
        pkgs.	p7zip
        pkgs.xorriso
      ];
    };
  };
  tmpfs = [ "/home" ];
}
