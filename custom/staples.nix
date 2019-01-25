{ pkgs ? import <nixpkgs>{} }:
rec {
  installed-pass = (import ./installed/pass/default.nix{
    pkgs = pkgs;
  });
  gnupg-key-id = (import ../custom/utils/custom-script-derivation.nix {
    pkgs = pkgs;
    name = "gnupg-key-id";
    src = ../custom/scripts/gnupg-key-id;
    dependencies = [ pkgs.coreutils pkgs.gnupg ];
  });
  encrypt-to-s3 = (import ../utils/custom-script-derivation.nix{
    pkgs = pkgs;
    name = "encrypt-to-s3";
    src = ../scripts/encrypt-to-s3;
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
  decrypt-from-s3 = (import ../utils/custom-script-derivation.nix{
    pkgs = pkgs;
    name = "decrypt-from-s3";
    src = ../scripts/decrypt-from-s3;
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
