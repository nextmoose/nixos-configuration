{
  pkgs ? import <nixpkgs> {}
} :
rec {
  configure-nixos = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "configure-nixos";
    src = ./rescue/configure-nixos;
    dependencies = [
      pkgs.coreutils
      pkgs.git
      pkgs.rsync
      pass
      pkgs.gnutar
      pkgs.mkpasswd
      pkgs.gnused
    ];
  });
  install-nixos = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "install-nixos";
    src = ./derivations/install-nixos;
    dependencies = [
      pkgs.mktemp
      configure-nixos
      pkgs.gnused
      pkgs.gnugrep
      pkgs.systemd
      pkgs.which
      pkgs.rsync
      pkgs.coreutils
    ];
  });
}
