{ pkgs ? import <nixpkgs>{} }:
rec {
  aws-cli-init = (import ./utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "aws-cli-init";
    src = ./scripts/aws-cli-init;
    dependencies = [ pkgs.coreutils pkgs.awscli ];
  });
  installed-pass = (import ../installed/pass/default.nix{
    pkgs = pkgs;
  });
  gnupg-key-id = (import ./utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "gnupg-key-id";
    src = ./scripts/gnupg-key-id;
    dependencies = [ pkgs.coreutils pkgs.gnupg ];
  });
  encrypt-to-s3 = (import ./utils/custom-script-derivation.nix{
    pkgs = pkgs;
    name = "encrypt-to-s3";
    src = ./scripts/encrypt-to-s3;
    dependencies = [
      pkgs.coreutils
      pkgs.gnutar
      pkgs.gzip
      pkgs.gnupg
      pkgs.cdrkit
      pkgs.dvdisaster
      pkgs.awscli
      gnupg-key-id
      pkgs.mktemp
    ];
  });
  decrypt-from-s3 = (import ./utils/custom-script-derivation.nix{
    name = "decrypt-from-s3";
    src = ./scripts/decrypt-from-s3;
    dependencies =  [
      pkgs.kmod-debian-aliases
      pkgs.coreutils
      pkgs.gnutar
      pkgs.gzip
      pkgs.gnupg
      pkgs.cdrkit
      pkgs.dvdisaster
      pkgs.awscli
      gnupg-key-id
      pkgs.mktemp
      pkgs.fuseiso
      pkgs.kmod
      pkgs.utillinux
      pkgs.xorriso
    ];
  });
}
