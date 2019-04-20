{
  pkgs ? import <nixpkgs> {},
} :
rec {
  configure-nixos = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "configure-nixos";
    src = ./derivations/configure-nixos;
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
  configure-nixos-backup = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "configure-nixos-backup";
    src = ./derivations/configure-nixos-backup;
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
  install-nixos-backup = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "install-nixos-backup";
    src = ./derivations/install-nixos-backup;
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
  nmcli-wifi = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "nmcli-wifi";
    src = ./derivations/nmcli-wifi;
    dependencies = [
      pkgs.networkmanager
    ];
  });
  pass = (import ./create-derivation.nix {
    pkgs = pkgs;
    name = "pass";
    src = ./derivations/pass;
    dependencies = [
      pkgs.coreutils
    ];
  });
}
